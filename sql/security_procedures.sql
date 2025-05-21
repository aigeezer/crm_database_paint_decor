/*
Security procedures for the CRM database for painting and decorating companies.
These procedures manage user authentication, authorization, and audit logging.
*/

-- Set DELIMITER for multi-statement procedures
DELIMITER //

-- Create a new user account
CREATE PROCEDURE sp_create_user(
    IN p_username VARCHAR(50),
    IN p_password_hash VARCHAR(255),
    IN p_full_name VARCHAR(100),
    IN p_email VARCHAR(100),
    IN p_role VARCHAR(50),
    IN p_admin_user_id INT,
    OUT p_user_id INT,
    OUT p_success BOOLEAN,
    OUT p_message VARCHAR(255)
)
BEGIN
    DECLARE v_username_exists INT;
    DECLARE v_email_exists INT;
    
    -- Check if username already exists
    SELECT COUNT(*) INTO v_username_exists FROM users WHERE username = p_username;
    
    -- Check if email already exists
    SELECT COUNT(*) INTO v_email_exists FROM users WHERE email = p_email;
    
    -- Validate inputs
    IF LENGTH(p_username) < 4 THEN
        SET p_success = FALSE;
        SET p_message = 'Username must be at least 4 characters long.';
    ELSEIF v_username_exists > 0 THEN
        SET p_success = FALSE;
        SET p_message = 'Username already exists.';
    ELSEIF v_email_exists > 0 THEN
        SET p_success = FALSE;
        SET p_message = 'Email address already exists.';
    ELSEIF p_role NOT IN ('admin', 'manager', 'estimator', 'painter', 'office_staff', 'readonly') THEN
        SET p_success = FALSE;
        SET p_message = 'Invalid role specified.';
    ELSE
        -- Insert the new user
        INSERT INTO users (
            username, password_hash, full_name, email, role, 
            is_active, created_at, created_by
        )
        VALUES (
            p_username, p_password_hash, p_full_name, p_email, p_role,
            TRUE, CURRENT_TIMESTAMP, p_admin_user_id
        );
        
        -- Log the action
        INSERT INTO security_log (
            user_id, action_type, action_description, ip_address, timestamp
        )
        VALUES (
            p_admin_user_id, 'user_create', CONCAT('Created user: ', p_username), 
            CONNECTION_ID(), CURRENT_TIMESTAMP
        );
        
        SET p_user_id = LAST_INSERT_ID();
        SET p_success = TRUE;
        SET p_message = 'User created successfully.';
    END IF;
END //

-- Update user account
CREATE PROCEDURE sp_update_user(
    IN p_user_id INT,
    IN p_full_name VARCHAR(100),
    IN p_email VARCHAR(100),
    IN p_role VARCHAR(50),
    IN p_is_active BOOLEAN,
    IN p_admin_user_id INT,
    OUT p_success BOOLEAN,
    OUT p_message VARCHAR(255)
)
BEGIN
    DECLARE v_user_exists INT;
    DECLARE v_email_exists INT;
    
    -- Check if user exists
    SELECT COUNT(*) INTO v_user_exists FROM users WHERE user_id = p_user_id;
    
    -- Check if email already exists for another user
    SELECT COUNT(*) INTO v_email_exists FROM users WHERE email = p_email AND user_id != p_user_id;
    
    -- Validate inputs
    IF v_user_exists = 0 THEN
        SET p_success = FALSE;
        SET p_message = 'User does not exist.';
    ELSEIF v_email_exists > 0 THEN
        SET p_success = FALSE;
        SET p_message = 'Email address already used by another user.';
    ELSEIF p_role NOT IN ('admin', 'manager', 'estimator', 'painter', 'office_staff', 'readonly') THEN
        SET p_success = FALSE;
        SET p_message = 'Invalid role specified.';
    ELSE
        -- Update the user
        UPDATE users
        SET
            full_name = p_full_name,
            email = p_email,
            role = p_role,
            is_active = p_is_active,
            updated_at = CURRENT_TIMESTAMP,
            updated_by = p_admin_user_id
        WHERE
            user_id = p_user_id;
            
        -- Log the action
        INSERT INTO security_log (
            user_id, action_type, action_description, ip_address, timestamp
        )
        VALUES (
            p_admin_user_id, 'user_update', CONCAT('Updated user ID: ', p_user_id), 
            CONNECTION_ID(), CURRENT_TIMESTAMP
        );
        
        SET p_success = TRUE;
        SET p_message = 'User updated successfully.';
    END IF;
END //

-- Change user password
CREATE PROCEDURE sp_change_password(
    IN p_user_id INT,
    IN p_current_password_hash VARCHAR(255),
    IN p_new_password_hash VARCHAR(255),
    IN p_admin_override BOOLEAN,
    IN p_admin_user_id INT,
    OUT p_success BOOLEAN,
    OUT p_message VARCHAR(255)
)
BEGIN
    DECLARE v_current_hash VARCHAR(255);
    DECLARE v_user_exists INT;
    
    -- Check if user exists
    SELECT COUNT(*) INTO v_user_exists FROM users WHERE user_id = p_user_id;
    
    IF v_user_exists = 0 THEN
        SET p_success = FALSE;
        SET p_message = 'User does not exist.';
    ELSE
        -- If not admin override, verify current password
        IF p_admin_override = FALSE THEN
            SELECT password_hash INTO v_current_hash FROM users WHERE user_id = p_user_id;
            
            IF v_current_hash != p_current_password_hash THEN
                SET p_success = FALSE;
                SET p_message = 'Current password is incorrect.';
                RETURN;
            END IF;
        END IF;
        
        -- Update the password
        UPDATE users
        SET
            password_hash = p_new_password_hash,
            password_changed_at = CURRENT_TIMESTAMP,
            updated_at = CURRENT_TIMESTAMP,
            updated_by = IF(p_admin_override, p_admin_user_id, p_user_id)
        WHERE
            user_id = p_user_id;
            
        -- Log the action
        INSERT INTO security_log (
            user_id, action_type, action_description, ip_address, timestamp
        )
        VALUES (
            IF(p_admin_override, p_admin_user_id, p_user_id), 
            'password_change', 
            IF(p_admin_override, 
               CONCAT('Admin reset password for user ID: ', p_user_id),
               'User changed own password'
            ), 
            CONNECTION_ID(), 
            CURRENT_TIMESTAMP
        );
        
        SET p_success = TRUE;
        SET p_message = 'Password changed successfully.';
    END IF;
END //

-- Log user login
CREATE PROCEDURE sp_log_login_attempt(
    IN p_username VARCHAR(50),
    IN p_ip_address VARCHAR(50),
    IN p_user_agent VARCHAR(255),
    IN p_success BOOLEAN,
    OUT p_user_id INT
)
BEGIN
    DECLARE v_user_id INT;
    
    -- Get user ID if username exists
    SELECT user_id INTO v_user_id FROM users WHERE username = p_username;
    
    -- Insert login attempt log
    INSERT INTO login_log (
        username, user_id, ip_address, user_agent, 
        success, timestamp
    )
    VALUES (
        p_username, v_user_id, p_ip_address, p_user_agent,
        p_success, CURRENT_TIMESTAMP
    );
    
    -- If successful login, update last login timestamp
    IF p_success = TRUE AND v_user_id IS NOT NULL THEN
        UPDATE users
        SET 
            last_login_at = CURRENT_TIMESTAMP,
            login_count = login_count + 1
        WHERE 
            user_id = v_user_id;
    END IF;
    
    SET p_user_id = v_user_id;
END //

-- Check user permissions
CREATE PROCEDURE sp_check_permission(
    IN p_user_id INT,
    IN p_permission_name VARCHAR(50),
    OUT p_has_permission BOOLEAN
)
BEGIN
    DECLARE v_role VARCHAR(50);
    DECLARE v_is_active BOOLEAN;
    
    -- Get user role and active status
    SELECT role, is_active INTO v_role, v_is_active 
    FROM users 
    WHERE user_id = p_user_id;
    
    -- Check if user is active
    IF v_is_active = FALSE THEN
        SET p_has_permission = FALSE;
        RETURN;
    END IF;
    
    -- Check permission based on role
    -- Admins have all permissions
    IF v_role = 'admin' THEN
        SET p_has_permission = TRUE;
    -- Check specific role-based permissions
    ELSEIF v_role = 'manager' THEN
        IF p_permission_name IN (
            'view_customers', 'edit_customers', 
            'view_projects', 'edit_projects', 
            'view_estimates', 'edit_estimates', 
            'view_invoices', 'edit_invoices',
            'view_schedule', 'edit_schedule',
            'view_team', 'edit_team',
            'view_reports'
        ) THEN
            SET p_has_permission = TRUE;
        ELSE
            SET p_has_permission = FALSE;
        END IF;
    ELSEIF v_role = 'estimator' THEN
        IF p_permission_name IN (
            'view_customers', 'edit_customers', 
            'view_projects', 'edit_projects', 
            'view_estimates', 'edit_estimates', 
            'view_invoices',
            'view_schedule',
            'view_materials', 'edit_materials'
        ) THEN
            SET p_has_permission = TRUE;
        ELSE
            SET p_has_permission = FALSE;
        END IF;
    ELSEIF v_role = 'painter' THEN
        IF p_permission_name IN (
            'view_projects',
            'view_schedule',
            'view_materials',
            'edit_tasks'
        ) THEN
            SET p_has_permission = TRUE;
        ELSE
            SET p_has_permission = FALSE;
        END IF;
    ELSEIF v_role = 'office_staff' THEN
        IF p_permission_name IN (
            'view_customers', 'edit_customers', 
            'view_projects',
            'view_estimates',
            'view_invoices', 'edit_invoices',
            'view_schedule',
            'view_reports'
        ) THEN
            SET p_has_permission = TRUE;
        ELSE
            SET p_has_permission = FALSE;
        END IF;
    ELSEIF v_role = 'readonly' THEN
        IF p_permission_name LIKE 'view_%' THEN
            SET p_has_permission = TRUE;
        ELSE
            SET p_has_permission = FALSE;
        END IF;
    ELSE
        SET p_has_permission = FALSE;
    END IF;
    
    -- Log permission check
    INSERT INTO security_log (
        user_id, action_type, action_description, ip_address, timestamp
    )
    VALUES (
        p_user_id, 'permission_check', 
        CONCAT('Checked permission: ', p_permission_name, ' - Result: ', IF(p_has_permission, 'Granted', 'Denied')), 
        CONNECTION_ID(), CURRENT_TIMESTAMP
    );
END //

-- Reset DELIMITER
DELIMITER ;
