import type { IRegisterUseCase, RegisterDTO } from "../ports/in/IRegisterUseCase.ts";
import type { IUserRepository } from "../ports/out/IUserRepository.ts";
import { User } from "./User.ts";
import bcrypt from "bcrypt";

/**
 * Service to register a new user in the system.
 * Implements the input port IRegisterUseCase.
 */
export class RegisterUseCase implements IRegisterUseCase {
  constructor(private readonly userRepository: IUserRepository) {}

  /**
   * Registers a new user.
   *
   * @param dto The data transfer object for registration
   * @returns The registered User
   */
  async execute(dto: RegisterDTO): Promise<User> {
    // 1. Check if email is already taken
    const existingUser = await this.userRepository.findByEmail(dto.email);
    if (existingUser) {
      throw new Error("Email is already registered");
    }

    // 2. Business Rule: Only one admin is allowed in the system
    if (dto.role === "admin") {
      const adminExists = await this.userRepository.existsAdmin();
      if (adminExists) {
        throw new Error("An administrator already exists. SmartPyME is a single-tenant system.");
      }
    }

    // 3. Hash the password with bcrypt (factor 10 as specified in RNF-002 / guidelines)
    const passwordHash = await bcrypt.hash(dto.password, 10);

    // 4. Create User domain entity
    const newUser = User.create({
      id: crypto.randomUUID(),
      email: dto.email,
      passwordHash,
      name: dto.name,
      phone: dto.phone,
      role: dto.role,
      isActive: true,
    });

    // 5. Persist the user
    await this.userRepository.save(newUser);

    return newUser;
  }
}
