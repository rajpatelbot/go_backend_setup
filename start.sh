#!/bin/bash

echo "📌 Loading environment variables..."
set -a
. /app/.env
set +a

echo "⏳ Waiting for PostgreSQL to be ready..."
until pg_isready -h "$HOST" -p "$DB_PORT" -U "$USER"; do
  echo "Postgres not ready yet..."
  sleep 2
done

echo "✔ PostgreSQL is ready!"

echo "🔄 Running Atlas migrations..."
atlas migrate apply --env gorm

echo "🚀 Starting Go server on port $PORT..."
exec ./main
