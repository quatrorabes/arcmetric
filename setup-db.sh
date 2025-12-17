#!/bin/bash
# Setup PostgreSQL database

echo "📦 Setting up PostgreSQL database..."

# Create database and user
psql -U postgres << EOSQL
CREATE DATABASE arcmetric;
CREATE USER arcmetric_user WITH PASSWORD 'password123';
ALTER ROLE arcmetric_user SET client_encoding TO 'utf8';
ALTER ROLE arcmetric_user SET default_transaction_isolation TO 'read committed';
ALTER ROLE arcmetric_user SET default_transaction_deferrable TO on;
ALTER ROLE arcmetric_user SET timezone TO 'UTC';
GRANT ALL PRIVILEGES ON DATABASE arcmetric TO arcmetric_user;
EOSQL

echo "✅ Database created!"
