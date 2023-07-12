FROM node:20.4-alpine AS base

FROM base AS builder

WORKDIR /app/

ADD package.json package-lock.json .
RUN npm ci
ADD index.ts tsconfig.json .
RUN npm run build

FROM base

WORKDIR /app/
ADD package.json package-lock.json .
RUN npm ci --omit=dev
ADD . .
COPY --from=builder /app/index.js .

CMD node index.js
