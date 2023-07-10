import "./App.css";
import OpenComponentsClient from "./components/OpenComponentsClient";

function App() {
  const ocRegistry = import.meta.env.VITE_OC_REGISTRY;
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
