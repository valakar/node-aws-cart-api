# Build Image
FROM node:14.15.1 AS BUILD_IMAGE

# install node-prune (https://github.com/tj/node-prune)
RUN curl -sfL https://install.goreleaser.com/github.com/tj/node-prune.sh | bash -s -- -b /usr/local/bin

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

# Remove dev dependencies
RUN npm prune --production

# Remove redundant dependencies
RUN /usr/local/bin/node-prune

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
