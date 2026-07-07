import { describe, it, expect, beforeEach, vi } from "vitest";
import { Order } from "../Order.ts";
import { OrderItem } from "../OrderItem.ts";
import { CreateCheckoutUseCase } from "../CreateCheckoutUseCase.ts";
import { ConfirmPaymentUseCase } from "../ConfirmPaymentUseCase.ts";
import { DecrementStockUseCase } from "../../../inventory/core/DecrementStockUseCase.ts";
import type { IOrderRepository } from "../../ports/out/IOrderRepository.ts";
import type { IPaymentGateway } from "../../ports/out/IPaymentGateway.ts";
import type { ICartRepository } from "../../../cart/ports/out/ICartRepository.ts";
import type { IProductRepository } from "../../../catalog/ports/out/IProductRepository.ts";
import type { IInventoryRepository } from "../../../inventory/ports/out/IInventoryRepository.ts";
import { Cart } from "../../../cart/core/Cart.ts";
import { CartItem } from "../../../cart/core/CartItem.ts";
import { ProductVariant } from "../../../catalog/core/ProductVariant.ts";
import { StockMovement } from "../../../inventory/core/StockMovement.ts";
import { StockAlert } from "../../../inventory/core/StockAlert.ts";

describe("Sales & Checkout Flow Unit Tests", () => {
  let mockOrderRepo: IOrderRepository;
  let mockPaymentGateway: IPaymentGateway;
  let mockCartRepo: ICartRepository;
  let mockProductRepo: IProductRepository;
  let mockInventoryRepo: IInventoryRepository;

  let ordersDb: Map<string, Order>;
  let cartsDb: Map<string, Cart>;
  let variantsDb: Map<string, ProductVariant>;
  let movementsDb: StockMovement[];
  let alertsDb: Map<string, StockAlert>;

  beforeEach(() => {
    ordersDb = new Map();
    cartsDb = new Map();
    variantsDb = new Map();
    movementsDb = [];
    alertsDb = new Map();

    // Seed mock variant
    variantsDb.set(
      "variant-1",
      ProductVariant.create({
        id: "variant-1",
        productId: "product-1",
        size: "M",
        color: "Azul",
        sku: "JNS-M-BLU",
        stock: 10,
      }),
    );

    // Seed mock cart
    const cartItem = CartItem.create({
      id: "cart-item-1",
      cartId: "cart-1",
      productVariantId: "variant-1",
      quantity: 2,
      unitPriceSnapshot: 1500, // $15.00
    });
    cartsDb.set(
      "cart-1",
      Cart.create({
        id: "cart-1",
        customerId: "cust-1",
        status: "active",
        items: [cartItem],
      }),
    );

    mockOrderRepo = {
      findById: vi.fn(async (id) => ordersDb.get(id) || null),
      findByPaymentIntentId: vi.fn(async (piId) => {
        for (const order of ordersDb.values()) {
          if (order.stripePaymentIntentId === piId) return order;
        }
        return null;
      }),
      save: vi.fn(async (order) => {
        ordersDb.set(order.id, order);
      }),
      savePayment: vi.fn(async (_payment) => {}),
      list: vi.fn(),
    };

    mockPaymentGateway = {
      createPaymentIntent: vi.fn(async (_amount, _currency) => {
        return {
          id: "pi_test_123",
          clientSecret: "pi_test_123_secret_xyz",
        };
      }),
      retrievePaymentIntentStatus: vi.fn(async (id) => {
        if (id === "pi_test_123") {
          return { status: "succeeded", chargeId: "ch_test_123" };
        }
        return { status: "failed", chargeId: null, errorMessage: "Payment failed" };
      }),
    };

    mockCartRepo = {
      findById: vi.fn(async (id) => cartsDb.get(id) || null),
      findActiveByCustomerId: vi.fn(async (customerId) => {
        for (const cart of cartsDb.values()) {
          if (cart.customerId === customerId && cart.status === "active") return cart;
        }
        return null;
      }),
      findActiveBySessionId: vi.fn(),
      save: vi.fn(async (cart) => {
        cartsDb.set(cart.id, cart);
      }),
      saveItem: vi.fn(),
      deleteItem: vi.fn(),
      deleteItemsByCartId: vi.fn(async (cartId) => {
        const cart = cartsDb.get(cartId);
        if (cart) {
          cartsDb.set(cartId, Cart.create({ ...cart, items: [] }));
        }
      }),
      findCartByItemId: vi.fn(),
      findActiveCartByVariantId: vi.fn(async (vId) => {
        for (const cart of cartsDb.values()) {
          if (cart.status === "active" && cart.items.some((i) => i.productVariantId === vId))
            return cart;
        }
        return null;
      }),
    };

    mockProductRepo = {
      findById: vi.fn(async (id) => {
        if (id === "product-1") {
          return { id: "product-1", name: "Jeans Elegante", basePrice: 1000 } as any;
        }
        return null;
      }),
      findBySlug: vi.fn(),
      save: vi.fn(),
      list: vi.fn(),
      saveImage: vi.fn(),
      deleteImage: vi.fn(),
      findVariantById: vi.fn(async (id) => variantsDb.get(id) || null),
      updateVariantStock: vi.fn(async (variantId, newStock) => {
        const v = variantsDb.get(variantId);
        if (v) {
          variantsDb.set(variantId, ProductVariant.create({ ...v, stock: newStock }));
        }
      }),
    };

    mockInventoryRepo = {
      saveMovement: vi.fn(async (movement) => {
        movementsDb.push(movement);
      }),
      saveAlert: vi.fn(async (alert) => {
        alertsDb.set(alert.productVariantId, alert);
      }),
      findActiveAlertByVariantId: vi.fn(async (vId) => {
        const alert = alertsDb.get(vId);
        if (alert && alert.status === "active") return alert;
        return null;
      }),
      listAlerts: vi.fn(),
    };
  });

  describe("CreateCheckoutUseCase", () => {
    it("should successfully create checkout, order, and return clientSecret", async () => {
      const useCase = new CreateCheckoutUseCase(
        mockOrderRepo,
        mockCartRepo,
        mockProductRepo,
        mockPaymentGateway,
      );

      const result = await useCase.execute({
        cartId: "cart-1",
        customerId: "cust-1",
        shippingAddress: {
          street: "Av. Ejercito 123",
          city: "Arequipa",
          state: "Arequipa",
          zip: "04001",
          country: "PE",
        },
        notes: "Dejar en portería",
      });

      expect(result).toBeDefined();
      expect(result.clientSecret).toBe("pi_test_123_secret_xyz");
      expect(result.order).toBeDefined();
      expect(result.order.status).toBe("pendiente");
      expect(result.order.total).toBe(3000); // 2 items * $15.00 (1500 cents) = 3000
      expect(result.order.stripePaymentIntentId).toBe("pi_test_123");
      expect(result.order.items).toHaveLength(1);
      expect(result.order.items[0]?.productNameSnapshot).toBe("Jeans Elegante");

      // Check if order was persisted
      expect(mockOrderRepo.save).toHaveBeenCalled();
    });

    it("should throw error if cart is empty", async () => {
      cartsDb.set(
        "cart-empty",
        Cart.create({
          id: "cart-empty",
          customerId: "cust-1",
          status: "active",
          items: [],
        }),
      );

      const useCase = new CreateCheckoutUseCase(
        mockOrderRepo,
        mockCartRepo,
        mockProductRepo,
        mockPaymentGateway,
      );

      await expect(
        useCase.execute({
          cartId: "cart-empty",
          customerId: "cust-1",
          shippingAddress: { street: "x", city: "x", state: "x", zip: "x", country: "x" },
        }),
      ).rejects.toThrow("Cannot checkout an empty cart");
    });
  });

  describe("ConfirmPaymentUseCase", () => {
    it("should process payment confirmation and trigger stock decrement", async () => {
      const decrementStockUseCase = new DecrementStockUseCase(mockProductRepo, mockInventoryRepo);
      const confirmUseCase = new ConfirmPaymentUseCase(
        mockOrderRepo,
        mockCartRepo,
        mockPaymentGateway,
        decrementStockUseCase,
      );

      // Pre-seed an order linked to our payment intent
      const preOrder = Order.create({
        id: "order-1",
        customerId: "cust-1",
        subtotal: 3000,
        total: 3000,
        status: "pendiente",
        stripePaymentIntentId: "pi_test_123",
        items: [
          OrderItem.create({
            id: "order-item-1",
            orderId: "order-1",
            productVariantId: "variant-1",
            productNameSnapshot: "Jeans Elegante",
            variantDetailsSnapshot: '{"size":"M","color":"Azul","sku":"JNS-M-BLU"}',
            quantity: 2,
            unitPrice: 1500,
          }),
        ],
      });
      ordersDb.set("order-1", preOrder);

      const confirmedOrder = await confirmUseCase.execute({
        stripePaymentIntentId: "pi_test_123",
      });

      expect(confirmedOrder).toBeDefined();
      expect(confirmedOrder.status).toBe("pagado");

      // Cart should be converted and cleared
      const cart = cartsDb.get("cart-1");
      expect(cart).toBeDefined();
      expect(cart?.status).toBe("converted");

      // Stock of variant-1 should be decremented from 10 to 8
      const variant = variantsDb.get("variant-1");
      expect(variant?.stock).toBe(8);

      // StockMovement should be recorded
      expect(movementsDb).toHaveLength(1);
      expect(movementsDb[0]?.type).toBe("sale");
      expect(movementsDb[0]?.quantity).toBe(-2);
      expect(movementsDb[0]?.previousStock).toBe(10);
      expect(movementsDb[0]?.newStock).toBe(8);
    });
  });

  describe("DecrementStockUseCase", () => {
    it("should decrement stock and log movement", async () => {
      const useCase = new DecrementStockUseCase(mockProductRepo, mockInventoryRepo);
      await useCase.execute({
        productVariantId: "variant-1",
        quantity: 3,
        referenceType: "order",
        referenceId: "order-1",
      });

      const variant = variantsDb.get("variant-1");
      expect(variant?.stock).toBe(7);

      expect(movementsDb).toHaveLength(1);
      expect(movementsDb[0]?.newStock).toBe(7);
      expect(movementsDb[0]?.quantity).toBe(-3);
    });

    it("should generate a StockAlert if stock falls below threshold (5)", async () => {
      const useCase = new DecrementStockUseCase(mockProductRepo, mockInventoryRepo);
      // Stock is 10. Decrement by 6 -> Stock becomes 4 (< 5)
      await useCase.execute({
        productVariantId: "variant-1",
        quantity: 6,
        referenceType: "order",
        referenceId: "order-1",
      });

      const variant = variantsDb.get("variant-1");
      expect(variant?.stock).toBe(4);

      const alert = alertsDb.get("variant-1");
      expect(alert).toBeDefined();
      expect(alert?.status).toBe("active");
      expect(alert?.currentStock).toBe(4);
      expect(alert?.threshold).toBe(5);
    });
  });
});
