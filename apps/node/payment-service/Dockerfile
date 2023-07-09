FROM node:18 as build

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

FROM node:18 as run

COPY --from=build /app/dist /app/dist

WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production

ENV PORT=5000
EXPOSE 5000

CMD ["node", "/app/dist/index.mjs"]