import express from "express";
import bodyParser from "body-parser";

declare global {
  namespace NodeJS {
    interface ImportMeta {
      hot: {};
    }
  }
}

const port = 3000;

const app = express();

app.use(bodyParser.json());
app.get("/", (req, res) => {
  res.send("hello from payment service");
});

app.post("/pay", (req, res) => {
  const { orderId } = req.body;
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
