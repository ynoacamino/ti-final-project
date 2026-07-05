import type { ILoginUseCase, LoginDTO, LoginResult } from "../ports/in/ILoginUseCase.ts";
import type { IUserRepository } from "../ports/out/IUserRepository.ts";
import bcrypt from "bcrypt";
import { SignJWT } from "jose";

/**
 * Service to handle user login.
 * Implements the input port ILoginUseCase.
 */
export class LoginUseCase implements ILoginUseCase {
  /**
   *
   */
  constructor(private readonly userRepository: IUserRepository) {}

  /**
   * Validates credentials and generates a JWT.
   *
   * @param dto - The login credentials
   * @returns Login result containing user data and JWT token
   */
  async execute(dto: LoginDTO): Promise<LoginResult> {
    // 1. Fetch user by email
    const user = await this.userRepository.findByEmail(dto.email);
    if (!user) {
      throw new Error("Invalid credentials");
    }

    // 2. Validate password
    const isPasswordValid = await bcrypt.compare(dto.password, user.passwordHash);
    if (!isPasswordValid) {
      throw new Error("Invalid credentials");
    }

    // 3. Verify user status
    if (!user.isActive) {
      throw new Error("User account is disabled");
    }

    // 4. Generate JWT token using jose library
    const secret = new TextEncoder().encode(
      process.env.JWT_SECRET || "supersecretjwtkey1234567890!",
    );

    const token = await new SignJWT({
      id: user.id,
      email: user.email,
      role: user.role,
      name: user.name,
    })
      .setProtectedHeader({ alg: "HS256" })
      .setIssuedAt()
      .setExpirationTime("7d") // Expire token in 7 days
      .sign(secret);

    return {
      token,
      user: {
        id: user.id,
        email: user.email,
        name: user.name,
        role: user.role,
      },
    };
  }
}
