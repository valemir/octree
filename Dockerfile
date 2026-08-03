# Standard Node.js Dockerfile for Octree Next.js Frontend
FROM node:20-alpine
WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm install --legacy-peer-deps

# Copy application code
COPY . .

# Build-time Environment Variables for Next.js build
ENV NEXT_TELEMETRY_DISABLED=1
ENV NODE_ENV=production
ENV NODE_OPTIONS="--max-old-space-size=4096"
ENV NEXT_PUBLIC_SUPABASE_URL="https://placeholder.supabase.co"
ENV NEXT_PUBLIC_SUPABASE_ANON_KEY="placeholder"
ENV NEXT_PUBLIC_AGENT_SERVER_URL="http://localhost:8787"
ENV SUPABASE_JWT_SECRET="super_secret_jwt_key_for_octree_12345"
ENV DATABASE_URL="postgres://postgres:octree_password@postgres:5432/octree_db"

# Execute Next.js production build
RUN npm run build

EXPOSE 3000

ENV PORT=3000
ENV HOSTNAME="0.0.0.0"

CMD ["npm", "run", "start"]