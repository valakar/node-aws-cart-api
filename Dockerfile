# Build Image
FROM node:14.15.1-alpine AS BUILD_IMAGE
WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

# Main Image
FROM node:14.15.1-alpine
WORKDIR /app
USER node

# copy from build image
COPY --from=BUILD_IMAGE /app/dist ./dist
COPY --from=BUILD_IMAGE /app/node_modules ./node_modules

ENV PORT=8080
EXPOSE 8080

CMD ["node", "dist/main.js"]
