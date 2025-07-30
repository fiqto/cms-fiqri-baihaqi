FROM node:18-alpine

# Installing libvips-dev for sharp Compatibility
RUN apk update && apk add --no-cache build-base gcc autoconf automake zlib-dev libpng-dev nasm bash vips-dev git

WORKDIR /opt/app

# Create app directory and set permissions
RUN addgroup -g 1001 -S nodejs
RUN adduser -S strapi -u 1001

# Copy package files
COPY package.json ./
COPY package-lock.json* ./

# Install dependencies
RUN npm config set fetch-retry-maxtimeout 600000 -g
RUN npm ci --only=production && npm cache clean --force

# Copy app source
COPY . .

# Set ownership
RUN chown -R strapi:nodejs /opt/app
USER strapi

EXPOSE 1337

CMD ["npm", "run", "develop"]