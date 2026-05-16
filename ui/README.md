# KnowChina UI Workspace

This directory is the source of truth for product design, visual language, UI copy, wireframes, prototypes, and design references.

## Directory Map

| Directory | Purpose |
|-----------|---------|
| `design-system/` | Tokens, typography, colors, spacing, components, icon rules |
| `wireframes/` | Low-fidelity flows and screen structure |
| `prototypes/` | Interactive or high-fidelity prototypes and exported previews |
| `assets/` | Product screenshots, generated images, icons, and source visual assets |
| `copy/` | UI strings, paywall copy, onboarding copy, notification copy |
| `references/` | Inspiration, competitor notes, screenshots, and annotated examples |

## AI-Friendly Rules

- Put every visual decision in text as well as images.
- Use stable filenames in kebab-case, for example `daily-briefing-screen.md`.
- For every screen spec, include purpose, user state, content states, empty states, loading states, and error states.
- Link implementation targets in `../mobile/`, `../website/`, or `../server/` when relevant.
- Do not store secrets, signing assets, or private credentials here.

## Screen Spec Template

```md
# Screen Name

Status: Draft | Active | Deprecated
Target: mobile | website | shared
Owner: product | design | engineering

## Purpose

What user job does this screen serve?

## States

- Loading:
- Empty:
- Error:
- Free user:
- Pro user:

## Content

What data, strings, or media does the screen need?

## Interaction

What can users tap, scroll, edit, buy, or dismiss?

## Implementation Links

- Code:
- Related docs:
```

