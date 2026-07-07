import type { Context, Next } from "hono";
import { jwtVerify } from "jose";

export interface AuthUser {
  id: string;
  email: string;
  role: "admin" | "customer";
  name: string;
}

/**
 * Authentication middleware that verifies JWT and optionally checks for authorized roles.
 *
 * @param roles - Optional list of allowed roles (e.g., ['admin'])
 */
export function authMiddleware(roles?: Array<"admin" | "customer">) {
  return async (c: Context, next: Next) => {
    const authHeader = c.req.header("Authorization");
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
      return c.json(
        {
          success: false,
          error: "Unauthorized: Missing or invalid Authorization header",
        },
        401,
      );
    }

    const token = authHeader.substring(7);
    try {
      const secret = new TextEncoder().encode(
        process.env.JWT_SECRET || "supersecretjwtkey1234567890!",
      );
      const { payload } = await jwtVerify(token, secret);

      const user = {
        id: payload.id as string,
        email: payload.email as string,
        role: payload.role as "admin" | "customer",
        name: payload.name as string,
      };

      // Role check validation
      if (roles && roles.length > 0 && !roles.includes(user.role)) {
        return c.json(
          {
            success: false,
            error: "Forbidden: Insufficient permissions",
          },
          403,
        );
      }

      // Inject user payload into Hono's execution context
      c.set("user", user);
      await next();
    } catch {
      return c.json(
        {
          success: false,
          error: "Unauthorized: Invalid or expired token",
        },
        401,
      );
    }
  };
}
