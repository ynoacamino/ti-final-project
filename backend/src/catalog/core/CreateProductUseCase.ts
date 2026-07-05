import type { ICreateProductUseCase, CreateProductDTO } from "../ports/in/ICreateProductUseCase.ts";
import type { IProductRepository } from "../ports/out/IProductRepository.ts";
import type { ICategoryRepository } from "../ports/out/ICategoryRepository.ts";
import { Product } from "./Product.ts";
import { ProductVariant } from "./ProductVariant.ts";
import { generateSlug } from "../../shared/utils/slug.ts";

/**
 *
 */
export class CreateProductUseCase implements ICreateProductUseCase {
  /**
   *
   */
  constructor(
    private readonly productRepository: IProductRepository,
    private readonly categoryRepository: ICategoryRepository,
  ) {}

  /**
   *
   */
  async execute(dto: CreateProductDTO): Promise<Product> {
    // 1. Validation: Base price must be greater than 0
    if (dto.basePrice <= 0) {
      throw new Error("Base price must be greater than 0");
    }

    // 2. Validation: Category must exist
    const category = await this.categoryRepository.findById(dto.categoryId);
    if (!category) {
      throw new Error("Category not found");
    }

    // 3. Validation: Unique combination of size and color per product
    const seenCombos = new Set<string>();
    for (const v of dto.variants) {
      const comboKey = `${v.size.toLowerCase()}_${v.color.toLowerCase()}`;
      if (seenCombos.has(comboKey)) {
        throw new Error(
          `Duplicate variant size and color combo found: Size: ${v.size}, Color: ${v.color}`,
        );
      }
      seenCombos.add(comboKey);
    }

    // 4. Generate Product ID and Slug
    const productId = crypto.randomUUID();
    const slug = generateSlug(dto.name);

    // 5. Create Domain Variants
    const domainVariants = dto.variants.map((v) =>
      ProductVariant.create({
        id: crypto.randomUUID(),
        productId,
        size: v.size,
        color: v.color,
        sku: v.sku,
        stock: v.stock ?? 0,
        additionalPrice: v.additionalPrice ?? 0,
      }),
    );

    // 6. Create Product entity
    const newProduct = Product.create({
      id: productId,
      name: dto.name,
      slug,
      description: dto.description,
      basePrice: dto.basePrice,
      categoryId: dto.categoryId,
      isActive: true,
      variants: domainVariants,
      images: [],
    });

    // 7. Persist to DB
    await this.productRepository.save(newProduct);

    return newProduct;
  }
}
