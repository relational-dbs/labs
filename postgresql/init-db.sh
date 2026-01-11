#!/bin/bash
set -e

# This script runs ONLY on the first container startup
echo "Initializing databases..."

for db in $(echo $DBS_LIST | tr ',' ' '); do
    echo "Creating database: $db"
    psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
      CREATE DATABASE "$db";
      GRANT ALL PRIVILEGES ON DATABASE "$db" TO "$POSTGRES_USER";
      GRANT ALL ON DATABASE "$db" TO "$POSTGRES_USER";
EOSQL
done

touch /tmp/dbs_initialized
