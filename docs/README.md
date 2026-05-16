# KnowChina Docs

This directory is the source of truth for product, architecture, operations, and AI working context.

## How To Use This Directory

- Start with [AI_CONTEXT.md](./AI_CONTEXT.md) before asking an AI agent to make cross-module changes.
- Put stable product requirements in [product/](./product/).
- Put system design, data flow, and module ownership in [architecture/](./architecture/).
- Put accepted technical decisions in [decisions/](./decisions/).
- Put repeatable operating procedures in [runbooks/](./runbooks/).
- Put reusable AI prompts and generation rules in [prompts/](./prompts/).

## Directory Map

| Directory | Purpose |
|-----------|---------|
| `product/` | PRDs, user stories, launch scope, research notes |
| `architecture/` | System overview, API contracts, data models, module boundaries |
| `decisions/` | Architecture Decision Records (ADRs) |
| `runbooks/` | Release, deploy, incident, and maintenance procedures |
| `prompts/` | AI prompt templates, content generation rules, evaluation rubrics |
| `archive/` | Superseded docs kept for historical context |

## AI-Friendly Rules

- Prefer one topic per file.
- Use descriptive kebab-case filenames, for example `daily-briefing-pipeline.md`.
- Add a short `Status` line near the top: `Draft`, `Active`, `Deprecated`, or `Archived`.
- Link related source directories and files directly.
- When a document replaces another document, mark the old one as `Deprecated` and link to the replacement.
- Keep decisions in `decisions/`; keep living explanations in `architecture/`.

## Current External Docs

These files still live at the repository root for now:

- [PRD](../PRD.md)
- [Product Planning](../产品规划.md)
- [Flutter Dev Guide](../Flutter跨平台App全流程开发指南.md)

