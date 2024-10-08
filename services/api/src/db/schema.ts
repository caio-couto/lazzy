import {
  boolean,
  pgTable,
  text,
  timestamp,
  uuid,
  varchar,
} from "drizzle-orm/pg-core";

export const todos = pgTable("todos", {
  id: uuid("id").defaultRandom().primaryKey(),
  task: varchar("task", { length: 255 }).notNull(),
  description: text("description"),
  dueDate: timestamp("due_date"),
  doneAt: timestamp("done_at"),
  isDone: boolean("is_done").default(false),
  createdAt: timestamp("created_at").defaultNow(),
  updatedAt: timestamp("updated_at").defaultNow(),
});
