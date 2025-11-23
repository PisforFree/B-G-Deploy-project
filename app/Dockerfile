# Lightweight Node.js runtime
FROM node:20-alpine

# Create app directory
WORKDIR /usr/src/app

# Install dependencies first (better layer cache)
COPY package*.json ./
RUN npm install --only=production

# Copy application source
COPY . .

# App listens on port 80 (matches server.js default)
EXPOSE 80

# Start the HTTP server
CMD ["npm", "start"]
