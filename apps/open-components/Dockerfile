FROM node:18

WORKDIR /oc

COPY ["./install-powershell-debian.sh", "./"]
RUN chmod u+x ./install-powershell-debian.sh && ./install-powershell-debian.sh

COPY ["package.json", "package-lock.json", "./"]
RUN npm ci

COPY ["./install.sh", "./"]
COPY ["hello-world/", "./hello-world/"]
RUN chmod u+x ./install.sh && ./install.sh

COPY ["./*.ps1", "./"]
RUN chmod u+x ./*.ps1

CMD [ "pwsh", "./publish-components.ps1" ]
