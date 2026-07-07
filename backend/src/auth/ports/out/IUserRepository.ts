import type { User } from "../../core/User.ts";

export interface IUserRepository {
  findByEmail(email: string): Promise<User | null>;
  findById(id: string): Promise<User | null>;
  save(user: User): Promise<void>;
  existsAdmin(): Promise<boolean>;
}
