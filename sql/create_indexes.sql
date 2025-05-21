/*
Additional indexes for the CRM database for painting and decorating companies.
These indexes complement the primary indexes already defined in create_tables.sql
to optimize specific query patterns identified in the database design.
*/

-- Indexes for project timeline management
CREATE INDEX idx_projects_start_date ON projects(start_date);
CREATE INDEX idx_projects_end_date ON projects(end_date);
CREATE INDEX idx_schedule_events_start_datetime ON schedule_events(start_datetime);
CREATE INDEX idx_schedule_events_end_datetime ON schedule_events(end_datetime);

-- Indexes for financial reporting
CREATE INDEX idx_invoices_invoice_date ON invoices(invoice_date);
CREATE INDEX idx_invoices_due_date ON invoices(due_date);
CREATE INDEX idx_invoices_status ON invoices(status);
CREATE INDEX idx_payments_payment_date ON payments(payment_date);
CREATE INDEX idx_payments_payment_method ON payments(payment_method);

-- Indexes for team management
CREATE INDEX idx_team_members_role ON team_members(role);
CREATE INDEX idx_project_team_assignments_team_member_id ON project_team_assignments(team_member_id);
CREATE INDEX idx_schedule_assignments_team_member_id ON schedule_assignments(team_member_id);
CREATE INDEX idx_tasks_due_date ON tasks(due_date);
CREATE INDEX idx_tasks_status ON tasks(status);

-- Indexes for material tracking
CREATE INDEX idx_materials_material_type ON materials(material_type);
CREATE INDEX idx_materials_brand ON materials(brand);
CREATE INDEX idx_project_materials_material_id ON project_materials(material_id);

-- Composite indexes for common query patterns
CREATE INDEX idx_properties_location ON properties(city, state, zip_code);
CREATE INDEX idx_projects_status_dates ON projects(status, start_date, end_date);
CREATE INDEX idx_customers_name ON customers(last_name, first_name);
CREATE INDEX idx_invoices_date_status ON invoices(invoice_date, status);
CREATE INDEX idx_team_members_name ON team_members(last_name, first_name);

-- Full-text search indexes for advanced search capabilities
-- Note: These should be adjusted based on the specific database engine used
-- Example for MySQL:
-- CREATE FULLTEXT INDEX ft_idx_customers_name ON customers(first_name, last_name, company_name);
-- CREATE FULLTEXT INDEX ft_idx_properties_address ON properties(property_name, address_line1, city, state);
-- CREATE FULLTEXT INDEX ft_idx_projects_info ON projects(project_name, description);
-- CREATE FULLTEXT INDEX ft_idx_communications_content ON communications(subject, content);

-- Advanced indexing for date range queries
CREATE INDEX idx_invoices_date_range ON invoices(invoice_date, due_date);
CREATE INDEX idx_schedule_events_datetime_range ON schedule_events(start_datetime, end_datetime);
CREATE INDEX idx_projects_date_range ON projects(start_date, end_date);

-- Indexes to support foreign key delete/update cascades
CREATE INDEX idx_estimate_line_items_estimate_id ON estimate_line_items(estimate_id);
CREATE INDEX idx_project_materials_project_id ON project_materials(project_id);
