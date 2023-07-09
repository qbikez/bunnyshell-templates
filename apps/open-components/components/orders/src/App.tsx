import { useEffect, useState } from "react";
import { useData } from "oc-template-typescript-react-compiler/utils/useData";
import styles from "./styles.css";
import logo from "../public/logo.png";
import type { AdditionalData, ClientProps } from "./types";

interface Order {
  orderId: string;
  status: string;
}

interface Orders {
  [key: string]: Order;
}

const apiUrl = "http://localhost:5223";

const App: React.FC<ClientProps> = () => {
  
  const [orders, setOrders] = useState<Orders | null>(null);
  const [error, setError] = useState("");

  const fetchData = async () => {
    setError("");
    try {
      const response = await fetch(`${apiUrl}/orders`);
      const data = await response.json() as Orders;
      setOrders(data);
    } catch (err) {
      console.error(err);
      setError(String(err));
    }
  };

  useEffect(() => {
    void fetchData();
  }, []);

  if (error) {
    return <div>Something wrong happened!</div>;
  }

  return (
    <div>
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
