import { Category } from "../../core/Category.ts";

export interface CreateCategoryDTO {
  name: string;
  description?: string;
}

export interface ICreateCategoryUseCase {
  execute(dto: CreateCategoryDTO): Promise<Category>;
}
