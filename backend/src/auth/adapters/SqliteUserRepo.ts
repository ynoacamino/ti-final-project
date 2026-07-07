import type { IUserRepository } from "../ports/out/IUserRepository.ts";
import { User } from "../core/User.ts";
import { db } from "../../shared/infrastructure/database/client.ts";
import { users } from "../../shared/infrastructure/database/schema.ts";
import { eq } from "drizzle-orm";

/**
 * SQLite implementation of the IUserRepository port using Drizzle ORM.
 */
export class SqliteUserRepo implements IUserRepository {
  /**
   * Maps a database row to a User domain entity.
   */
  private toDomain(row: typeof users.$inferSelect): User {
    return new User(
      row.id,
      row.email,
      row.passwordHash,
      row.name,
      row.phone,
      row.role as "admin" | "customer",
      row.defaultShippingAddress,
      row.isActive === 1,
      row.createdAt,
      row.updatedAt,
    );
  }

  /**
   * Finds a user by their email address.
   */
  async findByEmail(email: string): Promise<User | null> {
    const [row] = await db.select().from(users).where(eq(users.email, email)).limit(1);

    if (!row) return null;
    return this.toDomain(row);
  }

  /**
   * Finds a user by their unique identifier.
   */
  async findById(id: string): Promise<User | null> {
    const [row] = await db.select().from(users).where(eq(users.id, id)).limit(1);

    if (!row) return null;
    return this.toDomain(row);
  }

  /**
   * Persists a User entity to the SQLite database.
   * Handles both creation and update operations.
   */
  async save(user: User): Promise<void> {
    await db
      .insert(users)
      .values({
        id: user.id,
        email: user.email,
        passwordHash: user.passwordHash,
        name: user.name,
        phone: user.phone,
        role: user.role,
        defaultShippingAddress: user.defaultShippingAddress,
        isActive: user.isActive ? 1 : 0,
        createdAt: user.createdAt,
        updatedAt: user.updatedAt,
      })
      .onConflictDoUpdate({
        target: users.id,
        set: {
          email: user.email,
          passwordHash: user.passwordHash,
          name: user.name,
          phone: user.phone,
          role: user.role,
          defaultShippingAddress: user.defaultShippingAddress,
          isActive: user.isActive ? 1 : 0,
          updatedAt: new Date().toISOString(),
        },
      });
  }

  /**
   * Checks if an admin user exists.
   */
  async existsAdmin(): Promise<boolean> {
    const [row] = await db
      .select({ count: sql`count(*)` })
      .from(users)
      .where(eq(users.role, "admin"))
      .limit(1);

    return Number(row?.count || 0) > 0;
  }
}

// Inline import helper to prevent ts-node/bundler issues with sql template literals
import { sql } from "drizzle-orm";
