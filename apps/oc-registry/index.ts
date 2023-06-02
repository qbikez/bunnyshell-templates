import * as oc from "oc";
import { Config } from "oc/dist/types";
import azure from "oc-azure-storage-adapter";
import dotnev from "dotenv";

dotnev.config();

const cdnEndpoint = process.env.APPSETTING_CDN_ENDPOINT;

var configuration: Partial<Config> = {
  verbosity: 0,
  port: 3000,
  tempDir: "./temp/",
  refreshInterval: 600,
  pollingInterval: 5,
  publishAuth: {
    type: "basic",
    username: process.env.APPSETTING_REGISTRY_USERNAME,
    password: process.env.APPSETTING_REGISTRY_PASSWORD,
  },
  env: { name: "production" },
  storage: {
    adapter: azure,
    options: {
      accountName: process.env.APPSETTING_STORAGE_ACCOUNT_NAME,
      accountKey: process.env.APPSETTING_STORAGE_ACCOUNT_KEY,
      publicContainerName: "oc-public",
      privateContainerName: "oc-private",
      path: `${cdnEndpoint}oc-public/`,
      componentsDir: "components",
    },
  },
};

var registry = oc.Registry({
  ...configuration,
  baseUrl: process.env.APPSETTING_BASEURL || "http://localhost:3000/"
});

registry.start(function (err, app) {
  if (err) {
    console.log("Registry not started: ", err);
    process.exit(1);
  }
  
  console.log(`Registry started successfully.`);
});
