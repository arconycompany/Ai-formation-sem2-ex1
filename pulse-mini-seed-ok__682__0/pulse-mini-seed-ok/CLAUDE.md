# Pulse Mini Seed

Mini-monorepo Node.js simulant une partie du système HelloIT Pulse.
3 microservices indépendants : `auth-gateway`, `tickets-api`, `notifications-worker`.

## Commandes

```bash
npm install          # installer toutes les dépendances (workspaces)
npm run dev          # lancer les 3 services en parallèle
npm run dev:auth     # auth-gateway uniquement (port 4000)
npm run dev:tickets  # tickets-api uniquement (port 4001)
npm run dev:notif    # notifications-worker uniquement (port 4002)
npm test             # tous les tests
node --test services/auth-gateway/tests/jwt.test.js  # test unitaire ciblé
```

## Stack

- Node.js v20 LTS, ES modules (`type: module` dans chaque `package.json`)
- `auth-gateway` : Fastify v4 + jsonwebtoken
- `tickets-api` : Express v4, store en mémoire (pas de DB pour l'instant)
- `notifications-worker` : Express v4 + setInterval pour le worker
- `concurrently` en devDependency racine pour lancer tous les services

## Conventions de code

- ES modules uniquement — toujours inclure l'extension `.js` dans les imports.
- Indentation 2 espaces.
- Simple quotes en JS, double quotes en JSON.
- `async/await` obligatoire, pas de `.then()`.
- Tout nouveau fichier dans `services/<nom>/src/`, test dans `services/<nom>/tests/`.
- Les messages de commit sont en français.

## Migrations

- Dossier `migrations/`, convention Flyway : `VNNN__description.sql`.
- On n'efface jamais une migration existante, on en ajoute une nouvelle.
- Toute migration touchant la prod doit être relue avant merge.

## Règles métier

- `tickets-api` n'a pas encore de base de données — ne pas brancher PostgreSQL sans en discuter en équipe.
- Les secrets ne vont jamais dans le code — utiliser les variables d'environnement.
- Ne pas modifier les ports par défaut (4000, 4001, 4002) sans mettre à jour tous les services qui s'appellent entre eux.
