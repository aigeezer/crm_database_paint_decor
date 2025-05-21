#!/bin/bash
# Database deployment and verification script for the Painting and Decorating CRM system

# Configuration
DB_NAME="paint_decor_crm"
DB_USER="admin"
DB_PASSWORD="secure_password"  # Should be moved to environment variable in production
DB_HOST="localhost"
SQL_DIR="./sql"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print error and exit
error_exit() {
    echo -e "${RED}ERROR: $1${NC}" >&2
    exit 1
}

# Function to print success message
success() {
    echo -e "${GREEN}$1${NC}"
}

# Function to print warning message
warning() {
    echo -e "${YELLOW}$1${NC}"
}

# Check if MySQL client is installed
if ! command -v mysql &> /dev/null; then
    error_exit "MySQL client not found. Please install MySQL client."
fi

# Check if SQL directory exists
if [ ! -d "$SQL_DIR" ]; then
    error_exit "SQL directory not found at $SQL_DIR"
fi

# Validate required SQL files exist
REQUIRED_FILES=("create_tables.sql" "create_views.sql" "create_procedures.sql" "create_triggers.sql" "create_indexes.sql")
for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$SQL_DIR/$file" ]; then
        error_exit "Required SQL file $file not found in $SQL_DIR"
    fi
done

echo "=== Paint & Decor CRM Database Deployment ==="

# Prompt for confirmation before proceeding
read -p "This will initialize/reset the database $DB_NAME. Are you sure you want to continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Deployment cancelled."
    exit 0
fi

# Create database initialization file with corrected paths
cat > "$SQL_DIR/temp_init.sql" << EOF
-- Enable strict SQL mode for better data integrity
SET SQL_MODE = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';

-- Create database if it doesn't exist
CREATE DATABASE IF NOT EXISTS $DB_NAME CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Use the database
USE $DB_NAME;

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
SOURCE $SQL_DIR/create_tables.sql;

-- Create views
SOURCE $SQL_DIR/create_views.sql;

-- Create stored procedures
SOURCE $SQL_DIR/create_procedures.sql;

-- Create triggers
SOURCE $SQL_DIR/create_triggers.sql;

-- Create additional indexes
SOURCE $SQL_DIR/create_indexes.sql;

-- Load sample data (optional - uncomment for testing environments)
-- SOURCE $SQL_DIR/sample_data.sql;

-- Verify database creation
SELECT 'Database initialization completed successfully' AS Status;
SELECT table_name AS 'Tables Created' FROM information_schema.tables WHERE table_schema = '$DB_NAME' AND table_type = 'BASE TABLE';
EOF

# Execute the database initialization script
echo "Initializing database..."
mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD < "$SQL_DIR/temp_init.sql"

if [ $? -eq 0 ]; then
    success "Database initialized successfully!"
else
    error_exit "Database initialization failed."
fi

# Cleanup temporary file
rm "$SQL_DIR/temp_init.sql"

# Perform validation tests
echo "Running validation tests..."

# Test database connection
echo "Testing database connection..."
if mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD -e "USE $DB_NAME; SELECT 1;" &> /dev/null; then
    success "Database connection successful."
else
    error_exit "Database connection failed."
fi

# Test tables exist
echo "Verifying tables..."
TABLE_COUNT=$(mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD -N -e "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='$DB_NAME' AND table_type='BASE TABLE';" 2>/dev/null)

if [ "$TABLE_COUNT" -ge 15 ]; then
    success "Table verification passed: Found $TABLE_COUNT tables."
else
    error_exit "Table verification failed: Expected at least 15 tables, found $TABLE_COUNT."
fi

# Test views exist
echo "Verifying views..."
VIEW_COUNT=$(mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD -N -e "SELECT COUNT(*) FROM information_schema.views WHERE table_schema='$DB_NAME';" 2>/dev/null)

if [ "$VIEW_COUNT" -ge 8 ]; then
    success "View verification passed: Found $VIEW_COUNT views."
else
    error_exit "View verification failed: Expected at least 8 views, found $VIEW_COUNT."
fi

# Test triggers exist
echo "Verifying triggers..."
TRIGGER_COUNT=$(mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD -N -e "SELECT COUNT(*) FROM information_schema.triggers WHERE trigger_schema='$DB_NAME';" 2>/dev/null)

if [ "$TRIGGER_COUNT" -ge 10 ]; then
    success "Trigger verification passed: Found $TRIGGER_COUNT triggers."
else
    error_exit "Trigger verification failed: Expected at least 10 triggers, found $TRIGGER_COUNT."
fi

# Test procedures exist
echo "Verifying stored procedures..."
PROC_COUNT=$(mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD -N -e "SELECT COUNT(*) FROM information_schema.routines WHERE routine_schema='$DB_NAME' AND routine_type='PROCEDURE';" 2>/dev/null)

if [ "$PROC_COUNT" -ge 5 ]; then
    success "Stored procedure verification passed: Found $PROC_COUNT procedures."
else
    error_exit "Stored procedure verification failed: Expected at least 5 procedures, found $PROC_COUNT."
fi

# Ask if user wants to load sample data
read -p "Do you want to load sample data? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if [ -f "$SQL_DIR/sample_data.sql" ]; then
        echo "Loading sample data..."
        mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD $DB_NAME < "$SQL_DIR/sample_data.sql"
        if [ $? -eq 0 ]; then
            success "Sample data loaded successfully!"
        else
            warning "Failed to load sample data."
        fi
    else
        warning "Sample data file not found at $SQL_DIR/sample_data.sql"
    fi
fi

echo
success "Deployment and verification completed."
echo "The Paint & Decor CRM database is now ready for use."
