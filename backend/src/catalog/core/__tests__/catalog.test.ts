import { describe, it, expect, beforeEach, vi } from "vitest";
import { Category } from "../Category.ts";
import { Product } from "../Product.ts";
import { ProductVariant } from "../ProductVariant.ts";
import { ProductImage } from "../ProductImage.ts";
import { CreateCategoryUseCase } from "../CreateCategoryUseCase.ts";
import { CreateProductUseCase } from "../CreateProductUseCase.ts";
import { UploadProductImageUseCase } from "../UploadProductImageUseCase.ts";
import type { ICategoryRepository } from "../../ports/out/ICategoryRepository.ts";
import type { IProductRepository, ListProductsParams } from "../../ports/out/IProductRepository.ts";
import type { IStorageService } from "../../ports/out/IStorageService.ts";

describe("Catalog Unit Tests", () => {
  let mockCategoryRepo: ICategoryRepository;
  let mockProductRepo: IProductRepository;
  let mockStorageService: IStorageService;

  let categoriesDb: Map<string, Category>;
  let productsDb: Map<string, Product>;
  let imagesDb: Map<string, ProductImage[]>;

  beforeEach(() => {
    categoriesDb = new Map();
    productsDb = new Map();
    imagesDb = new Map();

    mockCategoryRepo = {
      findById: vi.fn(async (id) => categoriesDb.get(id) || null),
      findByName: vi.fn(async (name) => {
        for (const cat of categoriesDb.values()) {
          if (cat.name.toLowerCase() === name.toLowerCase()) return cat;
        }
        return null;
      }),
      findBySlug: vi.fn(async (slug) => {
        for (const cat of categoriesDb.values()) {
          if (cat.slug === slug) return cat;
        }
        return null;
      }),
      save: vi.fn(async (cat) => {
        categoriesDb.set(cat.id, cat);
      }),
      listAll: vi.fn(async () => Array.from(categoriesDb.values())),
      hasAssociatedProducts: vi.fn(async (categoryId) => {
        for (const prod of productsDb.values()) {
          if (prod.categoryId === categoryId) return true;
        }
        return false;
      }),
      delete: vi.fn(async (id) => {
        categoriesDb.delete(id);
      }),
    };

    mockProductRepo = {
      findById: vi.fn(async (id) => {
        const prod = productsDb.get(id);
        if (!prod) return null;
        return Product.create({
          ...prod,
          variants: prod.variants,
          images: imagesDb.get(id) || [],
        });
      }),
      findBySlug: vi.fn(async (slug) => {
        for (const prod of productsDb.values()) {
          if (prod.slug === slug) {
            return Product.create({
              ...prod,
              variants: prod.variants,
              images: imagesDb.get(prod.id) || [],
            });
          }
        }
        return null;
      }),
      save: vi.fn(async (prod) => {
        productsDb.set(prod.id, prod);
      }),
      list: vi.fn(async (params: ListProductsParams) => {
        let prods = Array.from(productsDb.values());
        if (params.categorySlug) {
          const category = Array.from(categoriesDb.values()).find(
            (c) => c.slug === params.categorySlug,
          );
          if (category) {
            prods = prods.filter((p) => p.categoryId === category.id);
          } else {
            prods = [];
          }
        }
        if (params.search) {
          const s = params.search.toLowerCase();
          prods = prods.filter((p) => p.name.toLowerCase().includes(s));
        }
        if (!params.includeInactive) {
          prods = prods.filter((p) => p.isActive);
        }
        return {
          products: prods,
          total: prods.length,
        };
      }),
      saveImage: vi.fn(async (img) => {
        const list = imagesDb.get(img.productId) || [];
        list.push(img);
        imagesDb.set(img.productId, list);
      }),
      deleteImage: vi.fn(async (id) => {
        for (const [prodId, list] of imagesDb.entries()) {
          const filtered = list.filter((img) => img.id !== id);
          imagesDb.set(prodId, filtered);
        }
      }),
      findVariantById: vi.fn(async (id) => {
        for (const prod of productsDb.values()) {
          for (const variant of prod.variants) {
            if (variant.id === id) return variant;
          }
        }
        return null;
      }),
      updateVariantStock: vi.fn(async (variantId, newStock) => {
        for (const prod of productsDb.values()) {
          const idx = prod.variants.findIndex((v) => v.id === variantId);
          if (idx !== -1) {
            const v = prod.variants[idx]!;
            const updatedVariant = ProductVariant.create({
              ...v,
              stock: newStock,
            });
            prod.variants[idx] = updatedVariant;
            break;
          }
        }
      }),
    };

    mockStorageService = {
      upload: vi.fn(async (_buffer, fileName) => {
        return `https://storage.smartpyme.com/images/${fileName}`;
      }),
      delete: vi.fn(async () => {}),
    };
  });

  describe("CreateCategoryUseCase", () => {
    it("should create a category successfully and generate its slug", async () => {
      const useCase = new CreateCategoryUseCase(mockCategoryRepo);
      const category = await useCase.execute({
        name: "Camisas de Lujo",
        description: "Camisas elegantes de alta calidad",
      });

      expect(category).toBeDefined();
      expect(category.name).toBe("Camisas de Lujo");
      expect(category.slug).toBe("camisas-de-lujo");
      expect(categoriesDb.get(category.id)).toBeDefined();
    });

    it("should throw an error if category name already exists", async () => {
      const cat = Category.create({
        id: "existing-cat-id",
        name: "Jeans",
        slug: "jeans",
      });
      categoriesDb.set(cat.id, cat);

      const useCase = new CreateCategoryUseCase(mockCategoryRepo);
      await expect(
        useCase.execute({
          name: "Jeans",
        }),
      ).rejects.toThrow("Category name already exists");
    });
  });

  describe("CreateProductUseCase", () => {
    let catId = "cat-uuid";

    beforeEach(() => {
      const cat = Category.create({
        id: catId,
        name: "Jeans",
        slug: "jeans",
      });
      categoriesDb.set(catId, cat);
    });

    it("should create a product with variants successfully", async () => {
      const useCase = new CreateProductUseCase(mockProductRepo, mockCategoryRepo);
      const product = await useCase.execute({
        name: "Jeans Slim Fit",
        description: "Jeans ajustados color azul",
        basePrice: 4500, // $45.00
        categoryId: catId,
        variants: [
          { size: "30", color: "Azul", sku: "JNS-SLM-30-BLU", stock: 10, additionalPrice: 0 },
          { size: "32", color: "Azul", sku: "JNS-SLM-32-BLU", stock: 15, additionalPrice: 200 },
        ],
      });

      expect(product).toBeDefined();
      expect(product.name).toBe("Jeans Slim Fit");
      expect(product.slug).toBe("jeans-slim-fit");
      expect(product.basePrice).toBe(4500);
      expect(product.variants).toHaveLength(2);
      expect(product.variants[0]?.sku).toBe("JNS-SLM-30-BLU");
      expect(product.variants[1]?.additionalPrice).toBe(200);
      expect(productsDb.get(product.id)).toBeDefined();
    });

    it("should throw an error if category does not exist", async () => {
      const useCase = new CreateProductUseCase(mockProductRepo, mockCategoryRepo);
      await expect(
        useCase.execute({
          name: "Product Test",
          basePrice: 100,
          categoryId: "invalid-cat-id",
          variants: [],
        }),
      ).rejects.toThrow("Category not found");
    });

    it("should throw an error if base price is 0 or negative", async () => {
      const useCase = new CreateProductUseCase(mockProductRepo, mockCategoryRepo);
      await expect(
        useCase.execute({
          name: "Product Test",
          basePrice: 0,
          categoryId: catId,
          variants: [],
        }),
      ).rejects.toThrow("Base price must be greater than 0");
    });

    it("should throw an error if there are duplicated variant sizes and colors", async () => {
      const useCase = new CreateProductUseCase(mockProductRepo, mockCategoryRepo);
      await expect(
        useCase.execute({
          name: "Product Test",
          basePrice: 1000,
          categoryId: catId,
          variants: [
            { size: "M", color: "Rojo", sku: "SKU1", stock: 5 },
            { size: "M", color: "Rojo", sku: "SKU2", stock: 5 },
          ],
        }),
      ).rejects.toThrow("Duplicate variant size and color combo found");
    });
  });

  describe("UploadProductImageUseCase", () => {
    let prodId = "prod-uuid";

    beforeEach(() => {
      const cat = Category.create({ id: "cat-id", name: "Jeans", slug: "jeans" });
      categoriesDb.set(cat.id, cat);
      const prod = Product.create({
        id: prodId,
        name: "Jeans Slim Fit",
        slug: "jeans-slim-fit",
        basePrice: 2000,
        categoryId: cat.id,
      });
      productsDb.set(prodId, prod);
    });

    it("should upload product image successfully", async () => {
      const useCase = new UploadProductImageUseCase(mockProductRepo, mockStorageService);
      const img = await useCase.execute({
        productId: prodId,
        fileBuffer: Buffer.from("mockImageBytes"),
        fileName: "jeans.jpg",
        contentType: "image/jpeg",
      });

      expect(img).toBeDefined();
      expect(img.productId).toBe(prodId);
      expect(img.url).toContain(".jpg");
      expect(img.position).toBe(0); // first image

      const images = imagesDb.get(prodId) || [];
      expect(images).toHaveLength(1);
    });

    it("should set correct position index for additional images", async () => {
      // Pre-populate one image
      imagesDb.set(prodId, [
        ProductImage.create({ id: "img1", productId: prodId, url: "url1", position: 0 }),
      ]);

      const useCase = new UploadProductImageUseCase(mockProductRepo, mockStorageService);
      const img = await useCase.execute({
        productId: prodId,
        fileBuffer: Buffer.from("mockImageBytes"),
        fileName: "jeans-2.jpg",
        contentType: "image/jpeg",
      });

      expect(img.position).toBe(1);
    });

    it("should throw error if product does not exist", async () => {
      const useCase = new UploadProductImageUseCase(mockProductRepo, mockStorageService);
      await expect(
        useCase.execute({
          productId: "invalid-prod-id",
          fileBuffer: Buffer.from("bytes"),
          fileName: "file.jpg",
          contentType: "image/jpeg",
        }),
      ).rejects.toThrow("Product not found");
    });

    it("should throw error if product already has 5 images", async () => {
      // Pre-populate 5 images
      const existingImages = Array.from({ length: 5 }, (_, i) =>
        ProductImage.create({ id: `img${i}`, productId: prodId, url: `url${i}`, position: i }),
      );
      imagesDb.set(prodId, existingImages);

      const useCase = new UploadProductImageUseCase(mockProductRepo, mockStorageService);
      await expect(
        useCase.execute({
          productId: prodId,
          fileBuffer: Buffer.from("bytes"),
          fileName: "file.jpg",
          contentType: "image/jpeg",
        }),
      ).rejects.toThrow("Product has reached the limit of 5 images");
    });
  });
});
