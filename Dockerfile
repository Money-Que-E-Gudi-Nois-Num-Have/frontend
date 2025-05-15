FROM node:hydrogen-alpine AS cli

RUN npm i --global @angular/cli

RUN apk add --no-cache bash \
    && sed -i "s|/bin/sh|/bin/bash|" /etc/passwd

USER node

WORKDIR /home/node/app

FROM cli AS base

COPY --chown=node:node package*.json .

FROM base AS development

COPY --chown=node:node . .

ENTRYPOINT ["npm", "start", "--", "--host", "0.0.0.0"]

FROM base AS production

ENV NODE_ENV=production

RUN npm install

COPY . .

RUN npm run build

CMD ["npm", "run", "build"]
