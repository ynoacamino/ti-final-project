/**
 * Represents a User domain entity within the SmartPyME system.
 * This entity encapsulates the core business rules and data for users (both admins and customers).
 */
export class User {
  /**
   * Creates a new instance of the User domain entity.
   *
   * @param id The unique identifier (UUID v4)
   * @param email The unique email address
   * @param passwordHash The bcrypt hased password
   * @param name The full name of the user
   * @param phone The contact phone number (optional)
   * @param role The role in the system ('admin' or 'customer')
   * @param defaultShippingAddress The default address for shipping (optional)
   * @param isActive Status of the user account (active or inactive)
   * @param createdAt Date of creation
   * @param updatedAt Date of last modification
   */
  constructor(
    public readonly id: string,
    public readonly email: string,
    public readonly passwordHash: string,
    public readonly name: string,
    public readonly phone: string | null,
    public readonly role: "admin" | "customer",
    public readonly defaultShippingAddress: string | null,
    public readonly isActive: boolean,
    public readonly createdAt: string,
    public readonly updatedAt: string,
  ) {}

  /**
   * Helper factory to create a new user domain entity.
   */
  public static create(params: {
    id: string;
    email: string;
    passwordHash: string;
    name: string;
    phone?: string | null;
    role: "admin" | "customer";
    defaultShippingAddress?: string | null;
    isActive?: boolean;
    createdAt?: string;
    updatedAt?: string;
  }): User {
    const now = new Date().toISOString();
    return new User(
      params.id,
      params.email,
      params.passwordHash,
      params.name,
      params.phone ?? null,
      params.role,
      params.defaultShippingAddress ?? null,
      params.isActive ?? true,
      params.createdAt ?? now,
      params.updatedAt ?? now,
    );
  }
}
