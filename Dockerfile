# 1. Dependencies Stage
FROM node:20-alpine AS deps
RUN apk add --no-cache libc6-compat
WORKDIR /app

COPY package*.json ./
RUN npm ci || npm install --legacy-peer-deps

# 2. Builder Stage
FROM node:20-alpine AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .

# Build-time Environment Variables
ENV NEXT_TELEMETRY_DISABLED=1
ENV NODE_ENV=production
ENV NODE_OPTIONS="--max-old-space-size=4096"

ENV NEXT_PUBLIC_SUPABASE_URL="https://placeholder.supabase.co"
ENV NEXT_PUBLIC_SUPABASE_ANON_KEY="placeholder_anon_key"
ENV NEXT_PUBLIC_AGENT_SERVER_URL="http://localhost:8787"
ENV SUPABASE_JWT_SECRET="super_secret_jwt_key_for_octree_12345"
ENV DATABASE_URL="postgres://postgres:octree_password@postgres:5432/octree_db"
ENV RESEND_API_KEY="re_123456789_placeholder_for_build"
ENV STRIPE_SECRET_KEY="sk_test_123456789_placeholder"
ENV NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY="pk_test_123456789_placeholder"
ENV ANTHROPIC_API_KEY="sk-ant-api03-placeholder"
ENV OPENAI_API_KEY="sk-placeholder"

# Compile Next.js production bundle
RUN npm run build

# 3. Runner Stage
FROM node:20-alpine AS runner
WORKDIR /app

ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

COPY --from=builder /app/public ./public
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

USER nextjs

EXPOSE 3000

ENV PORT=3000
ENV HOSTNAME="0.0.0.0"

CMD ["node", "server.js"]