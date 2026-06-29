import type {
  IUpdateCartItemUseCase,
  UpdateCartItemDTO,
} from "../ports/in/IUpdateCartItemUseCase.ts";
import type { ICartRepository } from "../ports/out/ICartRepository.ts";
import type { IProductRepository } from "../../catalog/ports/out/IProductRepository.ts";
import { Cart } from "./Cart.ts";
import { CartItem } from "./CartItem.ts";

export class UpdateCartItemUseCase implements IUpdateCartItemUseCase {
  constructor(
    private readonly cartRepository: ICartRepository,
    private readonly productRepository: IProductRepository,
  ) {}

  async execute(dto: UpdateCartItemDTO): Promise<Cart> {
    if (dto.quantity <= 0) {
      throw new Error("Quantity must be greater than 0");
    }

    const cart = await this.cartRepository.findCartByItemId(dto.cartItemId);
    if (!cart) {
      throw new Error("Cart not found");
    }

    const item = cart.items.find((i) => i.id === dto.cartItemId);
    if (!item) {
      throw new Error("Item not found in cart");
    }

    // Check stock
    const variant = await this.productRepository.findVariantById(item.productVariantId);
    if (!variant) {
      throw new Error("Product variant not found");
    }

    if (dto.quantity > variant.stock) {
      throw new Error(
        `Insuficient stock for variant ${variant.color.toLowerCase()}-${variant.size}: ${variant.stock} available`,
      );
    }

    // Update item
    const updatedItem = CartItem.create({
      ...item,
      quantity: dto.quantity,
      updatedAt: new Date().toISOString(),
    });

    await this.cartRepository.saveItem(updatedItem);

    const refreshedCart = await this.cartRepository.findById(cart.id);
    if (!refreshedCart) {
      throw new Error("Failed to load updated cart");
    }
    return refreshedCart;
  }
}
