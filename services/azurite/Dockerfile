FROM mcr.microsoft.com/azure-storage/azurite:3.23.0

WORKDIR /app

COPY ["./package.json", "./package-lock.json", "./"]
RUN npm install --also=dev

COPY [".", "./"]

RUN npm run init

# connection string
# DefaultEndpointsProtocol=https;AccountName=devstoreaccount1;AccountKey=Eby8vdM02xNOcqFlqUwJPLlmEtlCDXJ1OUzFT50uSRZ6IFsuFq2UVErCz4I6tq/K1SZFPTOtr/KBHBeksoGMGw==;BlobEndpoint=https://127.0.0.1:10000/devstoreaccount1;QueueEndpoint=https://127.0.0.1:10001/devstoreaccount1;TableEndpoint=https://127.0.0.1:10002/devstoreaccount1