-- Why: initialisation du schéma de base pour les services tickets-api et auth-gateway.
-- Impact: création des tables users et tickets, aucune donnée pré-existante.

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  email VARCHAR(255) UNIQUE NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE tickets (
  id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body TEXT,
  priority VARCHAR(20) DEFAULT 'medium',
  legacy_status VARCHAR(20),
  reporter_id INT REFERENCES users(id),
  created_at TIMESTAMP DEFAULT NOW()
);
