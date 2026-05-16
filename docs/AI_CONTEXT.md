# AI Context

Status: Active

Use this file as the first briefing for AI agents working in this monorepo.

## Product

KnowChina is a cross-platform app for objective, fact-based daily briefings about China, with AI-powered knowledge deep-dives.

Primary audience: foreigners who need practical context about contemporary China, especially business people, founders, students, and China watchers.

## Repository Shape

| Path | Role |
|------|------|
| `mobile/` | Flutter app for iOS and Android |
| `server/` | Cloudflare Workers API, AI pipeline, and cron jobs |
| `website/` | Cloudflare Pages marketing site |
| `scripts/` | Cross-module utility scripts |
| `docs/` | Product, architecture, runbooks, and AI context |
| `ui/` | Design system, wireframes, prototypes, copy, and visual references |

## Working Principles

- Preserve objective, fact-based product tone.
- Avoid political opinion, sensational language, or unsupported claims.
- Prefer small, reviewable changes.
- Keep module boundaries clear: app UI in `mobile/`, backend logic in `server/`, marketing pages in `website/`.
- Update docs when changing cross-module behavior.
- Put reusable visual decisions in `ui/design-system/`.
- Put reusable prompt rules in `docs/prompts/`.

## Important Product Constraints

- No comment sections.
- No unrestricted user free-text questions in MVP.
- No breaking news push flow in MVP.
- Knowledge deep-dives must be based on reviewed factual skeletons.
- Sensitive content should fall back to reviewed static content.

## Common Entry Points

- Product scope: [../PRD.md](../PRD.md)
- Flutter app: [../mobile/README.md](../mobile/README.md)
- Server: [../server/README.md](../server/README.md)
- Root commands: [../README.md](../README.md)
- UI workspace: [../ui/README.md](../ui/README.md)

