#!/bin/bash
set -e

# Change authentication method from scram-sha-256 to md5
echo "Configuring PostgreSQL authentication..."
sed -i 's/host all all all scram-sha-256/host all all all md5/' /var/lib/postgresql/data/pg_hba.conf

# Reload PostgreSQL configuration
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    SELECT pg_reload_conf();
EOSQL

echo "PostgreSQL authentication configured successfully"
