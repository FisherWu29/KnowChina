# server/ — Cloudflare Workers (KnowChina Backend)

## Setup

```bash
npm install
```

## Development

```bash
npm run dev
# or from repo root:
make dev-server
```

## Deployment

```bash
npm run deploy
# or from repo root:
make deploy-server
```

## Secrets

Set secrets via wrangler CLI:

```bash
wrangler secret put SUPABASE_URL
wrangler secret put SUPABASE_ANON_KEY
wrangler secret put OPENAI_API_KEY
```
