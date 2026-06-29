import { Hono } from "hono";
import { z } from "zod";
import { RegisterUseCase } from "../core/RegisterUseCase.ts";
import { LoginUseCase } from "../core/LoginUseCase.ts";
import { SqliteUserRepo } from "./SqliteUserRepo.ts";

export const authRouter = new Hono();

// Dependency Injection
const userRepo = new SqliteUserRepo();
const registerUseCase = new RegisterUseCase(userRepo);
const loginUseCase = new LoginUseCase(userRepo);

// Zod schemas for input validation
const registerSchema = z.object({
  email: z.string().email("Debe ser un correo electrónico válido"),
  password: z.string().min(6, "La contraseña debe tener al menos 6 caracteres"),
  name: z.string().min(2, "El nombre debe tener al menos 2 caracteres"),
  phone: z.string().optional(),
  role: z.enum(["admin", "customer"], {
    errorMap: () => ({ message: "El rol debe ser 'admin' o 'customer'" }),
  }),
});

const loginSchema = z.object({
  email: z.string().email("Debe ser un correo electrónico válido"),
  password: z.string().min(1, "La contraseña es obligatoria"),
});

/**
 * Route handler for user registration
 * POST /api/auth/register
 */
authRouter.post("/register", async (c) => {
  try {
    const body = await c.req.json().catch(() => ({}));
    const validation = registerSchema.safeParse(body);

    if (!validation.success) {
      return c.json(
        {
          success: false,
          errors: validation.error.flatten().fieldErrors,
        },
        400,
      );
    }

    const user = await registerUseCase.execute(validation.data);
    return c.json(
      {
        success: true,
        user: {
          id: user.id,
          email: user.email,
          name: user.name,
          role: user.role,
        },
      },
      201,
    );
  } catch (error: any) {
    return c.json(
      {
        success: false,
        error: error.message,
      },
      400,
    );
  }
});

/**
 * Route handler for user authentication
 * POST /api/auth/login
 */
authRouter.post("/login", async (c) => {
  try {
    const body = await c.req.json().catch(() => ({}));
    const validation = loginSchema.safeParse(body);

    if (!validation.success) {
      return c.json(
        {
          success: false,
          errors: validation.error.flatten().fieldErrors,
        },
        400,
      );
    }

    const result = await loginUseCase.execute(validation.data);
    return c.json(
      {
        success: true,
        ...result,
      },
      200,
    );
  } catch (error: any) {
    const status = error.message === "Invalid credentials" ? 401 : 400;
    return c.json(
      {
        success: false,
        error: error.message,
      },
      status,
    );
  }
});
