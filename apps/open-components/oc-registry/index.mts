import oc from "oc";
//const oc = (ocPkg as any).default;
//import type { Config } from "oc/dist";
import * as azurePkg from "oc-azure-storage-adapter";
import * as dotnev from "dotenv";
const azure = azurePkg.default;
import typescriptReact from 'oc-template-typescript-react';
import * as blobStorage from "@azure/storage-blob";

dotnev.config();

var blobService = new blobStorage.BlobServiceClient(process.env.APPSETTING_BLOB_URL!, new blobStorage.StorageSharedKeyCredential(process.env.APPSETTING_STORAGE_ACCOUNT_NAME!, process.env.APPSETTING_STORAGE_ACCOUNT_KEY!));

await blobService.getContainerClient("oc-private").createIfNotExists();
await blobService.getContainerClient("oc-public").createIfNotExists({ access: "blob"});

const cdnEndpoint = process.env.APPSETTING_CDN_ENDPOINT;

var configuration = {
  verbosity: 0,
  port: 3000,
  tempDir: "./temp/",
  prefix: '/registry/',
  refreshInterval: 600,
  pollingInterval: 5,
  publishAuth: {
    type: "basic",
    username: process.env.APPSETTING_REGISTRY_USERNAME,
    password: process.env.APPSETTING_REGISTRY_PASSWORD,
  },
  env: { name: process.env.ENV_NAME || "production" },
  storage: {
    adapter: (options: any) => azure(options),
    options: {
      accountName: process.env.APPSETTING_STORAGE_ACCOUNT_NAME,
      accountKey: process.env.APPSETTING_STORAGE_ACCOUNT_KEY,
      publicContainerName: "oc-public",
      privateContainerName: "oc-private",
      path: `${cdnEndpoint}oc-public/`,
      componentsDir: "components",
      blobUrl: process.env.APPSETTING_BLOB_URL,
    },
  },
  templates: [
    typescriptReact
  ]
};

console.log("Configuration: ", configuration);

var registry = oc.Registry({
  ...configuration,
  baseUrl: process.env.APPSETTING_BASEURL  || "http://localhost:3000/"
});

registry.start(function (err: any, app: any) {
  if (err) {
    console.log("Registry not started: ", err);
    process.exit(1);
  }
  
  console.log(`Registry started successfully.`);
});
