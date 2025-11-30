#!/bin/bash
set -e

# Start PostgreSQL in background
docker-entrypoint.sh postgres &

# Wait until PostgreSQL is ready
echo "Waiting for PostgreSQL to start..."
until pg_isready -h localhost -p 5432; do
    sleep 1
done

echo "PostgreSQL started. Running Python loader..."
# Run Python loader in virtual environment
/opt/venv/bin/python3 /docker-entrypoint-initdb.d/init_db.py

# Keep the container running with PostgreSQL
fg %1
