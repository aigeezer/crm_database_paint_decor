/*
Triggers for the CRM database for painting and decorating companies.
These triggers enforce business rules, maintain data integrity, and automate processes.
*/

-- Set DELIMITER for multi-statement triggers
DELIMITER //

-- Update timestamp trigger for customers table
CREATE TRIGGER trg_customers_before_update
BEFORE UPDATE ON customers
FOR EACH ROW
BEGIN
    SET NEW.updated_at = CURRENT_TIMESTAMP;
END //

-- Update timestamp trigger for properties table
CREATE TRIGGER trg_properties_before_update
BEFORE UPDATE ON properties
FOR EACH ROW
BEGIN
    SET NEW.updated_at = CURRENT_TIMESTAMP;
END //

-- Update timestamp trigger for projects table
CREATE TRIGGER trg_projects_before_update
BEFORE UPDATE ON projects
FOR EACH ROW
BEGIN
    SET NEW.updated_at = CURRENT_TIMESTAMP;
END //

-- Auto-calculate invoice balance on insert
CREATE TRIGGER trg_invoices_before_insert
BEFORE INSERT ON invoices
FOR EACH ROW
BEGIN
    IF NEW.amount_paid IS NULL THEN
        SET NEW.amount_paid = 0;
    END IF;
    
    SET NEW.balance = NEW.total - NEW.amount_paid;
END //

-- Update invoice balance and status on payment
CREATE TRIGGER trg_payments_after_insert
AFTER INSERT ON payments
FOR EACH ROW
BEGIN
    DECLARE v_total DECIMAL(10,2);
    DECLARE v_amount_paid DECIMAL(10,2);
    DECLARE v_balance DECIMAL(10,2);
    
    -- Calculate new payment totals
    SELECT total, amount_paid + NEW.amount 
    INTO v_total, v_amount_paid
    FROM invoices 
    WHERE invoice_id = NEW.invoice_id;
    
    SET v_balance = v_total - v_amount_paid;
    
    -- Update invoice with new payment information
    UPDATE invoices
    SET amount_paid = v_amount_paid,
        balance = v_balance,
        status = CASE
            WHEN v_balance <= 0 THEN 'paid'
            WHEN v_amount_paid > 0 THEN 'partial'
            ELSE status
        END,
        updated_at = CURRENT_TIMESTAMP
    WHERE invoice_id = NEW.invoice_id;
END //

-- Prevent project deletion if it has associated invoices or estimates
CREATE TRIGGER trg_projects_before_delete
BEFORE DELETE ON projects
FOR EACH ROW
BEGIN
    DECLARE invoice_count INT;
    DECLARE estimate_count INT;
    
    -- Check for related records
    SELECT COUNT(*) INTO invoice_count FROM invoices WHERE project_id = OLD.project_id;
    SELECT COUNT(*) INTO estimate_count FROM estimates WHERE project_id = OLD.project_id;
    
    -- Prevent deletion if related records exist
    IF invoice_count > 0 OR estimate_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete project with associated invoices or estimates';
    END IF;
END //

-- Automatically calculate line_total in estimate_line_items
CREATE TRIGGER trg_estimate_line_items_before_insert
BEFORE INSERT ON estimate_line_items
FOR EACH ROW
BEGIN
    SET NEW.line_total = NEW.quantity * NEW.unit_price;
END //

CREATE TRIGGER trg_estimate_line_items_before_update
BEFORE UPDATE ON estimate_line_items
FOR EACH ROW
BEGIN
    SET NEW.line_total = NEW.quantity * NEW.unit_price;
    SET NEW.updated_at = CURRENT_TIMESTAMP;
END //

-- Auto-update project status when estimate is approved
CREATE TRIGGER trg_estimates_after_update
AFTER UPDATE ON estimates
FOR EACH ROW
BEGIN
    IF NEW.status = 'approved' AND OLD.status != 'approved' THEN
        UPDATE projects
        SET status = 'quoted',
            updated_at = CURRENT_TIMESTAMP
        WHERE project_id = NEW.project_id
        AND status = 'lead';
    END IF;
END //

-- Auto-calculate total_cost in project_materials
CREATE TRIGGER trg_project_materials_before_insert
BEFORE INSERT ON project_materials
FOR EACH ROW
BEGIN
    SET NEW.total_cost = NEW.quantity * NEW.unit_cost;
END //

CREATE TRIGGER trg_project_materials_before_update
BEFORE UPDATE ON project_materials
FOR EACH ROW
BEGIN
    SET NEW.total_cost = NEW.quantity * NEW.unit_cost;
    SET NEW.updated_at = CURRENT_TIMESTAMP;
END //

-- Log communications for certain project status changes
CREATE TRIGGER trg_projects_after_status_update
AFTER UPDATE ON projects
FOR EACH ROW
BEGIN
    DECLARE v_customer_id VARCHAR(36);
    DECLARE v_communication_content TEXT;
    
    -- Only proceed if status has changed
    IF NEW.status != OLD.status THEN
        -- Get customer ID
        SELECT customer_id INTO v_customer_id FROM projects WHERE project_id = NEW.project_id;
        
        -- Create appropriate message based on new status
        CASE NEW.status
            WHEN 'scheduled' THEN 
                SET v_communication_content = CONCAT('Project "', NEW.project_name, '" has been scheduled to start on ', DATE_FORMAT(NEW.start_date, '%M %d, %Y'), '.');
            WHEN 'in-progress' THEN
                SET v_communication_content = CONCAT('Project "', NEW.project_name, '" has started.');
            WHEN 'completed' THEN
                SET v_communication_content = CONCAT('Project "', NEW.project_name, '" has been marked as completed.');
            WHEN 'on-hold' THEN
                SET v_communication_content = CONCAT('Project "', NEW.project_name, '" has been placed on hold.');
            ELSE
                SET v_communication_content = NULL;
        END CASE;
        
        -- Log communication if we have content
        IF v_communication_content IS NOT NULL THEN
            INSERT INTO communications (
                communication_id, customer_id, project_id, communication_type,
                subject, content, direction, status, communication_date
            ) VALUES (
                UUID(), v_customer_id, NEW.project_id, 'system',
                CONCAT('Project Status Update: ', NEW.project_name),
                v_communication_content, 'outbound', 'sent', CURRENT_TIMESTAMP
            );
        END IF;
    END IF;
END //

-- Reset DELIMITER
DELIMITER ;
