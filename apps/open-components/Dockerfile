FROM node:18 as registry

COPY ["./install-powershell-debian.sh", "./"]
RUN chmod u+x ./install-powershell-debian.sh && ./install-powershell-debian.sh

WORKDIR /app/oc-registry

COPY ["oc-registry/package*.json", "./"]
COPY ["oc-registry/patches/", "./patches/"]
RUN npm ci

COPY ["oc-registry/", "./"]
RUN npm run build

WORKDIR /app

COPY ["package*.json", "./"]
RUN npm ci

COPY ["components/", "./components/"]
COPY ["./*.ps1", "./"]

EXPOSE 3000

CMD [ "pwsh", "./entrypoint.ps1" ]
