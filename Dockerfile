# Stage 1: Build Angular app
FROM node:20-slim AS build
WORKDIR /usr/src/app

# Install dependencies
COPY package*.json ./
RUN npm ci --no-audit --no-fund

# Copy sources and build (production)
COPY . .
RUN npm run build -- --configuration production

# Stage 2: Serve with nginx
FROM nginx:alpine

# Use a custom nginx config to support SPA routing
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy built files from the build stage
COPY --from=build /usr/src/app/dist/test-module/browser/ /usr/share/nginx/html/

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
