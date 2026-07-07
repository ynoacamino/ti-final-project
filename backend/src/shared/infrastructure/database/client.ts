import { drizzle } from "drizzle-orm/libsql";
import { createClient } from "@libsql/client";
import * as schema from "./schema.ts";

import * as fs from "fs";
import * as path from "path";

let url = process.env.DATABASE_URL || "file:smartpyme.db";

// Workaround for write operations on read-only serverless filesystem in Vercel
if (process.env.VERCEL && url.startsWith("file:")) {
  const dbName = url.substring(5); // e.g. "smartpyme.db"
  const sourcePath = path.join(process.cwd(), dbName);
  const destPath = path.join("/tmp", dbName);

  try {
    if (fs.existsSync(sourcePath)) {
      if (!fs.existsSync(destPath)) {
        fs.copyFileSync(sourcePath, destPath);
        console.log(`Copied database from ${sourcePath} to ${destPath} to enable write operations`);
      }
      url = `file:${destPath}`;
    }
  } catch (err) {
    console.error("Error setting up Vercel /tmp SQLite:", err);
  }
}

const client = createClient({
  url,
});

export const db = drizzle(client, { schema });
export type DbType = typeof db;
export * as schema from "./schema.ts";
