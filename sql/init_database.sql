/*
Database initialization script for the CRM database for painting and decorating companies.
This script orchestrates the complete database setup process.
*/

-- Enable strict SQL mode for better data integrity
SET SQL_MODE = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';

-- Create database if it doesn't exist
CREATE DATABASE IF NOT EXISTS paint_decor_crm CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Use the database
USE paint_decor_crm;

-- Drop all tables if they exist (for clean initialization)
-- Disable foreign key checks temporarily to avoid constraint errors during drops
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS communications;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS invoices;
DROP TABLE IF EXISTS schedule_assignments;
DROP TABLE IF EXISTS schedule_events;
DROP TABLE IF EXISTS tasks;
DROP TABLE IF EXISTS project_materials;
DROP TABLE IF EXISTS materials;
DROP TABLE IF EXISTS project_team_assignments;
DROP TABLE IF EXISTS team_members;
DROP TABLE IF EXISTS estimate_line_items;
DROP TABLE IF EXISTS services;
DROP TABLE IF EXISTS estimates;
DROP TABLE IF EXISTS projects;
DROP TABLE IF EXISTS properties;
DROP TABLE IF EXISTS customers;

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;

-- Execute table creation script
SOURCE /path/to/sql/create_tables.sql;

-- Create views
SOURCE /path/to/sql/create_views.sql;

-- Create stored procedures
SOURCE /path/to/sql/create_procedures.sql;

-- Create triggers
SOURCE /path/to/sql/create_triggers.sql;

-- Create additional indexes
SOURCE /path/to/sql/create_indexes.sql;

-- Load sample data (optional - remove this line for production deployment)
-- SOURCE /path/to/sql/sample_data.sql;

-- Verify database creation
SELECT 'Database initialization completed successfully' AS Status;
SELECT table_name AS 'Tables Created' FROM information_schema.tables WHERE table_schema = 'paint_decor_crm';
