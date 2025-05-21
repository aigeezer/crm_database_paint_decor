/*
Stored Procedures for the CRM database for painting and decorating companies.
These procedures encapsulate common business logic and data operations.
*/

-- Create a new customer with optional property
DELIMITER //
CREATE PROCEDURE sp_create_customer(
    IN p_customer_type VARCHAR(20),
    IN p_first_name VARCHAR(50),
    IN p_last_name VARCHAR(50),
    IN p_company_name VARCHAR(100),
    IN p_email VARCHAR(100),
    IN p_phone VARCHAR(20),
    IN p_address_line1 VARCHAR(100),
    IN p_address_line2 VARCHAR(100),
    IN p_city VARCHAR(50),
    IN p_state VARCHAR(50),
    IN p_zip_code VARCHAR(20),
    IN p_country VARCHAR(50),
    IN p_lead_source VARCHAR(50),
    IN p_referral_source VARCHAR(100),
    IN p_notes TEXT,
    IN p_with_property BOOLEAN,
    IN p_property_name VARCHAR(100),
    IN p_property_type VARCHAR(50),
    IN p_property_address_line1 VARCHAR(100),
    IN p_property_address_line2 VARCHAR(100),
    IN p_property_city VARCHAR(50),
    IN p_property_state VARCHAR(50),
    IN p_property_zip_code VARCHAR(20),
    IN p_property_country VARCHAR(50),
    OUT p_customer_id VARCHAR(36),
    OUT p_property_id VARCHAR(36)
)
BEGIN
    DECLARE new_customer_id VARCHAR(36);
    DECLARE new_property_id VARCHAR(36);
    
    -- Generate a UUID for the customer
    SET new_customer_id = UUID();
    
    -- Insert the customer record
    INSERT INTO customers (
        customer_id, customer_type, first_name, last_name, company_name,
        email, phone, address_line1, address_line2, city, state, zip_code,
        country, lead_source, referral_source, notes
    ) VALUES (
        new_customer_id, p_customer_type, p_first_name, p_last_name, p_company_name,
        p_email, p_phone, p_address_line1, p_address_line2, p_city, p_state, p_zip_code,
        IFNULL(p_country, 'USA'), p_lead_source, p_referral_source, p_notes
    );
    
    -- If a property is requested
    IF p_with_property = TRUE THEN
        -- Generate a UUID for the property
        SET new_property_id = UUID();
        
        -- Insert the property record
        INSERT INTO properties (
            property_id, customer_id, property_name, property_type,
            address_line1, address_line2, city, state, zip_code, country
        ) VALUES (
            new_property_id, new_customer_id, p_property_name, p_property_type,
            p_property_address_line1, p_property_address_line2, p_property_city, 
            p_property_state, p_property_zip_code, IFNULL(p_property_country, 'USA')
        );
    END IF;
    
    -- Set the output variables
    SET p_customer_id = new_customer_id;
    SET p_property_id = new_property_id;
END //
DELIMITER ;

-- Create a new project with estimate
DELIMITER //
CREATE PROCEDURE sp_create_project_with_estimate(
    IN p_customer_id VARCHAR(36),
    IN p_property_id VARCHAR(36),
    IN p_project_name VARCHAR(100),
    IN p_project_type VARCHAR(50),
    IN p_description TEXT,
    IN p_start_date DATE,
    IN p_end_date DATE,
    IN p_estimated_hours DECIMAL(10,2),
    IN p_estimate_date DATE,
    IN p_valid_until DATE,
    IN p_subtotal DECIMAL(10,2),
    IN p_tax_rate DECIMAL(5,2),
    IN p_discount_percentage DECIMAL(5,2),
    OUT p_project_id VARCHAR(36),
    OUT p_estimate_id VARCHAR(36),
    OUT p_estimate_number VARCHAR(20)
)
BEGIN
    DECLARE new_project_id VARCHAR(36);
    DECLARE new_estimate_id VARCHAR(36);
    DECLARE new_estimate_number VARCHAR(20);
    DECLARE tax_amount DECIMAL(10,2);
    DECLARE discount_amount DECIMAL(10,2);
    DECLARE total_amount DECIMAL(10,2);
    
    -- Calculate financial values
    SET tax_amount = p_subtotal * (p_tax_rate / 100);
    SET discount_amount = p_subtotal * (p_discount_percentage / 100);
    SET total_amount = p_subtotal + tax_amount - discount_amount;
    
    -- Generate estimate number (Year-Month-SequentialNumber)
    SET new_estimate_number = CONCAT(
        YEAR(CURRENT_DATE), '-',
        LPAD(MONTH(CURRENT_DATE), 2, '0'), '-',
        LPAD((SELECT COALESCE(MAX(SUBSTRING_INDEX(estimate_number, '-', -1) + 0), 0) + 1 
              FROM estimates 
              WHERE YEAR(estimate_date) = YEAR(CURRENT_DATE) 
              AND MONTH(estimate_date) = MONTH(CURRENT_DATE)), 4, '0')
    );
    
    -- Generate UUIDs
    SET new_project_id = UUID();
    SET new_estimate_id = UUID();
    
    -- Start transaction
    START TRANSACTION;
    
    -- Insert project
    INSERT INTO projects (
        project_id, customer_id, property_id, project_name, project_type,
        status, description, start_date, end_date, estimated_hours
    ) VALUES (
        new_project_id, p_customer_id, p_property_id, p_project_name, p_project_type,
        'lead', p_description, p_start_date, p_end_date, p_estimated_hours
    );
    
    -- Insert estimate
    INSERT INTO estimates (
        estimate_id, project_id, estimate_number, estimate_date, valid_until,
        status, subtotal, tax_rate, tax_amount, discount_percentage, 
        discount_amount, total
    ) VALUES (
        new_estimate_id, new_project_id, new_estimate_number, p_estimate_date, p_valid_until,
        'draft', p_subtotal, p_tax_rate, tax_amount, p_discount_percentage,
        discount_amount, total_amount
    );
    
    -- Commit the transaction
    COMMIT;
    
    -- Set output variables
    SET p_project_id = new_project_id;
    SET p_estimate_id = new_estimate_id;
    SET p_estimate_number = new_estimate_number;
END //
DELIMITER ;

-- Update project status with validation
DELIMITER //
CREATE PROCEDURE sp_update_project_status(
    IN p_project_id VARCHAR(36),
    IN p_new_status VARCHAR(20),
    OUT p_success BOOLEAN,
    OUT p_message VARCHAR(255)
)
BEGIN
    DECLARE current_status VARCHAR(20);
    DECLARE has_approved_estimate BOOLEAN;
    
    -- Get the current project status
    SELECT status INTO current_status
    FROM projects
    WHERE project_id = p_project_id;
    
    -- Check if the project has an approved estimate when moving to in-progress
    IF p_new_status = 'in-progress' THEN
        SELECT EXISTS(
            SELECT 1 FROM estimates 
            WHERE project_id = p_project_id 
            AND status = 'approved'
        ) INTO has_approved_estimate;
        
        IF has_approved_estimate = FALSE THEN
            SET p_success = FALSE;
            SET p_message = 'Cannot move project to in-progress without an approved estimate.';
            RETURN;
        END IF;
    END IF;
    
    -- Validate status transitions
    CASE 
        -- From lead
        WHEN current_status = 'lead' AND p_new_status IN ('quoted', 'cancelled') THEN
            UPDATE projects SET status = p_new_status, updated_at = CURRENT_TIMESTAMP WHERE project_id = p_project_id;
            SET p_success = TRUE;
            SET p_message = 'Project status updated successfully.';
            
        -- From quoted
        WHEN current_status = 'quoted' AND p_new_status IN ('lead', 'scheduled', 'cancelled') THEN
            UPDATE projects SET status = p_new_status, updated_at = CURRENT_TIMESTAMP WHERE project_id = p_project_id;
            SET p_success = TRUE;
            SET p_message = 'Project status updated successfully.';
            
        -- From scheduled
        WHEN current_status = 'scheduled' AND p_new_status IN ('quoted', 'in-progress', 'cancelled') THEN
            UPDATE projects SET status = p_new_status, updated_at = CURRENT_TIMESTAMP WHERE project_id = p_project_id;
            SET p_success = TRUE;
            SET p_message = 'Project status updated successfully.';
            
        -- From in-progress
        WHEN current_status = 'in-progress' AND p_new_status IN ('scheduled', 'completed', 'on-hold') THEN
            UPDATE projects SET status = p_new_status, updated_at = CURRENT_TIMESTAMP WHERE project_id = p_project_id;
            SET p_success = TRUE;
            SET p_message = 'Project status updated successfully.';
            
        -- From on-hold
        WHEN current_status = 'on-hold' AND p_new_status IN ('in-progress', 'cancelled') THEN
            UPDATE projects SET status = p_new_status, updated_at = CURRENT_TIMESTAMP WHERE project_id = p_project_id;
            SET p_success = TRUE;
            SET p_message = 'Project status updated successfully.';
            
        -- From completed
        WHEN current_status = 'completed' AND p_new_status IN ('in-progress', 'archived') THEN
            UPDATE projects SET status = p_new_status, updated_at = CURRENT_TIMESTAMP WHERE project_id = p_project_id;
            SET p_success = TRUE;
            SET p_message = 'Project status updated successfully.';
            
        -- Invalid transition
        ELSE
            SET p_success = FALSE;
            SET p_message = CONCAT('Invalid status transition from ', current_status, ' to ', p_new_status);
    END CASE;
END //
DELIMITER ;

-- Generate invoice from project
DELIMITER //
CREATE PROCEDURE sp_generate_invoice(
    IN p_project_id VARCHAR(36),
    IN p_invoice_date DATE,
    IN p_due_date DATE,
    IN p_include_materials BOOLEAN,
    IN p_notes TEXT,
    IN p_terms TEXT,
    OUT p_invoice_id VARCHAR(36),
    OUT p_invoice_number VARCHAR(20),
    OUT p_total DECIMAL(10,2)
)
BEGIN
    DECLARE new_invoice_id VARCHAR(36);
    DECLARE new_invoice_number VARCHAR(20);
    DECLARE v_customer_id VARCHAR(36);
    DECLARE v_estimate_subtotal DECIMAL(10,2);
    DECLARE v_estimate_tax_rate DECIMAL(5,2);
    DECLARE v_estimate_tax_amount DECIMAL(10,2);
    DECLARE v_estimate_discount_percentage DECIMAL(5,2);
    DECLARE v_estimate_discount_amount DECIMAL(10,2);
    DECLARE v_material_cost DECIMAL(10,2) DEFAULT 0;
    DECLARE v_subtotal DECIMAL(10,2);
    DECLARE v_tax_amount DECIMAL(10,2);
    DECLARE v_discount_amount DECIMAL(10,2);
    DECLARE v_total DECIMAL(10,2);
    
    -- Generate invoice number (Year-Month-SequentialNumber)
    SET new_invoice_number = CONCAT(
        YEAR(p_invoice_date), '-',
        LPAD(MONTH(p_invoice_date), 2, '0'), '-',
        LPAD((SELECT COALESCE(MAX(SUBSTRING_INDEX(invoice_number, '-', -1) + 0), 0) + 1 
              FROM invoices 
              WHERE YEAR(invoice_date) = YEAR(p_invoice_date) 
              AND MONTH(invoice_date) = MONTH(p_invoice_date)), 4, '0')
    );
    
    -- Get customer ID and latest approved estimate info
    SELECT 
        p.customer_id, 
        e.subtotal, 
        e.tax_rate, 
        e.tax_amount, 
        e.discount_percentage, 
        e.discount_amount
    INTO 
        v_customer_id, 
        v_estimate_subtotal, 
        v_estimate_tax_rate, 
        v_estimate_tax_amount, 
        v_estimate_discount_percentage, 
        v_estimate_discount_amount
    FROM projects p
    LEFT JOIN estimates e ON p.project_id = e.project_id AND e.status = 'approved'
    WHERE p.project_id = p_project_id
    ORDER BY e.estimate_date DESC
    LIMIT 1;
    
    -- Get material costs if requested
    IF p_include_materials = TRUE THEN
        SELECT COALESCE(SUM(total_cost), 0)
        INTO v_material_cost
        FROM project_materials
        WHERE project_id = p_project_id;
    END IF;
    
    -- Calculate invoice amounts
    SET v_subtotal = v_estimate_subtotal + v_material_cost;
    SET v_tax_amount = v_subtotal * (v_estimate_tax_rate / 100);
    SET v_discount_amount = v_subtotal * (v_estimate_discount_percentage / 100);
    SET v_total = v_subtotal + v_tax_amount - v_discount_amount;
    
    -- Generate UUID for invoice
    SET new_invoice_id = UUID();
    
    -- Create the invoice
    INSERT INTO invoices (
        invoice_id, project_id, customer_id, invoice_number, invoice_date, due_date,
        status, subtotal, tax_rate, tax_amount, discount_percentage, discount_amount,
        total, amount_paid, balance, notes, terms
    ) VALUES (
        new_invoice_id, p_project_id, v_customer_id, new_invoice_number, p_invoice_date, p_due_date,
        'draft', v_subtotal, v_estimate_tax_rate, v_tax_amount, v_estimate_discount_percentage, v_discount_amount,
        v_total, 0, v_total, p_notes, p_terms
    );
    
    -- Set output variables
    SET p_invoice_id = new_invoice_id;
    SET p_invoice_number = new_invoice_number;
    SET p_total = v_total;
END //
DELIMITER ;

-- Schedule a project and create events
DELIMITER //
CREATE PROCEDURE sp_schedule_project(
    IN p_project_id VARCHAR(36),
    IN p_start_date DATE,
    IN p_end_date DATE,
    IN p_create_events BOOLEAN,
    IN p_team_member_ids TEXT,
    OUT p_success BOOLEAN,
    OUT p_message VARCHAR(255)
)
BEGIN
    DECLARE v_current_status VARCHAR(20);
    DECLARE v_team_member_id VARCHAR(36);
    DECLARE v_event_id VARCHAR(36);
    DECLARE v_team_members_done BOOLEAN DEFAULT FALSE;
    DECLARE v_team_members CURSOR FOR 
        SELECT value FROM STRING_SPLIT(p_team_member_ids, ',') WHERE TRIM(value) <> '';
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_team_members_done = TRUE;
    
    -- Check if project exists and get status
    SELECT status INTO v_current_status
    FROM projects
    WHERE project_id = p_project_id;
    
    IF v_current_status IS NULL THEN
        SET p_success = FALSE;
        SET p_message = 'Project not found.';
        RETURN;
    END IF;
    
    -- Update project dates and status
    UPDATE projects
    SET start_date = p_start_date,
        end_date = p_end_date,
        status = 'scheduled',
        updated_at = CURRENT_TIMESTAMP
    WHERE project_id = p_project_id;
    
    -- If events creation is requested
    IF p_create_events = TRUE THEN
        -- Create main project event
        SET v_event_id = UUID();
        
        INSERT INTO schedule_events (
            event_id, project_id, event_type, title,
            description, start_datetime, end_datetime,
            all_day, location
        ) VALUES (
            v_event_id, p_project_id, 'project', 
            (SELECT CONCAT('Project: ', project_name) FROM projects WHERE project_id = p_project_id),
            (SELECT description FROM projects WHERE project_id = p_project_id),
            CONCAT(p_start_date, ' 08:00:00'),
            CONCAT(p_end_date, ' 17:00:00'),
            FALSE,
            (SELECT CONCAT(address_line1, ', ', city, ', ', state) 
             FROM properties pr JOIN projects p ON pr.property_id = p.property_id 
             WHERE p.project_id = p_project_id)
        );
        
        -- Assign team members to the event
        OPEN v_team_members;
        
        team_member_loop: LOOP
            FETCH v_team_members INTO v_team_member_id;
            IF v_team_members_done THEN
                LEAVE team_member_loop;
            END IF;
            
            -- Add team member to project
            INSERT INTO project_team_assignments (
                assignment_id, project_id, team_member_id, start_date, end_date
            ) VALUES (
                UUID(), p_project_id, v_team_member_id, p_start_date, p_end_date
            );
            
            -- Assign team member to event
            INSERT INTO schedule_assignments (
                assignment_id, event_id, team_member_id, status
            ) VALUES (
                UUID(), v_event_id, v_team_member_id, 'scheduled'
            );
        END LOOP;
        
        CLOSE v_team_members;
    END IF;
    
    SET p_success = TRUE;
    SET p_message = 'Project scheduled successfully.';
END //
DELIMITER ;

-- Process payment for invoice
DELIMITER //
CREATE PROCEDURE sp_process_payment(
    IN p_invoice_id VARCHAR(36),
    IN p_payment_date DATE,
    IN p_payment_method VARCHAR(50),
    IN p_amount DECIMAL(10,2),
    IN p_reference_number VARCHAR(50),
    IN p_notes TEXT,
    OUT p_payment_id VARCHAR(36),
    OUT p_new_balance DECIMAL(10,2),
    OUT p_success BOOLEAN,
    OUT p_message VARCHAR(255)
)
BEGIN
    DECLARE v_new_payment_id VARCHAR(36);
    DECLARE v_invoice_total DECIMAL(10,2);
    DECLARE v_current_amount_paid DECIMAL(10,2);
    DECLARE v_new_amount_paid DECIMAL(10,2);
    DECLARE v_new_balance DECIMAL(10,2);
    DECLARE v_invoice_status VARCHAR(20);
    
    -- Get invoice information
    SELECT total, amount_paid, status
    INTO v_invoice_total, v_current_amount_paid, v_invoice_status
    FROM invoices
    WHERE invoice_id = p_invoice_id;
    
    -- Check if invoice exists
    IF v_invoice_total IS NULL THEN
        SET p_success = FALSE;
        SET p_message = 'Invoice not found.';
        RETURN;
    END IF;
    
    -- Check if invoice is not cancelled
    IF v_invoice_status = 'cancelled' THEN
        SET p_success = FALSE;
        SET p_message = 'Cannot process payment for a cancelled invoice.';
        RETURN;
    END IF;
    
    -- Check if payment amount is valid
    IF p_amount <= 0 THEN
        SET p_success = FALSE;
        SET p_message = 'Payment amount must be greater than zero.';
        RETURN;
    END IF;
    
    -- Calculate new balance
    SET v_new_amount_paid = v_current_amount_paid + p_amount;
    SET v_new_balance = v_invoice_total - v_new_amount_paid;
    
    -- Check for overpayment
    IF v_new_balance < 0 THEN
        SET p_success = FALSE;
        SET p_message = CONCAT('Payment amount exceeds invoice balance. Maximum payment allowed: ', v_invoice_total - v_current_amount_paid);
        RETURN;
    END IF;
    
    -- Generate payment ID
    SET v_new_payment_id = UUID();
    
    -- Start transaction
    START TRANSACTION;
    
    -- Insert payment record
    INSERT INTO payments (
        payment_id, invoice_id, payment_date, payment_method,
        amount, reference_number, notes
    ) VALUES (
        v_new_payment_id, p_invoice_id, p_payment_date, p_payment_method,
        p_amount, p_reference_number, p_notes
    );
    
    -- Update invoice record
    UPDATE invoices
    SET amount_paid = v_new_amount_paid,
        balance = v_new_balance,
        status = CASE
            WHEN v_new_balance = 0 THEN 'paid'
            WHEN v_new_amount_paid > 0 THEN 'partial'
            ELSE status
        END,
        updated_at = CURRENT_TIMESTAMP
    WHERE invoice_id = p_invoice_id;
    
    -- Commit transaction
    COMMIT;
    
    -- Set output variables
    SET p_payment_id = v_new_payment_id;
    SET p_new_balance = v_new_balance;
    SET p_success = TRUE;
    SET p_message = 'Payment processed successfully.';
END //
DELIMITER ;
