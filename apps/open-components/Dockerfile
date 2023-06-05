FROM node:18

WORKDIR /oc

COPY ["./install-powershell-debian.sh", "./"]
RUN chmod u+x ./install-powershell-debian.sh && ./install-powershell-debian.sh

COPY ["package.json", "package-lock.json", "./"]
RUN npm ci

COPY ["./package-components.ps1", "./"]

COPY ["components/", "./components/"]

RUN pwsh ./package-components.ps1


COPY ["./*.ps1", "./"]

CMD [ "pwsh", "./entrypoint.ps1" ]
