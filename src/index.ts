import "dotenv/config";
import { db, todos } from "./db";
import express, { NextFunction, Request, Response } from "express";
import { createServer } from "http";
import { errorHandler, logger as pino } from "utils";
import { eq } from "drizzle-orm";
import { randomUUID } from "crypto";
import bodyParser from "body-parser";
import compression from "compression";
import cors from "cors";
import helmet from "helmet";
import pinoHttp from "pino-http";

const app = express();
const server = createServer(app);

const logger = pinoHttp({
  logger: pino,
  genReqId: (req: Request, res: Response) => {
    const existingId = req.id ?? req.header["x-request-id"];

    if (existingId) {
      return existingId;
    }

    const id = randomUUID();
    res.setHeader("x-request-id", id);
    return id;
  },
});

app.use(express.json());
app.use(helmet());
app.use(compression());
app.use(cors());
app.use(logger);

app.get("/", (req: Request, res: Response) => {
  res.send("Hello World");
});

app.get("/healthcheck", (req: Request, res: Response) => {
  try {
    res.sendStatus(200).send();
  } catch (error) {
    res.status(500).send();
  }
});

app.get(
  "/api/v1/todos",
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const limit = Number(req.query.limit) ?? 10;
      const result = await db
        .select({
          id: todos.id,
          task: todos.task,
          description: todos.description,
          isDone: todos.isDone,
        })
        .from(todos)
        .limit(limit >= 1 && limit <= 50 ? limit : 10);
      req.log.info(result);
      res.json(result);
    } catch (error) {
      next(error);
    }
  }
);

app.get(
  "/api/v1/todos/:id",
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const result = await db
        .select()
        .from(todos)
        .where(eq(todos.id, req.params.id));
      req.log.info(result);
      res.status(result.length == 1 ? 200 : 404).json(result);
    } catch (error) {
      next(error);
    }
  }
);

app.post(
  "/api/v1/todos",
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const result = await db
        .insert(todos)
        .values({
          id: randomUUID(),
          task: req.body.task,
          description: req.body.description,
          ...(req.body.dueDate && { dueDate: new Date(req.body.dueDAte) }),
        })
        .returning();

      req.log.info(result);
      res.status(201).json(result);
    } catch (error) {
      next(error);
    }
  }
);

app.patch(
  "/api/v1/todos/:id",
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const today = new Date();
      const result = await db
        .update(todos)
        .set({
          isDone: req.body.isDone,
          doneAt: today,
          updatedAt: today,
        })
        .where(eq(todos.id, req.params.id))
        .returning();

      req.log.info(result);
      res.status(201).json(result);
    } catch (error) {
      next(error);
    }
  }
);

app.delete(
  "/api/v1/todos/:id",
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const result = await db.delete(todos).where(eq(todos.id, req.params.id));
      req.log.info(result);
      res.status(result.rowCount == 1 ? 200 : 404).json(result);
    } catch (error) {
      next(error);
    }
  }
);

app.use((err: any, req: Request, res: Response, next: NextFunction) => {
  errorHandler.handler(err, res);
});

const PORT = process.env.PORT ?? 8081;
server.listen(PORT, () => {
  pino.info(`Server is running on port ${PORT}`);
});

process.on("unhandledRejection", (reason, promise) => {
  pino.error({ promise, reason }, "Unhandled Rejection");
});

process.on("uncaughtException", (error) => {
  pino.error({ error }, "Uncaught Exception");

  server.close(() => {
    pino.info("Server closed");
    process.exit(1);
  });

  setTimeout(() => process.exit(1), 10000).unref();
});
