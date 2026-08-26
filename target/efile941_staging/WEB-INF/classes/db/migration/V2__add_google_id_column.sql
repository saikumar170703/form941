-- Migration Script for Existing Production Databases
-- Adds google_id column if it doesn't already exist in the users table

ALTER TABLE users ADD COLUMN IF NOT EXISTS google_id VARCHAR(255) UNIQUE;
