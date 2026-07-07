import { Cart } from "../../core/Cart.ts";

export interface RemoveFromCartDTO {
  cartItemId: string;
}

export interface IRemoveFromCartUseCase {
  execute(dto: RemoveFromCartDTO): Promise<Cart>;
}
