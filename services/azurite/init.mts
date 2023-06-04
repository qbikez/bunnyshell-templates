import { BlobServiceClient, StorageSharedKeyCredential } from '@azure/storage-blob'
import  * as dotenv from 'dotenv'

dotenv.config()

const c = new BlobServiceClient("http://localhost:10000/devstoreaccount1/", new StorageSharedKeyCredential("devstoreaccount1", "Eby8vdM02xNOcqFlqUwJPLlmEtlCDXJ1OUzFT50uSRZ6IFsuFq2UVErCz4I6tq/K1SZFPTOtr/KBHBeksoGMGw=="));

await c.getContainerClient("oc-private").createIfNotExists();
await c.getContainerClient("oc-public").createIfNotExists({ access: "blob"});
