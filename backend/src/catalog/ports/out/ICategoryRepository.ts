import type { Category } from "../../core/Category.ts";

export interface ICategoryRepository {
  findById(id: string): Promise<Category | null>;
  findByName(name: string): Promise<Category | null>;
  findBySlug(slug: string): Promise<Category | null>;
  save(category: Category): Promise<void>;
  listAll(): Promise<Category[]>;
  hasAssociatedProducts(categoryId: string): Promise<boolean>;
  delete(id: string): Promise<void>;
}
