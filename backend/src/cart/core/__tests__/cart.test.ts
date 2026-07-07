import { describe, it, expect, beforeEach, vi } from "vitest";
import { Cart } from "../Cart.ts";
import { CartItem } from "../CartItem.ts";
import { AddToCartUseCase } from "../AddToCartUseCase.ts";
import type { ICartRepository } from "../../ports/out/ICartRepository.ts";
import type { IProductRepository } from "../../../catalog/ports/out/IProductRepository.ts";
import { ProductVariant } from "../../../catalog/core/ProductVariant.ts";

describe("Cart Unit Tests", () => {
  let mockCartRepo: ICartRepository;
  let mockProductRepo: IProductRepository;
  let cartsDb: Map<string, Cart>;
  let mockVariant: ProductVariant;

  beforeEach(() => {
    cartsDb = new Map();

    mockVariant = ProductVariant.create({
      id: "variant-uuid",
      productId: "product-uuid",
      size: "M",
      color: "black",
      sku: "TSH-BLK-M",
      stock: 10,
      additionalPrice: 500, // $5.00
    });

    mockCartRepo = {
      findById: vi.fn(async (id) => cartsDb.get(id) || null),
      findActiveByCustomerId: vi.fn(async (customerId) => {
        for (const cart of cartsDb.values()) {
          if (cart.customerId === customerId && cart.status === "active") return cart;
        }
        return null;
      }),
      findActiveBySessionId: vi.fn(async (sessionId) => {
        for (const cart of cartsDb.values()) {
          if (cart.sessionId === sessionId && cart.status === "active") return cart;
        }
        return null;
      }),
      save: vi.fn(async (cart) => {
        cartsDb.set(cart.id, cart);
      }),
      saveItem: vi.fn(async (item) => {
        const cart = cartsDb.get(item.cartId);
        if (cart) {
          const items = cart.items.filter((i) => i.id !== item.id);
          items.push(item);
          const updatedCart = Cart.create({
            ...cart,
            items,
          });
          cartsDb.set(cart.id, updatedCart);
        }
      }),
      deleteItem: vi.fn(async (id) => {
        for (const cart of cartsDb.values()) {
          const items = cart.items.filter((i) => i.id !== id);
          const updatedCart = Cart.create({
            ...cart,
            items,
          });
          cartsDb.set(cart.id, updatedCart);
        }
      }),
      deleteItemsByCartId: vi.fn(async (cartId) => {
        const cart = cartsDb.get(cartId);
        if (cart) {
          const updatedCart = Cart.create({
            ...cart,
            items: [],
          });
          cartsDb.set(cartId, updatedCart);
        }
      }),
      findCartByItemId: vi.fn(async (itemId) => {
        for (const cart of cartsDb.values()) {
          if (cart.items.some((i) => i.id === itemId)) return cart;
        }
        return null;
      }),
    };

    mockProductRepo = {
      findById: vi.fn(async (id) => {
        if (id === "product-uuid") {
          return { id: "product-uuid", basePrice: 0 } as any;
        }
        return null;
      }),
      findBySlug: vi.fn(),
      save: vi.fn(),
      list: vi.fn(),
      saveImage: vi.fn(),
      deleteImage: vi.fn(),
      findVariantById: vi.fn(async (id) => {
        if (id === "variant-uuid") return mockVariant;
        return null;
      }),
      updateVariantStock: vi.fn(),
    };
  });

  describe("AddToCartUseCase", () => {
    it("should create a new active cart and add item if none exists", async () => {
      const useCase = new AddToCartUseCase(mockCartRepo, mockProductRepo);
      const cart = await useCase.execute({
        customerId: "user-123",
        productVariantId: "variant-uuid",
        quantity: 2,
      });

      expect(cart).toBeDefined();
      expect(cart.status).toBe("active");
      expect(cart.customerId).toBe("user-123");
      expect(cart.items).toHaveLength(1);
      expect(cart.items[0]?.productVariantId).toBe("variant-uuid");
      expect(cart.items[0]?.quantity).toBe(2);
      expect(cart.items[0]?.unitPriceSnapshot).toBe(500); // from variant additionalPrice? Wait, product price is separate. Let's see: product base price + variant additional price!
    });

    it("should add item to existing active cart", async () => {
      const existingCart = Cart.create({
        id: "cart-123",
        customerId: "user-123",
        status: "active",
      });
      cartsDb.set(existingCart.id, existingCart);

      const useCase = new AddToCartUseCase(mockCartRepo, mockProductRepo);
      const cart = await useCase.execute({
        customerId: "user-123",
        productVariantId: "variant-uuid",
        quantity: 3,
      });

      expect(cart.id).toBe("cart-123");
      expect(cart.items).toHaveLength(1);
      expect(cart.items[0]?.quantity).toBe(3);
    });

    it("should update quantity if item already in cart", async () => {
      const existingCart = Cart.create({
        id: "cart-123",
        customerId: "user-123",
        status: "active",
      });
      const existingItem = CartItem.create({
        id: "item-123",
        cartId: "cart-123",
        productVariantId: "variant-uuid",
        quantity: 1,
        unitPriceSnapshot: 500,
      });
      existingCart.items.push(existingItem);
      cartsDb.set(existingCart.id, existingCart);

      const useCase = new AddToCartUseCase(mockCartRepo, mockProductRepo);
      const cart = await useCase.execute({
        customerId: "user-123",
        productVariantId: "variant-uuid",
        quantity: 2, // adding 2 more
      });

      expect(cart.items).toHaveLength(1);
      expect(cart.items[0]?.quantity).toBe(3); // 1 + 2
    });

    it("should throw error if quantity exceeds available stock", async () => {
      const useCase = new AddToCartUseCase(mockCartRepo, mockProductRepo);
      await expect(
        useCase.execute({
          customerId: "user-123",
          productVariantId: "variant-uuid",
          quantity: 15, // stock is 10
        }),
      ).rejects.toThrow("Insuficient stock for variant black-M: 10 available"); // Wait, we can throw standard error
    });
  });
});
