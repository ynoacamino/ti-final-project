import type { Product } from "../../core/Product.ts";
import type { ProductImage } from "../../core/ProductImage.ts";
import type { ProductVariant } from "../../core/ProductVariant.ts";

export interface ListProductsParams {
  limit?: number;
  offset?: number;
  categorySlug?: string;
  search?: string;
  includeInactive?: boolean;
}

export interface IProductRepository {
  findById(id: string): Promise<Product | null>;
  findBySlug(slug: string): Promise<Product | null>;
  save(product: Product): Promise<void>;
  list(params: ListProductsParams): Promise<{ products: Product[]; total: number }>;
  saveImage(image: ProductImage): Promise<void>;
  deleteImage(id: string): Promise<void>;
  findVariantById(id: string): Promise<ProductVariant | null>;
  updateVariantStock(variantId: string, newStock: number): Promise<void>;
}
