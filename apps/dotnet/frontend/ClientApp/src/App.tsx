import { useState } from "react";
import reactLogo from "./assets/react.svg";
import viteLogo from "/vite.svg";
import "./App.css";
import OpenComponentsClient from "./components/OpenComponentsClient";

function App() {
  const ocRegistry = import.meta.env.VITE_OC_REGISTRY;
  const [count, setCount] = useState(0);
  const [weather, setWeather] = useState<
    Array<{
      date: string;
      temperatureC: number;
      summary: string;
    }>
  >([]);

  return (
    <>
      <OpenComponentsClient
        reactVersion="18.2.0"
        ocOrigin={ocRegistry}
      ></OpenComponentsClient>
      
      <oc-component
        href={`${ocRegistry}/hello-world/1.x.x/?userId=1`}
      ></oc-component>
      <oc-component
        href={`${ocRegistry}/orders/1.x.x/`}
      ></oc-component>
      
    </>
  );
}

export default App;
