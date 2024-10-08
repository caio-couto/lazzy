# BUILD FOR LOCAL DEVELOPMENT
FROM --platform=linux/amd64 node:22-alpine As development
WORKDIR /usr/src
COPY --chown=node:node package*.json ./
RUN npm ci
COPY --chown=node:node . .
USER node

# BUILD FOR LOCAL PRODUCTION
FROM --platform=linux/amd64 node:22-alpine As build
WORKDIR /usr/src
COPY --chown=node:node package*.json ./
RUN npm ci
COPY --chown=node:node . .
RUN npm run build
ENV NODE_ENV production
RUN npm ci --omit=dev && npm cache clean --force
USER node

# BUILD FOR PRODUCTION
FROM --platform=linux/amd64 node:22-alpine As production
COPY --chown=node:node --from=build /usr/src/dist ./dist
COPY --chown=node:node --from=build /usr/src/node_modules ./node_modules
CMD [ "node", "dist/index.js" ]