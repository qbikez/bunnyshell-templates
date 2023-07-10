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

COPY ["./package-components.ps1", "./"]
COPY ["components/", "./components/"]

EXPOSE 3000
COPY ["./*.ps1", "./"]

CMD [ "pwsh", "./entrypoint.ps1" ]
