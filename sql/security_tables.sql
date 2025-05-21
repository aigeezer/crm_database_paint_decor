/*
Security tables for the CRM database for painting and decorating companies.
These tables manage user authentication, authorization, and audit logging.
*/

-- Users table
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    role VARCHAR(50) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    last_login_at TIMESTAMP NULL,
    login_count INT DEFAULT 0,
    password_changed_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INT NULL,
    updated_at TIMESTAMP NULL,
    updated_by INT NULL,
    FOREIGN KEY (created_by) REFERENCES users(user_id),
    FOREIGN KEY (updated_by) REFERENCES users(user_id)
);

-- Security log table for tracking security-related actions
CREATE TABLE security_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    action_type VARCHAR(50) NOT NULL,
    action_description TEXT,
    ip_address VARCHAR(50),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Login log table for tracking login attempts
CREATE TABLE login_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    user_id INT NULL,
    ip_address VARCHAR(50),
    user_agent VARCHAR(255),
    success BOOLEAN DEFAULT FALSE,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Data access log for tracking sensitive data access
CREATE TABLE data_access_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    table_name VARCHAR(50) NOT NULL,
    record_id VARCHAR(36) NOT NULL,
    action_type ENUM('view', 'create', 'update', 'delete') NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Add bootstrap admin user (password: changeme)
-- In production, this would be replaced with a secure password
INSERT INTO users (
    username, password_hash, full_name, email, role, 
    is_active, password_changed_at, created_at
)
VALUES (
    'admin', 
    '$2y$10$K17xvEY5nNb0k9.ELv/1u.fZZbV4OMmgj8DoWfc1GsU6kz9CvKLjq', 
    'System Administrator', 
    'admin@company.com', 
    'admin', 
    TRUE,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

-- Create indexes for security tables
CREATE INDEX idx_security_log_user_id ON security_log(user_id);
CREATE INDEX idx_security_log_action_type ON security_log(action_type);
CREATE INDEX idx_security_log_timestamp ON security_log(timestamp);

CREATE INDEX idx_login_log_username ON login_log(username);
CREATE INDEX idx_login_log_user_id ON login_log(user_id);
CREATE INDEX idx_login_log_success ON login_log(success);
CREATE INDEX idx_login_log_timestamp ON login_log(timestamp);

CREATE INDEX idx_data_access_log_user_id ON data_access_log(user_id);
CREATE INDEX idx_data_access_log_table_record ON data_access_log(table_name, record_id);
CREATE INDEX idx_data_access_log_timestamp ON data_access_log(timestamp);
