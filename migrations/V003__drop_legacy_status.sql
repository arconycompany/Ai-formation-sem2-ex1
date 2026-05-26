-- Why: la colonne legacy_status n'est plus lue depuis la migration de
--      l'application mobile en v3.4 (sprint 2025-12). Confirmation BI :
--      aucun export ne s'en sert depuis 9 mois.
-- Impact: destructif. Backup logique de la colonne réalisé avant exécution
--         (dump dans pulse_backups/legacy_status_2026.csv, conservé 12 mois).

ALTER TABLE tickets DROP COLUMN legacy_status;
