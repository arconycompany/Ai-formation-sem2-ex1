# pulse-mini-seed-ok · version SAINE (Exercice 1)

Mini-monorepo Node.js avec 3 services HelloIT Pulse. Code propre, prêt à
être étendu. Sert de **base de travail** pour l'Exercice 1 du Jour 4
(réécrire le `CLAUDE.md`) puis pour l'Exercice 2 (construire les hooks et
le sub-agent).

## Services

| Service | Stack | Port | Rôle |
|---|---|---|---|
| `services/auth-gateway` | Fastify + jsonwebtoken | 4000 | Auth JWT (login + verify) |
| `services/tickets-api` | Express | 4001 | CRUD tickets (in-memory) |
| `services/notifications-worker` | Express + worker timer | 4002 | Queue de notifs Slack (mock) |

Plage 4000-4002 choisie pour éviter le conflit classique avec Next.js dev (3000) et autres services qui squattent le 3000-3010.

## Démarrer

```bash
npm install
JWT_SECRET=dev-only-secret npm run dev   # lance les 3 services en parallèle
npm test                                 # tests de tous les workspaces
```

## Lien avec l'Exercice 2

Pour tester votre hook + sub-agent, copiez les fichiers fautifs du seed
voisin `pulse-mini-seed-bad/` par-dessus votre version saine, stagez,
tentez un commit. Voir le README de `pulse-mini-seed-bad/`.
