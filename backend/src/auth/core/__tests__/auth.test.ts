import { describe, it, expect, beforeEach, vi } from "vitest";
import { User } from "../User.ts";
import { RegisterUseCase } from "../RegisterUseCase.ts";
import { LoginUseCase } from "../LoginUseCase.ts";
import type { IUserRepository } from "../../ports/out/IUserRepository.ts";
import bcrypt from "bcryptjs";

describe("Auth Unit Tests", () => {
  let mockUserRepo: IUserRepository;
  let usersDb: Map<string, User>;
  let existsAdminFlag = false;

  beforeEach(() => {
    usersDb = new Map();
    existsAdminFlag = false;

    mockUserRepo = {
      findByEmail: vi.fn(async (email: string) => {
        for (const user of usersDb.values()) {
          if (user.email === email) return user;
        }
        return null;
      }),
      findById: vi.fn(async (id: string) => {
        return usersDb.get(id) || null;
      }),
      save: vi.fn(async (user: User) => {
        usersDb.set(user.id, user);
        if (user.role === "admin") {
          existsAdminFlag = true;
        }
      }),
      existsAdmin: vi.fn(async () => {
        return existsAdminFlag;
      }),
    };
  });

  describe("RegisterUseCase", () => {
    it("should successfully register a customer and hash their password", async () => {
      const useCase = new RegisterUseCase(mockUserRepo);
      const dto = {
        email: "customer@example.com",
        password: "securepassword",
        name: "John Doe",
        role: "customer" as const,
      };

      const user = await useCase.execute(dto);

      expect(user).toBeDefined();
      expect(user.email).toBe(dto.email);
      expect(user.name).toBe(dto.name);
      expect(user.role).toBe("customer");
      expect(user.isActive).toBe(true);

      // Password must be hashed (not equal to plain text password)
      expect(user.passwordHash).not.toBe(dto.password);
      expect(await bcrypt.compare(dto.password, user.passwordHash)).toBe(true);

      // Verify user was persisted
      expect(mockUserRepo.save).toHaveBeenCalled();
    });

    it("should successfully register an admin if none exists", async () => {
      const useCase = new RegisterUseCase(mockUserRepo);
      const dto = {
        email: "admin@example.com",
        password: "adminpassword",
        name: "Admin User",
        role: "admin" as const,
      };

      const user = await useCase.execute(dto);

      expect(user.role).toBe("admin");
      expect(existsAdminFlag).toBe(true);
    });

    it("should throw an error if registering an admin but one already exists", async () => {
      // First save an admin
      existsAdminFlag = true;

      const useCase = new RegisterUseCase(mockUserRepo);
      const dto = {
        email: "admin2@example.com",
        password: "adminpassword2",
        name: "Admin User 2",
        role: "admin" as const,
      };

      await expect(useCase.execute(dto)).rejects.toThrow("An administrator already exists");
    });

    it("should throw an error if email is already taken", async () => {
      const existingUser = User.create({
        id: "existing-uuid",
        email: "taken@example.com",
        passwordHash: "somehash",
        name: "Existing User",
        role: "customer",
      });
      usersDb.set(existingUser.id, existingUser);

      const useCase = new RegisterUseCase(mockUserRepo);
      const dto = {
        email: "taken@example.com",
        password: "password123",
        name: "John Doe",
        role: "customer" as const,
      };

      await expect(useCase.execute(dto)).rejects.toThrow("Email is already registered");
    });
  });

  describe("LoginUseCase", () => {
    beforeEach(() => {
      // Stub jwt secret environment variable
      process.env.JWT_SECRET = "test-secret-key-1234567890-test-secret-key-123";
    });

    it("should log in successfully with valid credentials", async () => {
      const password = "mysecretpassword";
      const hash = await bcrypt.hash(password, 10);
      const existingUser = User.create({
        id: "user-uuid",
        email: "user@example.com",
        passwordHash: hash,
        name: "Test User",
        role: "customer",
        isActive: true,
      });
      usersDb.set(existingUser.id, existingUser);

      const useCase = new LoginUseCase(mockUserRepo);
      const result = await useCase.execute({
        email: "user@example.com",
        password: password,
      });

      expect(result).toBeDefined();
      expect(result.token).toBeDefined();
      expect(result.user.email).toBe("user@example.com");
      expect(result.user.name).toBe("Test User");
      expect(result.user.role).toBe("customer");
    });

    it("should throw error if email does not exist", async () => {
      const useCase = new LoginUseCase(mockUserRepo);
      await expect(
        useCase.execute({
          email: "nonexistent@example.com",
          password: "password",
        }),
      ).rejects.toThrow("Invalid credentials");
    });

    it("should throw error if password is incorrect", async () => {
      const hash = await bcrypt.hash("correct-password", 10);
      const existingUser = User.create({
        id: "user-uuid",
        email: "user@example.com",
        passwordHash: hash,
        name: "Test User",
        role: "customer",
        isActive: true,
      });
      usersDb.set(existingUser.id, existingUser);

      const useCase = new LoginUseCase(mockUserRepo);
      await expect(
        useCase.execute({
          email: "user@example.com",
          password: "wrong-password",
        }),
      ).rejects.toThrow("Invalid credentials");
    });

    it("should throw error if user is inactive", async () => {
      const hash = await bcrypt.hash("password", 10);
      const existingUser = User.create({
        id: "user-uuid",
        email: "inactive@example.com",
        passwordHash: hash,
        name: "Inactive User",
        role: "customer",
        isActive: false,
      });
      usersDb.set(existingUser.id, existingUser);

      const useCase = new LoginUseCase(mockUserRepo);
      await expect(
        useCase.execute({
          email: "inactive@example.com",
          password: "password",
        }),
      ).rejects.toThrow("User account is disabled");
    });
  });
});
