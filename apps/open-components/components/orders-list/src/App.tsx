import { useEffect, useState } from "react";
// import { useData } from "oc-template-typescript-react-compiler/utils/useData";
import styles from "./styles.css";
import type { ClientProps } from "./types";
import { useAsyncEffect, useStaticCallback } from "./utils/hooks";
import * as signalR from "@microsoft/signalr";

interface Order {
  orderId: string;
  status: string;
}

interface Orders {
  [key: string]: Order;
}

const App: React.FC<ClientProps> = (props) => {
  const { ordersUrl } = props;
  const signalRUrl = `${ordersUrl}/orders/signalr/notifications`;

  const [orders, setOrders] = useState<Orders | null>(null);
  const [error, setError] = useState("");

  const fetchData = async () => {
    setError("");
    try {
      const response = await fetch(`${ordersUrl}/orders`);
      const data = (await response.json()) as Orders;
      setOrders(data);
    } catch (err) {
      console.error(err);
      setError(String(err));
    }
  };

  const refreshCallback = useStaticCallback(async () => {
    console.log(`refreshing data`);
    await fetchData();
  }, []);

  const connectSignalr = async (connection: signalR.HubConnection) => {
    try {
      await connection.start();
      console.log(`SignalR Connected. ${connection.connectionId}`);
      refreshCallback();
    } catch (err) {
      console.log(
        `failed to connect ${connection.connectionId}. retrying... `,
        err
      );
      setTimeout(async () => await connectSignalr(connection), 5000);
    }
  };

  useAsyncEffect(async () => {
    console.log("connecting to signalr");
    const connection = new signalR.HubConnectionBuilder()
      .withUrl(signalRUrl, {
        withCredentials: false,
      })
      .configureLogging(signalR.LogLevel.Information)
      .build();

    connection.onclose(async () => {
      console.log(`signalr connection ${connection.connectionId} closed.`);
      await connectSignalr(connection);
    });

    connection.on("messageReceived", async (message) => {
      console.log(`message received on ${connection.connectionId}`, message);
      await refreshCallback();
    });

    await connectSignalr(connection);

    return async () => {
      console.log(`disconnecting from signalr ${connection.connectionId}`);
      await connection.stop();
    };
  }, []);

  useEffect(() => {
    void fetchData();
  }, []);

  if (error) {
    return <div>Something wrong happened!</div>;
  }

  return (
    <div data-testId="order-list">
      {Object.entries(orders || {}).map(([key, order]) => (
        <div key={key} className={styles.order}>
          <span className={styles.orderId}>{order.orderId}|</span>
          <span className={styles.status}>{order.status}</span>
        </div>
      ))}
    </div>
  );
};

export default App;
