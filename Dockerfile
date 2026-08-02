# Standard Node.js Dockerfile for Octree Next.js Frontend
FROM node:20-alpine WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm install

# Copy application code and build Next.js
COPY . .
ENV NEXT_TELEMETRY_DISABLED=1
RUN npm run build

EXPOSE 3000

ENV PORT=3000
ENV HOSTNAME="0.0.0.0"

CMD ["npm", "run", "start"]
