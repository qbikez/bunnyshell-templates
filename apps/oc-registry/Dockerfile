FROM node:18 as builder

WORKDIR /app
COPY ["package.json", "package-lock.json", "./"]
COPY ["patches/", "./patches/"]

RUN npm ci
RUN npx patch-package

COPY . .
RUN npm run build

FROM builder as dev

EXPOSE 3000

CMD ["npm", "start"]

# FROM node:18 as release

# WORKDIR /app

# COPY ["package.json", "package-lock.json", "./"]
# COPY --from=builder /app/build ./build

# EXPOSE 3000

# CMD ["node", "/app/index.js"]
