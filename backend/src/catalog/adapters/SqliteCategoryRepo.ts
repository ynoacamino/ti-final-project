import type { ICategoryRepository } from "../ports/out/ICategoryRepository.ts";
import { Category } from "../core/Category.ts";
import { db } from "../../shared/infrastructure/database/client.ts";
import { categories, products } from "../../shared/infrastructure/database/schema.ts";
import { eq, sql } from "drizzle-orm";

export class SqliteCategoryRepo implements ICategoryRepository {
  private toDomain(row: typeof categories.$inferSelect): Category {
    return new Category(
      row.id,
      row.name,
      row.slug,
      row.description,
      row.isActive === 1,
      row.createdAt,
      row.updatedAt,
    );
  }

  async findById(id: string): Promise<Category | null> {
    const [row] = await db.select().from(categories).where(eq(categories.id, id)).limit(1);

    return row ? this.toDomain(row) : null;
  }

  async findByName(name: string): Promise<Category | null> {
    const [row] = await db.select().from(categories).where(eq(categories.name, name)).limit(1);

    return row ? this.toDomain(row) : null;
  }

  async findBySlug(slug: string): Promise<Category | null> {
    const [row] = await db.select().from(categories).where(eq(categories.slug, slug)).limit(1);

    return row ? this.toDomain(row) : null;
  }

  async save(category: Category): Promise<void> {
    await db
      .insert(categories)
      .values({
        id: category.id,
        name: category.name,
        slug: category.slug,
        description: category.description,
        isActive: category.isActive ? 1 : 0,
        createdAt: category.createdAt,
        updatedAt: category.updatedAt,
      })
      .onConflictDoUpdate({
        target: categories.id,
        set: {
          name: category.name,
          slug: category.slug,
          description: category.description,
          isActive: category.isActive ? 1 : 0,
          updatedAt: new Date().toISOString(),
        },
      });
  }

  async listAll(): Promise<Category[]> {
    const rows = await db.select().from(categories);
    return rows.map((r) => this.toDomain(r));
  }

  async hasAssociatedProducts(categoryId: string): Promise<boolean> {
    const [row] = await db
      .select({ count: sql`count(*)` })
      .from(products)
      .where(eq(products.categoryId, categoryId))
      .limit(1);

    return Number(row?.count || 0) > 0;
  }

  async delete(id: string): Promise<void> {
    await db.delete(categories).where(eq(categories.id, id));
  }
}
