FROM node:18

WORKDIR /oc

COPY ["package.json", "package-lock.json", "./"]
RUN npm ci

COPY ["./install.sh", "./"]

COPY ["hello-world/", "./hello-world/"]
RUN chmod u+x ./install.sh && ./install.sh

COPY ["./publish.sh", "./"]
RUN chmod u+x ./publish.sh

CMD [ "/bin/bash", "./publish.sh" ]
