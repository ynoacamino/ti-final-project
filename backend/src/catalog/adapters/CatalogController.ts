// @ts-nocheck
import { Hono } from "hono";
import { z } from "zod";
import { CreateCategoryUseCase } from "../core/CreateCategoryUseCase.ts";
import { CreateProductUseCase } from "../core/CreateProductUseCase.ts";
import { UploadProductImageUseCase } from "../core/UploadProductImageUseCase.ts";
import { SqliteCategoryRepo } from "./SqliteCategoryRepo.ts";
import { SqliteProductRepo } from "./SqliteProductRepo.ts";
import { StorageService } from "./StorageService.ts";
import { authMiddleware } from "../../shared/infrastructure/middleware/auth.ts";

export const catalogRouter = new Hono();

// Repositories and Services
const categoryRepo = new SqliteCategoryRepo();
const productRepo = new SqliteProductRepo();
const storageService = new StorageService();

// Use Cases
const createCategoryUseCase = new CreateCategoryUseCase(categoryRepo);
const createProductUseCase = new CreateProductUseCase(productRepo, categoryRepo);
const uploadProductImageUseCase = new UploadProductImageUseCase(productRepo, storageService);

// Validation Schemas
const createCategorySchema = z.object({
  name: z.string().min(2, "El nombre debe tener al menos 2 caracteres"),
  description: z.string().optional(),
});

const createProductSchema = z.object({
  name: z.string().min(2, "El nombre del producto debe tener al menos 2 caracteres"),
  description: z.string().optional(),
  basePrice: z.number().int().positive("El precio base debe ser mayor a 0"), // in cents
  categoryId: z.string().uuid("El id de la categoría debe ser un UUID válido"),
  variants: z
    .array(
      z.object({
        size: z.string().min(1, "La talla es obligatoria"),
        color: z.string().min(1, "El color es obligatorio"),
        sku: z.string().min(3, "El SKU debe tener al menos 3 caracteres"),
        stock: z.number().int().nonnegative("El stock no puede ser negativo").optional(),
        additionalPrice: z
          .number()
          .int()
          .nonnegative("El precio adicional no puede ser negativo")
          .optional(),
      }),
    )
    .min(1, "Debe tener al menos una variante"),
});

/**
 * 1. Create Category
 * POST /api/categories (Admin Only)
 */
catalogRouter.post("/categories", authMiddleware(["admin"]), async (c) => {
  try {
    const body = await c.req.json().catch(() => ({}));
    const validation = createCategorySchema.safeParse(body);
    if (!validation.success) {
      return c.json({ success: false, errors: validation.error.flatten().fieldErrors }, 400);
    }

    const category = await createCategoryUseCase.execute(validation.data);
    return c.json({ success: true, category }, 201);
  } catch (error: any) {
    return c.json({ success: false, error: error.message }, 400);
  }
});

/**
 * 2. List Categories
 * GET /api/categories (Public)
 */
catalogRouter.get("/categories", async (c) => {
  try {
    const list = await categoryRepo.listAll();
    return c.json({ success: true, categories: list }, 200);
  } catch (error: any) {
    return c.json({ success: false, error: error.message }, 500);
  }
});

/**
 * 3. Create Product
 * POST /api/products (Admin Only)
 */
catalogRouter.post("/products", authMiddleware(["admin"]), async (c) => {
  try {
    const body = await c.req.json().catch(() => ({}));
    const validation = createProductSchema.safeParse(body);
    if (!validation.success) {
      return c.json({ success: false, errors: validation.error.flatten().fieldErrors }, 400);
    }

    const product = await createProductUseCase.execute(validation.data);
    return c.json({ success: true, product }, 201);
  } catch (error: any) {
    return c.json({ success: false, error: error.message }, 400);
  }
});

/**
 * 4. List Products
 * GET /api/products (Public, with filters and search)
 */
catalogRouter.get("/products", async (c) => {
  try {
    const categorySlug = c.req.query("category");
    const search = c.req.query("q");
    const limit = c.req.query("limit") ? parseInt(c.req.query("limit")!) : 10;
    const offset = c.req.query("offset") ? parseInt(c.req.query("offset")!) : 0;
    const includeInactive = c.req.query("includeInactive") === "true";

    const result = await productRepo.list({
      categorySlug,
      search,
      limit,
      offset,
      includeInactive,
    });

    return c.json({ success: true, ...result }, 200);
  } catch (error: any) {
    return c.json({ success: false, error: error.message }, 500);
  }
});

/**
 * 5. Get Product by Slug
 * GET /api/products/:slug (Public)
 */
catalogRouter.get("/products/:slug", async (c) => {
  try {
    const slug = c.req.param("slug");
    const product = await productRepo.findBySlug(slug);
    if (!product) {
      return c.json({ success: false, error: "Product not found" }, 404);
    }
    return c.json({ success: true, product }, 200);
  } catch (error: any) {
    return c.json({ success: false, error: error.message }, 500);
  }
});

/**
 * 6. Upload Product Image
 * POST /api/products/:id/images (Admin Only, multipart/form-data)
 */
catalogRouter.post("/products/:id/images", authMiddleware(["admin"]), async (c) => {
  try {
    const productId = c.req.param("id");
    const body = await c.req.parseBody();
    const file = body["file"];

    if (!file || !(file instanceof File)) {
      return c.json({ success: false, error: "No image file provided in field 'file'" }, 400);
    }

    // Validate size (5 MB limit)
    if (file.size > 5 * 1024 * 1024) {
      return c.json({ success: false, error: "El tamaño del archivo no debe exceder 5 MB" }, 400);
    }

    // Validate type
    const allowedTypes = ["image/jpeg", "image/png", "image/webp"];
    if (!allowedTypes.includes(file.type)) {
      return c.json(
        { success: false, error: "Formato inválido. Solo se admiten JPG, PNG y WebP" },
        400,
      );
    }

    const arrayBuffer = await file.arrayBuffer();
    const buffer = Buffer.from(arrayBuffer);

    const image = await uploadProductImageUseCase.execute({
      productId,
      fileBuffer: buffer,
      fileName: file.name,
      contentType: file.type,
    });

    return c.json({ success: true, image }, 201);
  } catch (error: any) {
    return c.json({ success: false, error: error.message }, 400);
  }
});
