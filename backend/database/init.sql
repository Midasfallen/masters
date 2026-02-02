-- Enable PostGIS extension for geolocation features
CREATE EXTENSION IF NOT EXISTS postgis;

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create database if not exists (this runs only on first init)
-- The database is already created by POSTGRES_DB env variable

-- You can add initial seed data here if needed
-- For example, default categories, etc.

-- Success message
SELECT 'Database initialized successfully' as message;
