import type { ClientProps } from './types';

const paymentsUrl = "http://localhost:5000";

interface AppProps extends ClientProps {
  getMoreData?: boolean;
}

const App: React.FC<ClientProps> = () => {
  const sendPayments = async () => {
    const orderId = crypto.randomUUID();
    const response = await fetch(`${paymentsUrl}/pay`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ orderId }),
    });
    const data = await response.json();
    console.log(data);
  };
  return (
    <div>
      <button onClick={() => void sendPayments()}>Place Order</button>
    </div>
  )
};

export default App;
