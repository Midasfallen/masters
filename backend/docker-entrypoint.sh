#!/bin/sh
set -e

echo "Waiting for database..."
until pg_isready -h $DB_HOST -p $DB_PORT -U $DB_USERNAME -d $DB_DATABASE; do
  sleep 1
done

echo "Running migrations..."
# Используем data-source из dist, так как в production нет исходников TypeScript
npm run migration:run || echo "Migrations skipped (already applied or no migrations)"

echo "Starting application..."
exec "$@"
