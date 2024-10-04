import "dotenv/config";
import type { Config } from "drizzle-kit";

export default {
  schema: "./src/db/schema.ts",
  out: "./drizzle",
  dbCredentials: {
    database: "todos",
    host: "localhost",
    port: 5432,
    user: "postgres",
    password: "password",
    ssl: false,
  },
  verbose: true,
  dialect: "postgresql",
} satisfies Config;
