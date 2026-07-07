import { Product } from "../../core/Product.ts";

export interface CreateProductVariantDTO {
  size: string;
  color: string;
  sku: string;
  stock?: number;
  additionalPrice?: number; // in cents
}

export interface CreateProductDTO {
  name: string;
  description?: string;
  basePrice: number; // in cents
  categoryId: string;
  variants: CreateProductVariantDTO[];
}

export interface ICreateProductUseCase {
  execute(dto: CreateProductDTO): Promise<Product>;
}
