FROM mcr.microsoft.com/azure-storage/azurite:3.23.0

WORKDIR /app

COPY ["./package.json", "./package-lock.json", "./"]
RUN npm install --also=dev

COPY [".", "./"]

RUN npm run init