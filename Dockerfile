FROM node:14.21.0-slim
WORKDIR /usr/src/app/
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 5000
CMD ["npm","start"]
