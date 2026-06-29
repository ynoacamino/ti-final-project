import { Cart } from "../../core/Cart.ts";

export interface AddToCartDTO {
  customerId?: string;
  sessionId?: string;
  productVariantId: string;
  quantity: number;
}

export interface IAddToCartUseCase {
  execute(dto: AddToCartDTO): Promise<Cart>;
}
