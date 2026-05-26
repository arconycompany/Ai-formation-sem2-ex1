-- Why: la requête GET /v1/tickets?priority=X passait de 800ms à 12ms
--      après ajout de cet index. Mesuré sur 50k tickets en preprod.
-- Impact: build d'index CONCURRENTLY, pas de lock sur la table.

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_tickets_priority
  ON tickets(priority);
