import type { ProductVariant } from "./ProductVariant.ts";
import type { ProductImage } from "./ProductImage.ts";

/**
 * Represents a Product domain entity within the SmartPyME catalog.
 */
export class Product {
  constructor(
    public readonly id: string,
    public readonly name: string,
    public readonly slug: string,
    public readonly description: string | null,
    public readonly basePrice: number, // in cents
    public readonly categoryId: string,
    public readonly isActive: boolean,
    public readonly createdAt: string,
    public readonly updatedAt: string,
    public readonly variants: ProductVariant[] = [],
    public readonly images: ProductImage[] = [],
  ) {}

  public static create(params: {
    id: string;
    name: string;
    slug: string;
    description?: string | null;
    basePrice: number;
    categoryId: string;
    isActive?: boolean;
    createdAt?: string;
    updatedAt?: string;
    variants?: ProductVariant[];
    images?: ProductImage[];
  }): Product {
    const now = new Date().toISOString();
    return new Product(
      params.id,
      params.name,
      params.slug,
      params.description ?? null,
      params.basePrice,
      params.categoryId,
      params.isActive ?? true,
      params.createdAt ?? now,
      params.updatedAt ?? now,
      params.variants ?? [],
      params.images ?? [],
    );
  }
}
