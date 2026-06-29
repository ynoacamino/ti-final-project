import { Cart } from "../../core/Cart.ts";

export interface UpdateCartItemDTO {
  cartItemId: string;
  quantity: number;
}

export interface IUpdateCartItemUseCase {
  execute(dto: UpdateCartItemDTO): Promise<Cart>;
}
