import type { IProductRepository, ListProductsParams } from "../ports/out/IProductRepository.ts";
import { Product } from "../core/Product.ts";
import { ProductVariant } from "../core/ProductVariant.ts";
import { ProductImage } from "../core/ProductImage.ts";
import { db } from "../../shared/infrastructure/database/client.ts";
import {
  products,
  productVariants,
  productImages,
  categories,
  cartItems,
} from "../../shared/infrastructure/database/schema.ts";
import { eq, like, and, sql, inArray } from "drizzle-orm";

/**
 *
 */
export class SqliteProductRepo implements IProductRepository {
  private toDomain(
    row: typeof products.$inferSelect,
    variantRows: Array<typeof productVariants.$inferSelect>,
    imageRows: Array<typeof productImages.$inferSelect>,
  ): Product {
    const variants = variantRows.map(
      (v) =>
        new ProductVariant(
          v.id,
          v.productId,
          v.size,
          v.color,
          v.sku,
          v.stock,
          v.additionalPrice,
          v.createdAt,
          v.updatedAt,
        ),
    );

    const images = imageRows.map(
      (img) => new ProductImage(img.id, img.productId, img.url, img.position, img.createdAt),
    );

    return new Product(
      row.id,
      row.name,
      row.slug,
      row.description,
      row.basePrice,
      row.categoryId,
      row.isActive === 1,
      row.createdAt,
      row.updatedAt,
      variants,
      images,
    );
  }

  /**
   *
   */
  async findById(id: string): Promise<Product | null> {
    const [row] = await db.select().from(products).where(eq(products.id, id)).limit(1);

    if (!row) return null;

    const variantRows = await db
      .select()
      .from(productVariants)
      .where(eq(productVariants.productId, id));

    const imageRows = await db.select().from(productImages).where(eq(productImages.productId, id));

    return this.toDomain(row, variantRows, imageRows);
  }

  /**
   *
   */
  async findBySlug(slug: string): Promise<Product | null> {
    const [row] = await db.select().from(products).where(eq(products.slug, slug)).limit(1);

    if (!row) return null;

    const variantRows = await db
      .select()
      .from(productVariants)
      .where(eq(productVariants.productId, row.id));

    const imageRows = await db
      .select()
      .from(productImages)
      .where(eq(productImages.productId, row.id));

    return this.toDomain(row, variantRows, imageRows);
  }

  /**
   *
   */
  async save(product: Product): Promise<void> {
    await db.transaction(async (tx) => {
      // 1. Insert/Update Product
      await tx
        .insert(products)
        .values({
          id: product.id,
          name: product.name,
          slug: product.slug,
          description: product.description,
          basePrice: product.basePrice,
          categoryId: product.categoryId,
          isActive: product.isActive ? 1 : 0,
          createdAt: product.createdAt,
          updatedAt: product.updatedAt,
        })
        .onConflictDoUpdate({
          target: products.id,
          set: {
            name: product.name,
            slug: product.slug,
            description: product.description,
            basePrice: product.basePrice,
            categoryId: product.categoryId,
            isActive: product.isActive ? 1 : 0,
            updatedAt: new Date().toISOString(),
          },
        });

      // 2. Insert/Update Variants
      for (const v of product.variants) {
        await tx
          .insert(productVariants)
          .values({
            id: v.id,
            productId: v.productId,
            size: v.size,
            color: v.color,
            sku: v.sku,
            stock: v.stock,
            additionalPrice: v.additionalPrice,
            createdAt: v.createdAt,
            updatedAt: v.updatedAt,
          })
          .onConflictDoUpdate({
            target: productVariants.id,
            set: {
              size: v.size,
              color: v.color,
              sku: v.sku,
              stock: v.stock,
              additionalPrice: v.additionalPrice,
              updatedAt: new Date().toISOString(),
            },
          });
      }
    });
  }

  /**
   *
   */
  async list(params: ListProductsParams): Promise<{ products: Product[]; total: number }> {
    const limit = params.limit ?? 10;
    const offset = params.offset ?? 0;

    const conditions = [];

    // Filter by category slug
    if (params.categorySlug) {
      const [category] = await db
        .select()
        .from(categories)
        .where(eq(categories.slug, params.categorySlug))
        .limit(1);

      if (category) {
        conditions.push(eq(products.categoryId, category.id));
      } else {
        // Category slug specified but not found: return empty
        return { products: [], total: 0 };
      }
    }

    // Filter by search query
    if (params.search) {
      conditions.push(like(products.name, `%${params.search}%`));
    }

    // Filter active items unless specified
    if (!params.includeInactive) {
      conditions.push(eq(products.isActive, 1));
    }

    const whereClause = conditions.length > 0 ? and(...conditions) : undefined;

    // Get total count
    const [countRow] = await db
      .select({ count: sql`count(*)` })
      .from(products)
      .where(whereClause);
    const total = Number(countRow?.count || 0);

    if (total === 0) {
      return { products: [], total: 0 };
    }

    // Fetch products
    const productRows = await db
      .select()
      .from(products)
      .where(whereClause)
      .limit(limit)
      .offset(offset);

    const productIds = productRows.map((p) => p.id);

    // Batch load variants and images to avoid N+1 queries
    const variantRows = await db
      .select()
      .from(productVariants)
      .where(inArray(productVariants.productId, productIds));

    const imageRows = await db
      .select()
      .from(productImages)
      .where(inArray(productImages.productId, productIds));

    const mappedProducts = productRows.map((row) => {
      const pVariants = variantRows.filter((v) => v.productId === row.id);
      const pImages = imageRows.filter((img) => img.productId === row.id);
      return this.toDomain(row, pVariants, pImages);
    });

    return {
      products: mappedProducts,
      total,
    };
  }

  /**
   *
   */
  async saveImage(image: ProductImage): Promise<void> {
    await db
      .insert(productImages)
      .values({
        id: image.id,
        productId: image.productId,
        url: image.url,
        position: image.position,
        createdAt: image.createdAt,
      })
      .onConflictDoUpdate({
        target: productImages.id,
        set: {
          url: image.url,
          position: image.position,
        },
      });
  }

  /**
   *
   */
  async deleteImage(id: string): Promise<void> {
    await db.delete(productImages).where(eq(productImages.id, id));
  }

  /**
   *
   */
  async findVariantById(id: string): Promise<ProductVariant | null> {
    const [row] = await db
      .select()
      .from(productVariants)
      .where(eq(productVariants.id, id))
      .limit(1);

    if (!row) return null;
    return new ProductVariant(
      row.id,
      row.productId,
      row.size,
      row.color,
      row.sku,
      row.stock,
      row.additionalPrice,
      row.createdAt,
      row.updatedAt,
    );
  }

  /**
   *
   */
  async updateVariantStock(variantId: string, newStock: number): Promise<void> {
    await db
      .update(productVariants)
      .set({
        stock: newStock,
        updatedAt: new Date().toISOString(),
      })
      .where(eq(productVariants.id, variantId));
  }

  /**
   * Deletes a product, its variants, and its images.
   */
  async delete(id: string): Promise<void> {
    await db.transaction(async (tx) => {
      // 0. Delete cart items referencing the variants of this product
      const variants = await tx
        .select({ id: productVariants.id })
        .from(productVariants)
        .where(eq(productVariants.productId, id));
      
      const variantIds = variants.map((v) => v.id);
      if (variantIds.length > 0) {
        await tx.delete(cartItems).where(inArray(cartItems.productVariantId, variantIds));
      }

      // 1. Delete product images
      await tx.delete(productImages).where(eq(productImages.productId, id));
      // 2. Delete product variants
      await tx.delete(productVariants).where(eq(productVariants.productId, id));
      // 3. Delete product
      await tx.delete(products).where(eq(products.id, id));
    });
  }
}
