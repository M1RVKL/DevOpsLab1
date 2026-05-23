FROM node:18-alpine 

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install --production

COPY . .

RUN npx prisma generate && chmod +x entrypoint.sh

EXPOSE 8000

ENTRYPOINT ["./entrypoint.sh"]