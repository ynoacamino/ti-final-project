import { Order } from "../../core/Order.ts";

export interface AddressDTO {
  street: string;
  city: string;
  state: string;
  zip: string;
  country: string;
  references?: string;
}

export interface CreateCheckoutDTO {
  cartId: string;
  customerId?: string;
  guestEmail?: string;
  guestName?: string;
  guestPhone?: string;
  shippingAddress: AddressDTO;
  notes?: string;
}

export interface CheckoutResult {
  order: Order;
  clientSecret: string;
}

export interface ICreateCheckoutUseCase {
  execute(dto: CreateCheckoutDTO): Promise<CheckoutResult>;
}
