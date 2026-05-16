# KnowChina

> Understand China's daily briefing and knowledge tool.

A cross-platform mobile app that delivers objective, fact-based daily briefings about China, with AI-powered knowledge deep-dives.

---

## Repository Structure

| Directory | Description |
|-----------|-------------|
| `mobile/` | Flutter app (iOS + Android) |
| `server/` | Cloudflare Workers (API, AI pipeline, cron jobs) |
| `website/` | Cloudflare Pages (marketing website) |
| `marketing/` | Media assets, copywriting, video materials |
| `scripts/` | Cross-module utility scripts |
| `.github/workflows/` | CI/CD pipelines |

## Quick Start

```bash
# Install all dependencies
make install-all

# Run locally
make dev-mobile    # Flutter app
make dev-server    # Cloudflare Worker
make dev-website   # Website dev server

# Build
make build-mobile-ios
make build-mobile-android

# Deploy
make deploy-server
make deploy-website
make release-ios
make release-android
```

See all commands: `make help`

## Documentation

- [Product Planning](./产品规划.md)
- [PRD](./PRD.md)
- [Flutter Dev Guide](./Flutter跨平台App全流程开发指南.md)

## Tech Stack

- **Mobile:** Flutter 3.41.x, Riverpod, go_router
- **Backend:** Cloudflare Workers (Node.js)
- **Database:** Supabase (PostgreSQL)
- **Payment:** RevenueCat
- **CI/CD:** GitHub Actions + Fastlane
- **Deploy:** Cloudflare Workers + Pages

---

Co-Authored-By: HAPI <noreply@hapi.run>
