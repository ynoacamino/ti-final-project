import { ProductImage } from "../../core/ProductImage.ts";

export interface UploadProductImageDTO {
  productId: string;
  fileBuffer: Buffer;
  fileName: string;
  contentType: string;
}

export interface IUploadProductImageUseCase {
  execute(dto: UploadProductImageDTO): Promise<ProductImage>;
}
