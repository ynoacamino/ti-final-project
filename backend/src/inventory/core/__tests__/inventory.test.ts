import { describe, it, expect, vi, beforeEach } from "vitest";
import { DecrementStockUseCase } from "../DecrementStockUseCase.ts";
import type { IProductRepository } from "../../../catalog/ports/out/IProductRepository.ts";
import type { IInventoryRepository } from "../../ports/out/IInventoryRepository.ts";
import { StockMovement } from "../StockMovement.ts";
import { StockAlert } from "../StockAlert.ts";

/**
 * Unit tests suite for the Inventory domain use cases.
 */
describe("DecrementStockUseCase", () => {
  let productRepo: MockProductRepository;
  let inventoryRepo: MockInventoryRepository;
  let useCase: DecrementStockUseCase;

  /**
   * Dummy interface helper class to mock IProductRepository.
   */
  class MockProductRepository implements Partial<IProductRepository> {
    findVariantById = vi.fn();
    updateVariantStock = vi.fn();
  }

  /**
   * Dummy interface helper class to mock IInventoryRepository.
   */
  class MockInventoryRepository implements Partial<IInventoryRepository> {
    saveMovement = vi.fn();
    findActiveAlertByVariantId = vi.fn();
    saveAlert = vi.fn();
  }

  beforeEach(() => {
    productRepo = new MockProductRepository();
    inventoryRepo = new MockInventoryRepository();
    useCase = new DecrementStockUseCase(
      productRepo as unknown as IProductRepository,
      inventoryRepo as unknown as IInventoryRepository,
    );
  });

  /**
   * Validates quantity is positive.
   */
  it("should throw an error if quantity to decrement is less than or equal to 0", async () => {
    await expect(
      useCase.execute({
        productVariantId: "v1-id",
        quantity: 0,
        referenceType: "manual",
        referenceId: "test-ref",
      }),
    ).rejects.toThrow("Quantity to decrement must be greater than 0");
  });

  /**
   * Validates variant existence.
   */
  it("should throw an error if product variant does not exist", async () => {
    productRepo.findVariantById.mockResolvedValue(null);

    await expect(
      useCase.execute({
        productVariantId: "v1-id",
        quantity: 5,
        referenceType: "manual",
        referenceId: "test-ref",
      }),
    ).rejects.toThrow("Product variant not found");
  });

  /**
   * Validates stock limits.
   */
  it("should throw an error if stock is insufficient", async () => {
    productRepo.findVariantById.mockResolvedValue({
      id: "v1-id",
      productId: "prod-id",
      size: "M",
      color: "Blue",
      sku: "SKU-BLUE-M",
      stock: 4,
      additionalPrice: 0,
    });

    await expect(
      useCase.execute({
        productVariantId: "v1-id",
        quantity: 5,
        referenceType: "manual",
        referenceId: "test-ref",
      }),
    ).rejects.toThrow("Insuficient stock for variant");
  });

  /**
   * Validates success and alert triggering.
   */
  it("should successfully decrement stock and generate alert if final stock < 5", async () => {
    productRepo.findVariantById.mockResolvedValue({
      id: "v1-id",
      productId: "prod-id",
      size: "M",
      color: "Blue",
      sku: "SKU-BLUE-M",
      stock: 10,
      additionalPrice: 0,
    });
    inventoryRepo.findActiveAlertByVariantId.mockResolvedValue(null);

    await useCase.execute({
      productVariantId: "v1-id",
      quantity: 6, // final stock is 4, which is less than 5
      referenceType: "order",
      referenceId: "order-123",
      createdBy: "system",
    });

    expect(productRepo.updateVariantStock).toHaveBeenCalledWith("v1-id", 4);
    expect(inventoryRepo.saveMovement).toHaveBeenCalledWith(
      expect.any(StockMovement),
    );
    expect(inventoryRepo.saveAlert).toHaveBeenCalledWith(
      expect.any(StockAlert),
    );
  });
});
