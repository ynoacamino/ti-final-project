/**
 * Represents a Category domain entity within the SmartPyME catalog.
 */
export class Category {
  /**
   *
   */
  constructor(
    public readonly id: string,
    public readonly name: string,
    public readonly slug: string,
    public readonly description: string | null,
    public readonly isActive: boolean,
    public readonly createdAt: string,
    public readonly updatedAt: string,
  ) {}

  /**
   *
   */
  public static create(params: {
    id: string;
    name: string;
    slug: string;
    description?: string | null;
    isActive?: boolean;
    createdAt?: string;
    updatedAt?: string;
  }): Category {
    const now = new Date().toISOString();
    return new Category(
      params.id,
      params.name,
      params.slug,
      params.description ?? null,
      params.isActive ?? true,
      params.createdAt ?? now,
      params.updatedAt ?? now,
    );
  }
}
