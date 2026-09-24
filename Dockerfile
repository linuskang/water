FROM node:24-alpine AS deps

RUN apk add --no-cache libc6-compat
WORKDIR /app

COPY package.json package-lock.json ./
COPY apps/web/package.json ./apps/web/package.json
COPY packages/auth/package.json ./packages/auth/package.json
COPY packages/db/package.json ./packages/db/package.json
COPY packages/env/package.json ./packages/env/package.json
COPY packages/ui/package.json ./packages/ui/package.json
COPY tooling/eslint/package.json ./tooling/eslint/package.json
COPY tooling/prettier/package.json ./tooling/prettier/package.json
COPY tooling/typescript/package.json ./tooling/typescript/package.json

RUN npm ci --include-workspace-root

FROM node:24-alpine AS builder

WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .

ENV NEXT_TELEMETRY_DISABLED=1

RUN DATABASE_URL=postgresql://placeholder:placeholder@localhost:5432/placeholder \
  BETTER_AUTH_SECRET=ci-build-placeholder-secret-32-characters-long \
  BETTER_AUTH_URL=http://localhost:3000 \
  GOOGLE_CLIENT_ID=ci-placeholder \
  GOOGLE_CLIENT_SECRET=ci-placeholder \
  npm exec --workspace=@workspace/db prisma generate
RUN DATABASE_URL=postgresql://placeholder:placeholder@localhost:5432/placeholder \
  BETTER_AUTH_SECRET=ci-build-placeholder-secret-32-characters-long \
  BETTER_AUTH_URL=http://localhost:3000 \
  GOOGLE_CLIENT_ID=ci-placeholder \
  GOOGLE_CLIENT_SECRET=ci-placeholder \
  npm run build --workspace=web

FROM node:24-alpine AS runner

WORKDIR /app
ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1
ENV PORT=3000
ENV HOSTNAME=0.0.0.0

RUN addgroup --system --gid 1001 nodejs \
  && adduser --system --uid 1001 nextjs

COPY --from=builder --chown=nextjs:nodejs /app/apps/web/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/apps/web/.next/static ./apps/web/.next/static

USER nextjs
EXPOSE 3000

CMD ["node", "apps/web/server.js"]
