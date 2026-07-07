import type {
  IUploadProductImageUseCase,
  UploadProductImageDTO,
} from "../ports/in/IUploadProductImageUseCase.ts";
import type { IProductRepository } from "../ports/out/IProductRepository.ts";
import type { IStorageService } from "../ports/out/IStorageService.ts";
import { ProductImage } from "./ProductImage.ts";

/**
 *
 */
export class UploadProductImageUseCase implements IUploadProductImageUseCase {
  /**
   *
   */
  constructor(
    private readonly productRepository: IProductRepository,
    private readonly storageService: IStorageService,
  ) {}

  /**
   *
   */
  async execute(dto: UploadProductImageDTO): Promise<ProductImage> {
    // 1. Validate: Product must exist
    const product = await this.productRepository.findById(dto.productId);
    if (!product) {
      throw new Error("Product not found");
    }

    // 2. Validate: Maximum 5 images per product
    if (product.images.length >= 5) {
      throw new Error("Product has reached the limit of 5 images");
    }

    // 3. Determine position
    const position = product.images.length;

    // 4. Generate unique key/filename for the storage bucket
    const uniqueId = crypto.randomUUID();
    const extension = dto.fileName.split(".").pop() || "jpg";
    const bucketKey = `products/${product.id}/${uniqueId}.${extension}`;

    // 5. Upload buffer to S3/R2 storage service
    const fileUrl = await this.storageService.upload(
      dto.fileBuffer,
      bucketKey,
      dto.contentType,
      dto.origin,
    );

    // 6. Create image domain entity
    const newImage = ProductImage.create({
      id: uniqueId,
      productId: product.id,
      url: fileUrl,
      position,
    });

    // 7. Save image info to DB
    await this.productRepository.saveImage(newImage);

    return newImage;
  }
}
