import { drizzle } from "drizzle-orm/libsql";
import { createClient } from "@libsql/client";
import * as schema from "./schema.ts";

const url = process.env.DATABASE_URL || "file:smartpyme.db";

const client = createClient({
  url,
});

export const db = drizzle(client, { schema });
export type DbType = typeof db;
export * as schema from "./schema.ts";
