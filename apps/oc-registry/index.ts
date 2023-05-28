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

  env: { name: "production" },
  storage: {
    adapter: azure,
    options: {
      accountName: process.env.APPSETTING_STORAGE_ACCOUNT_NAME || "not-set",
      accountKey: process.env.APPSETTING_STORAGE_ACCOUNT_KEY || "not-set",
      publicContainerName: "oc-public",
      privateContainerName: "oc-private",
      path: `${cdnEndpoint}oc-public/`,
      componentsDir: "components",
    },
  },
};

var registry = oc.Registry({
  ...configuration,
  baseUrl: "https://my-components-registry.mydomain.com/",
});

registry.start(function (err, app) {
  if (err) {
    console.log("Registry not started: ", err);
    process.exit(1);
  }
  
  console.log(`Registry started successfully.`);
});
