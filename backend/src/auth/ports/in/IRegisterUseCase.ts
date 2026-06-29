import { User } from "../../core/User.ts";

export interface RegisterDTO {
  email: string;
  password: string;
  name: string;
  phone?: string;
  role: "admin" | "customer";
}

/**
 * Inbound port for the Register User use case.
 */
export interface IRegisterUseCase {
  /**
   * Registers a new user.
   *
   * @param dto The data transfer object for registration
   * @returns A promise resolving to the created User
   */
  execute(dto: RegisterDTO): Promise<User>;
}
