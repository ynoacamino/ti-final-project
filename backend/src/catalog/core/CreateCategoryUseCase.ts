import type {
  ICreateCategoryUseCase,
  CreateCategoryDTO,
} from "../ports/in/ICreateCategoryUseCase.ts";
import type { ICategoryRepository } from "../ports/out/ICategoryRepository.ts";
import { Category } from "./Category.ts";
import { generateSlug } from "../../shared/utils/slug.ts";

/**
 *
 */
export class CreateCategoryUseCase implements ICreateCategoryUseCase {
  /**
   *
   */
  constructor(private readonly categoryRepository: ICategoryRepository) {}

  /**
   *
   */
  async execute(dto: CreateCategoryDTO): Promise<Category> {
    const existingCategory = await this.categoryRepository.findByName(dto.name);
    if (existingCategory) {
      throw new Error("Category name already exists");
    }

    const slug = generateSlug(dto.name);
    const newCategory = Category.create({
      id: crypto.randomUUID(),
      name: dto.name,
      slug,
      description: dto.description,
      isActive: true,
    });

    await this.categoryRepository.save(newCategory);
    return newCategory;
  }
}
