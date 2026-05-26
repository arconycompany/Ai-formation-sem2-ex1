# Pulse Mini Seed — CLAUDE.md

## Project Overview

Mini-monorepo simulating part of the HelloIT Pulse system. 3 microservices:

- **auth-gateway** — JWT authentication (port 4000)
- **tickets-api** — ticket CRUD, in-memory store (port 4001)
- **notifications-worker** — Slack notification queue (port 4002)

Team: 6 devs, 1 tech lead (Marc), PM (Sophie). 2-week sprints.

## Stack & Environment

- Node.js v20 LTS, ES modules (`type: module` in every package.json)
- auth-gateway: Fastify v4 + jsonwebtoken
- tickets-api: Express v4, in-memory Map (no DB yet)
- notifications-worker: Express v4 + setInterval worker
- Root: npm workspaces + concurrently

## API Endpoints

### auth-gateway (port 4000)
- `POST /auth/login` — `{ username, password }` → `{ token }`
- `GET /auth/verify` — `Authorization: Bearer <token>` → `{ ok, payload }`

### tickets-api (port 4001)
- `POST /v1/tickets` — `{ title, body, priority, reporter }` → ticket with `id`, `createdAt`
- `GET /v1/tickets/:id` — ticket or 404
- `GET /v1/tickets` — array of all tickets

### notifications-worker (port 4002)
- `POST /v1/notifications` — `{ channel, message, recipient }` → `{ queued: true }`

## How to Run

```bash
npm install          # install all workspaces
npm run dev          # all services in parallel
npm run dev:auth     # auth-gateway only
npm run dev:tickets  # tickets-api only
npm run dev:notif    # notifications-worker only
npm test             # all tests
node --test path/to/file.test.js  # single test file
```

## Conventions

**TOUJOURS**
- ES modules — `.js` extension on all imports
- 2-space indentation
- Single quotes in JS, double quotes in JSON
- Arrow functions for callbacks
- `async/await` — JAMAIS `.then()` chains
- Write tests for new features
- Commit messages in French
- PR descriptions required
- Code review within 24h when possible

**JAMAIS**
- Ne jamais push une migration en prod sans review (cf. V003)
- Ne jamais stocker de secrets dans le code — utiliser le vault

## Migrations

Stored in `migrations/`, Flyway naming: `VNNN__description.sql`.

- `V001__init_schema.sql` — users + tickets tables
- `V002__add_priority_column.sql` — priority index
- `V003__drop_legacy_status.sql` — removes `legacy_status` column

## Definition of Done

A feature is done when:
- [ ] Code reviewed by at least 1 teammate
- [ ] Tests written and passing (`npm test`)
- [ ] No `console.log` left in prod paths
- [ ] PR description filled
- [ ] Migration (if any) reviewed before merge to main

---

*Backlog → `backlog/NOTES_PROJECT_MANAGER.md` | Personal prefs → `.claude/CLAUDE.md` (gitignored)*
