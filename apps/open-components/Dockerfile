FROM node:18

WORKDIR /oc

COPY ["package.json", "package-lock.json", "./"]
RUN npm ci

COPY ["./install.sh", "./"]

COPY ["hello-world/", "./hello-world/"]
RUN ./install.sh

COPY ["./publish.sh", "./"]

CMD [ "/bin/bash", "./publish.sh" ]
