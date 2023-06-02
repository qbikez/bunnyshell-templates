FROM node:18 as builder

WORKDIR /app
COPY ["package.json", "package-lock.json", "./"]

RUN npm ci

COPY . .
RUN npm run build

FROM builder as dev

EXPOSE 3000

ENV APPSETTING_STORAGE_ACCOUNT_NAME "devstoreaccount1"
ENV APPSETTING_STORAGE_ACCOUNT_KEY  "Eby8vdM02xNOcqFlqUwJPLlmEtlCDXJ1OUzFT50uSRZ6IFsuFq2UVErCz4I6tq/K1SZFPTOtr/KBHBeksoGMGw=="
ENV APPSETTING_CDN_ENDPOINT ""
ENV APPSETTING_BLOB_URL "http://localhost:10002/devstoreaccount1/"
ENV APPSETTING_REGISTRY_USERNAME "user"
ENV APPSETTING_REGISTRY_PASSWORD "pass"
ENV APPSETTING_BASEURL: "http://localhost:3000"

CMD ["npm", "start"]

# FROM node:18 as release

# WORKDIR /app

# COPY ["package.json", "package-lock.json", "./"]
# COPY --from=builder /app/build ./build

# EXPOSE 3000

# CMD ["node", "/app/index.js"]
