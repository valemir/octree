# Standard Node.js Dockerfile for Octree Next.js Frontend
FROM node:20-alpine
WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm install --legacy-peer-deps

# Copy application code
COPY . .

# Build-time Environment & Memory Allocation
ENV NEXT_TELEMETRY_DISABLED=1
ENV NODE_ENV=production
ENV NODE_OPTIONS="--max-old-space-size=4096"
ENV NEXT_PUBLIC_SUPABASE_URL="https://placeholder.supabase.co"
ENV NEXT_PUBLIC_SUPABASE_ANON_KEY="placeholder"

# Build Next.js application
RUN npm run build

EXPOSE 3000

ENV PORT=3000
ENV HOSTNAME="0.0.0.0"

CMD ["npm", "run", "start"]
