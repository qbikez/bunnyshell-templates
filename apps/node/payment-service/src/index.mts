import express from "express";
import bodyParser from "body-parser";
import { ServiceBusClient } from "@azure/service-bus";
import * as dotenv from "dotenv";

const delay = 5000;

declare global {
  namespace NodeJS {
    interface ImportMeta {
      hot: {};
    }
  }
}

type CommandMessage = {
  command: "paymentComplete" | "pay";
  order: {
    orderId: string;
  };
};

// Load the .env file if it exists
dotenv.config();

// Define connection string and related Service Bus entity names here
const connectionString = process.env.SERVICEBUS_CONNECTIONSTRING!;
const topic = "payments";
const subscription = "payment-processing";

const port = process.env.PORT || 5000;

const sbClient = new ServiceBusClient(connectionString);
const sender = sbClient.createSender(topic);
const receiver = sbClient.createReceiver(topic, subscription, {
  receiveMode: "peekLock",
});

// subscribe and specify the message and error handlers
receiver.subscribe(
  {
    processMessage: async (message) => {
      console.log("handling message ", message.body);
      const body = message.body as CommandMessage;
      if (body.command === "pay") {
        const { orderId } = body.order;
        await new Promise((resolve) => setTimeout(resolve, delay));
        await sender.sendMessages({
          body: {
            command: "paymentComplete",
            order: {
              orderId,
              status: "complete",
            },
          } as CommandMessage,
        });

        //console.log(`payment complete for order ${orderId}!`);
      }

      await receiver.completeMessage(message);
    },
    processError: async ({ error }) => {
      console.error("error: ", error);
    },
  },
  {
    autoCompleteMessages: false,
  }
);

const app = express();

app.use(bodyParser.json());
app.get("/", (req, res) => {
  res.send("hello from payment service");
});

app.post("/pay", async (req, res) => {
  const { orderId } = req.body;

  await sender.sendMessages({
    body: {
      command: "pay",
      order: {
        orderId,
        status: "pending",
      },
    } as CommandMessage,
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
  (import.meta as any).hot.on("vite:beforeFullReload", async () => {
    console.log("hot reloading server...");
    await server.close();
  });
  (import.meta as any).hot.dispose(async () => {
    await server.close();
  });
}
