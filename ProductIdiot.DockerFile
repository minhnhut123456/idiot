FROM node:14.19.0-alpine as base

WORKDIR /app
COPY package.json yarn.lock /app/
RUN yarn install


FROM node:14.19.0-alpine as builder

WORKDIR /app
COPY . .
COPY --from=base /app/node_modules ./node_modules
RUN yarn build

FROM node:14.19.0-alpine as start
WORKDIR /app

COPY --from=builder /app/dist/apps/products-idiot/next.config.js ./
COPY --from=builder /app/dist/apps/products-idiot/public ./public
COPY --from=builder /app/dist/apps/products-idiot/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
CMD ["node_modules/.bin/next", "start"]

