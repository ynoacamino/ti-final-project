import type {
  IRemoveFromCartUseCase,
  RemoveFromCartDTO,
} from "../ports/in/IRemoveFromCartUseCase.ts";
import type { ICartRepository } from "../ports/out/ICartRepository.ts";
import { Cart } from "./Cart.ts";

export class RemoveFromCartUseCase implements IRemoveFromCartUseCase {
  constructor(private readonly cartRepository: ICartRepository) {}

  async execute(dto: RemoveFromCartDTO): Promise<Cart> {
    const cart = await this.cartRepository.findCartByItemId(dto.cartItemId);
    if (!cart) {
      throw new Error("Cart not found");
    }

    await this.cartRepository.deleteItem(dto.cartItemId);

    const refreshedCart = await this.cartRepository.findById(cart.id);
    if (!refreshedCart) {
      throw new Error("Failed to load updated cart");
    }
    return refreshedCart;
  }
}
