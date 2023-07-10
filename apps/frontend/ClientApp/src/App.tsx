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
        href={`${ocRegistry}/pay-button/1.x.x/`}
      ></oc-component>
      <oc-component
        href={`${ocRegistry}/orders-list/1.x.x/`}
      ></oc-component>
      
    </>
  );
}

export default App;
