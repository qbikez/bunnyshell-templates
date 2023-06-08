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
      <div>
        <a href="https://vitejs.dev" target="_blank">
          <img src={viteLogo} className="logo" alt="Vite logo" />
        </a>
        <a href="https://react.dev" target="_blank">
          <img src={reactLogo} className="logo react" alt="React logo" />
        </a>
      </div>
      <h1>Vite + React</h1>
      <div className="card">
        <button onClick={() => setCount((count) => count + 1)}>
          count is {count}
        </button>
        <p>
          Edit <code>src/App.tsx</code> and save to test HMR
        </p>
      </div>
      <div>
        <button
          onClick={async () => {
            const response = await fetch("api/WeatherForecast");
            const data = await response.json();
            setWeather(data);
            console.log(data);
          }}
        >
          weather?
        </button>
        <div>
          {weather.map((w) => (
            <div key={w.date}>
              <span>{w.date}|</span>
              <span>{w.temperatureC}|</span>
              <span>{w.summary}</span>
            </div>
          ))}
        </div>
      </div>
      <p className="read-the-docs">
        Click on the Vite and React logos to learn more
      </p>
      <oc-component
        href={`${ocRegistry}/hello-world/1.x.x/?userId=1`}
      ></oc-component>
    </>
  );
}

export default App;
