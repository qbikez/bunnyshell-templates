import express from "express";
import bodyParser from "body-parser";
import { ServiceBusClient } from "@azure/service-bus";
import * as dotenv from "dotenv";

declare global {
  namespace NodeJS {
    interface ImportMeta {
      hot: {};
    }
  }
}

// Load the .env file if it exists
dotenv.config();

// Define connection string and related Service Bus entity names here
const connectionString = process.env.SERVICEBUS_CONNECTIONSTRING!;
const queueName = process.env.QUEUE_NAME!;

const port = process.env.PORT || 5000;

const sbClient = new ServiceBusClient(connectionString);
const sender = sbClient.createSender(queueName);

const app = express();

app.use(bodyParser.json());
app.get("/", (req, res) => {
  res.send("hello from payment service");
});

app.post("/pay", async (req, res) => {
  const { orderId } = req.body;

  await sender.sendMessages({
    body: JSON.stringify({
      command: "pay",
      orderId,
    }),
  });
  console.log(`payment accepted for order ${orderId}`);
  res.status(204).json({ message: "payment accepted" });
});

const server = app.listen(port, () => {
  console.log(`Payments listening on port ${port}`);
});

if ((import.meta as any).hot) {
  // need to manually kill old server before reloading
  // https://github.com/vitest-dev/vitest/issues/2334
  (import.meta as any).hot.on("vite:beforeFullReload", () => {
    server.close();
  });
}
