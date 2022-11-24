FROM node:16-slim
ENV NODE_ENV production

RUN apt-get update
RUN apt-get install -y openssl

WORKDIR /app

RUN mkdir -p /app/dist

RUN yarn global add typescript

COPY . .
RUN yarn install --production && yarn prisma generate
# RUN yarn prisma migrate deploy
# RUN yarn ts-node -e "import {seedProd} from './db/seed/seed.prod';seedProd()"
RUN cp -r prisma /app/dist
RUN ln -s "$PWD/node_modules" /app/dist/node_modules
RUN tsc
RUN echo : > .env
RUN echo "SERVER_BACKEND_HOST=\"$SERVER_BACKEND_HOST\"" >> .env
RUN echo "SERVER_BACKEND_PORT=\"$SERVER_BACKEND_PORT\"" >> .env
RUN echo "SERVER_BACKEND_NAME=\"$SERVER_BACKEND_NAME\"" >> .env
RUN echo "SERVER_BACKEND_API_PREFIX=\"$SERVER_BACKEND_API_PREFIX\"" >> .env
RUN echo "SERVER_BACKEND_PROTOCOL=\"$SERVER_BACKEND_PROTOCOL\"" >> .env
RUN echo "SERVER_BACKEND_DB_URL=\"$SERVER_BACKEND_DB_URL\"" >> .env
# RUN yarn ts-node -e "import {seedProd} from './db/seed/seed.prod';seedProd()"
RUN cp package.json .env yarn.lock /app/dist

WORKDIR /app/dist
EXPOSE 8000 
CMD ["node", "index.js"]
