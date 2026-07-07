import { defineConfig } from "drizzle-kit";

export default defineConfig({
  schema: "./src/shared/infrastructure/database/schema.ts",
  out: "./drizzle",
  dialect: "sqlite",
  dbCredentials: {
    url: process.env.DATABASE_URL || "file:smartpyme.db",
  },
});
