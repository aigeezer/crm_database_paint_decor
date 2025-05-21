/*
Sample data for testing the CRM database for painting and decorating companies.
This script populates the database with realistic test data.
*/

-- Insert sample customers
INSERT INTO customers 
(customer_id, customer_type, first_name, last_name, company_name, email, phone, address_line1, city, state, zip_code, lead_source, is_active)
VALUES
('cust-001', 'residential', 'John', 'Smith', NULL, 'john.smith@example.com', '555-123-4567', '123 Main St', 'Springfield', 'IL', '62701', 'website', 1),
('cust-002', 'residential', 'Mary', 'Johnson', NULL, 'mary.johnson@example.com', '555-234-5678', '456 Oak Ave', 'Springfield', 'IL', '62702', 'referral', 1),
('cust-003', 'commercial', 'Robert', 'Williams', 'Williams Properties', 'robert@williamsProperties.com', '555-345-6789', '789 Pine Blvd', 'Springfield', 'IL', '62703', 'google', 1),
('cust-004', 'residential', 'Patricia', 'Brown', NULL, 'patricia.brown@example.com', '555-456-7890', '101 Elm St', 'Springfield', 'IL', '62704', 'facebook', 1),
('cust-005', 'commercial', 'Michael', 'Davis', 'Davis & Sons', 'michael@davisandsons.com', '555-567-8901', '202 Maple Dr', 'Springfield', 'IL', '62705', 'direct_mail', 1);

-- Insert sample properties
INSERT INTO properties 
(property_id, customer_id, property_name, property_type, address_line1, city, state, zip_code, square_footage, number_of_rooms)
VALUES
('prop-001', 'cust-001', 'Primary Residence', 'single_family', '123 Main St', 'Springfield', 'IL', '62701', 2200, 8),
('prop-002', 'cust-002', 'Primary Residence', 'townhouse', '456 Oak Ave', 'Springfield', 'IL', '62702', 1800, 6),
('prop-003', 'cust-003', 'Office Building A', 'commercial', '789 Pine Blvd', 'Springfield', 'IL', '62703', 5000, 20),
('prop-004', 'cust-004', 'Primary Residence', 'condo', '101 Elm St', 'Springfield', 'IL', '62704', 1500, 5),
('prop-005', 'cust-003', 'Office Building B', 'commercial', '303 Cedar Ln', 'Springfield', 'IL', '62703', 4000, 15),
('prop-006', 'cust-005', 'Retail Store', 'commercial', '202 Maple Dr', 'Springfield', 'IL', '62705', 3000, 4);

-- Insert sample services
INSERT INTO services 
(service_id, service_name, service_category, description, unit_type, default_price, default_hours, is_active)
VALUES
('serv-001', 'Interior Painting', 'painting', 'Standard interior wall painting', 'sq_ft', 3.50, 0.02, 1),
('serv-002', 'Exterior Painting', 'painting', 'Exterior surface painting', 'sq_ft', 4.25, 0.025, 1),
('serv-003', 'Wallpaper Installation', 'decorating', 'Wallpaper installation', 'sq_ft', 5.75, 0.03, 1),
('serv-004', 'Wallpaper Removal', 'decorating', 'Removal of existing wallpaper', 'sq_ft', 2.50, 0.02, 1),
('serv-005', 'Popcorn Ceiling Removal', 'renovation', 'Remove popcorn/textured ceiling', 'sq_ft', 3.25, 0.04, 1),
('serv-006', 'Cabinet Painting', 'painting', 'Paint kitchen or bathroom cabinets', 'linear_ft', 45.00, 0.5, 1),
('serv-007', 'Deck Staining', 'exterior', 'Stain and seal wooden deck', 'sq_ft', 2.75, 0.015, 1),
('serv-008', 'Drywall Repair', 'renovation', 'Patch and repair damaged drywall', 'hour', 75.00, 1.0, 1),
('serv-009', 'Color Consultation', 'design', 'Professional color selection advice', 'flat', 150.00, 2.0, 1);

-- Insert sample materials
INSERT INTO materials 
(material_id, material_name, material_type, description, brand, default_unit, cost_per_unit, markup_percentage, is_active)
VALUES
('mat-001', 'Interior Paint - Eggshell', 'paint', 'Premium interior paint, eggshell finish', 'Sherwin Williams', 'gallon', 45.00, 20.00, 1),
('mat-002', 'Interior Paint - Flat', 'paint', 'Standard interior paint, flat finish', 'Benjamin Moore', 'gallon', 38.00, 20.00, 1),
('mat-003', 'Exterior Paint - Satin', 'paint', 'Weather-resistant exterior paint', 'Behr', 'gallon', 52.00, 15.00, 1),
('mat-004', 'Primer - Multi-Surface', 'primer', 'All-purpose primer', 'Kilz', 'gallon', 30.00, 15.00, 1),
('mat-005', 'Wallpaper - Vinyl', 'wallpaper', 'Washable vinyl wallpaper', 'Graham & Brown', 'roll', 65.00, 25.00, 1),
('mat-006', 'Wallpaper Adhesive', 'adhesive', 'Professional-grade wallpaper adhesive', 'Roman', 'gallon', 22.00, 15.00, 1),
('mat-007', 'Caulk - Paintable', 'caulk', 'Paintable silicone caulk', 'DAP', 'tube', 4.50, 10.00, 1),
('mat-008', 'Deck Stain - Semi-Transparent', 'stain', 'Oil-based deck stain', 'Thompson\'s WaterSeal', 'gallon', 48.00, 15.00, 1),
('mat-009', 'Drywall Compound', 'drywall', 'All-purpose joint compound', 'USG', 'bucket', 18.00, 10.00, 1),
('mat-010', 'Sandpaper - Fine', 'sandpaper', '220 grit sandpaper', '3M', 'package', 6.50, 5.00, 1);

-- Insert sample team members
INSERT INTO team_members 
(team_member_id, first_name, last_name, email, phone, role, hourly_rate, is_active)
VALUES
('team-001', 'David', 'Martinez', 'david.martinez@example.com', '555-111-2222', 'painter', 25.00, 1),
('team-002', 'Sarah', 'Anderson', 'sarah.anderson@example.com', '555-222-3333', 'painter', 25.00, 1),
('team-003', 'James', 'Wilson', 'james.wilson@example.com', '555-333-4444', 'lead_painter', 30.00, 1),
('team-004', 'Jennifer', 'Taylor', 'jennifer.taylor@example.com', '555-444-5555', 'decorator', 27.50, 1),
('team-005', 'Daniel', 'Thomas', 'daniel.thomas@example.com', '555-555-6666', 'estimator', 35.00, 1),
('team-006', 'Lisa', 'Garcia', 'lisa.garcia@example.com', '555-666-7777', 'admin', 22.00, 1);

-- Insert sample projects
INSERT INTO projects 
(project_id, customer_id, property_id, project_name, project_type, status, description, start_date, end_date, estimated_hours)
VALUES
('proj-001', 'cust-001', 'prop-001', 'Smith Interior Painting', 'interior', 'completed', 'Living room, dining room, and kitchen painting', '2025-03-10', '2025-03-15', 32.0),
('proj-002', 'cust-002', 'prop-002', 'Johnson Wallpaper Installation', 'decorating', 'in-progress', 'Master bedroom and bathroom wallpaper installation', '2025-05-15', '2025-05-18', 24.0),
('proj-003', 'cust-003', 'prop-003', 'Williams Office Repainting', 'commercial', 'scheduled', 'Repaint all offices and common areas', '2025-06-01', '2025-06-15', 120.0),
('proj-004', 'cust-004', 'prop-004', 'Brown Condo Update', 'interior', 'quoted', 'Complete interior repaint and cabinet refinishing', NULL, NULL, 45.0),
('proj-005', 'cust-005', 'prop-006', 'Davis Retail Store Exterior', 'exterior', 'lead', 'Exterior painting and signage prep', NULL, NULL, 60.0);

-- Insert sample estimates
INSERT INTO estimates 
(estimate_id, project_id, estimate_number, estimate_date, valid_until, status, subtotal, tax_rate, tax_amount, discount_percentage, discount_amount, total)
VALUES
('est-001', 'proj-001', '2025-03-001', '2025-02-15', '2025-03-15', 'approved', 3200.00, 7.50, 240.00, 5.00, 160.00, 3280.00),
('est-002', 'proj-002', '2025-04-002', '2025-04-20', '2025-05-20', 'approved', 2800.00, 7.50, 210.00, 0.00, 0.00, 3010.00),
('est-003', 'proj-003', '2025-05-003', '2025-05-10', '2025-06-10', 'approved', 8500.00, 7.50, 637.50, 10.00, 850.00, 8287.50),
('est-004', 'proj-004', '2025-05-004', '2025-05-12', '2025-06-12', 'sent', 4200.00, 7.50, 315.00, 0.00, 0.00, 4515.00),
('est-005', 'proj-005', '2025-05-005', '2025-05-14', '2025-06-14', 'draft', 6800.00, 7.50, 510.00, 0.00, 0.00, 7310.00);

-- Insert sample estimate line items
INSERT INTO estimate_line_items 
(line_item_id, estimate_id, service_id, item_type, description, quantity, unit_price, line_total)
VALUES
('line-001', 'est-001', 'serv-001', 'service', 'Interior painting - Living room', 600, 3.50, 2100.00),
('line-002', 'est-001', 'serv-001', 'service', 'Interior painting - Kitchen', 400, 3.50, 1400.00),
('line-003', 'est-001', 'mat-001', 'material', 'Interior Paint - Eggshell (Navajo White)', 5, 45.00, 225.00),
('line-004', 'est-001', 'mat-004', 'material', 'Primer - Multi-Surface', 2, 30.00, 60.00),

('line-005', 'est-002', 'serv-003', 'service', 'Wallpaper Installation - Master Bedroom', 350, 5.75, 2012.50),
('line-006', 'est-002', 'serv-003', 'service', 'Wallpaper Installation - Master Bathroom', 150, 5.75, 862.50),
('line-007', 'est-002', 'mat-005', 'material', 'Wallpaper - Vinyl (Floral Pattern)', 8, 65.00, 520.00),
('line-008', 'est-002', 'mat-006', 'material', 'Wallpaper Adhesive', 2, 22.00, 44.00),

('line-009', 'est-003', 'serv-001', 'service', 'Interior painting - Offices', 3000, 3.50, 10500.00),
('line-010', 'est-003', 'serv-001', 'service', 'Interior painting - Common Areas', 1000, 3.50, 3500.00),
('line-011', 'est-003', 'mat-002', 'material', 'Interior Paint - Flat (Arctic White)', 30, 38.00, 1140.00),
('line-012', 'est-003', 'mat-004', 'material', 'Primer - Multi-Surface', 12, 30.00, 360.00);

-- Insert sample project team assignments
INSERT INTO project_team_assignments 
(assignment_id, project_id, team_member_id, role_on_project, start_date, end_date)
VALUES
('assign-001', 'proj-001', 'team-001', 'painter', '2025-03-10', '2025-03-15'),
('assign-002', 'proj-001', 'team-003', 'lead', '2025-03-10', '2025-03-15'),
('assign-003', 'proj-002', 'team-004', 'lead', '2025-05-15', '2025-05-18'),
('assign-004', 'proj-002', 'team-002', 'assistant', '2025-05-15', '2025-05-18'),
('assign-005', 'proj-003', 'team-003', 'lead', '2025-06-01', '2025-06-15'),
('assign-006', 'proj-003', 'team-001', 'painter', '2025-06-01', '2025-06-15'),
('assign-007', 'proj-003', 'team-002', 'painter', '2025-06-01', '2025-06-15');

-- Insert sample project materials
INSERT INTO project_materials 
(project_material_id, project_id, material_id, quantity, unit_cost, total_cost)
VALUES
('pm-001', 'proj-001', 'mat-001', 5, 45.00, 225.00),
('pm-002', 'proj-001', 'mat-004', 2, 30.00, 60.00),
('pm-003', 'proj-001', 'mat-007', 4, 4.50, 18.00),
('pm-004', 'proj-002', 'mat-005', 8, 65.00, 520.00),
('pm-005', 'proj-002', 'mat-006', 2, 22.00, 44.00);

-- Insert sample tasks
INSERT INTO tasks 
(task_id, project_id, assigned_to, task_name, description, status, priority, due_date)
VALUES
('task-001', 'proj-001', 'team-003', 'Prepare surfaces', 'Clean and prepare all surfaces for painting', 'completed', 'high', '2025-03-10'),
('task-002', 'proj-001', 'team-001', 'Apply primer', 'Apply primer to all prepared surfaces', 'completed', 'high', '2025-03-11'),
('task-003', 'proj-001', 'team-001', 'Paint walls', 'Apply two coats of paint to all walls', 'completed', 'high', '2025-03-13'),
('task-004', 'proj-001', 'team-003', 'Final inspection', 'Check for quality and touch-ups', 'completed', 'medium', '2025-03-15'),
('task-005', 'proj-002', 'team-004', 'Prepare walls', 'Remove old wallpaper and prepare surfaces', 'completed', 'high', '2025-05-15'),
('task-006', 'proj-002', 'team-004', 'Install wallpaper', 'Install new wallpaper in master bedroom', 'in-progress', 'high', '2025-05-17'),
('task-007', 'proj-002', 'team-002', 'Clean up', 'Final cleanup and inspection', 'pending', 'medium', '2025-05-18'),
('task-008', 'proj-003', 'team-005', 'Order materials', 'Order all required paint and supplies', 'pending', 'high', '2025-05-25'),
('task-009', 'proj-003', 'team-003', 'Prepare schedule', 'Create detailed work schedule for team', 'pending', 'medium', '2025-05-28');

-- Insert sample schedule events
INSERT INTO schedule_events 
(event_id, project_id, event_type, title, description, start_datetime, end_datetime, all_day)
VALUES
('event-001', 'proj-001', 'project', 'Smith Interior Painting', 'Complete interior painting project', '2025-03-10 08:00:00', '2025-03-15 17:00:00', FALSE),
('event-002', 'proj-001', 'task', 'Prepare surfaces', 'Clean and prepare all surfaces', '2025-03-10 08:00:00', '2025-03-10 17:00:00', TRUE),
('event-003', 'proj-001', 'task', 'Apply primer', 'Apply primer coat', '2025-03-11 08:00:00', '2025-03-11 17:00:00', TRUE),
('event-004', 'proj-002', 'project', 'Johnson Wallpaper Installation', 'Install wallpaper in master bedroom and bathroom', '2025-05-15 08:00:00', '2025-05-18 17:00:00', FALSE),
('event-005', 'proj-003', 'kickoff', 'Williams Office Project Kickoff', 'Initial meeting and site walkthrough', '2025-05-30 10:00:00', '2025-05-30 12:00:00', FALSE);

-- Insert sample schedule assignments
INSERT INTO schedule_assignments 
(assignment_id, event_id, team_member_id, status)
VALUES
('sa-001', 'event-001', 'team-001', 'completed'),
('sa-002', 'event-001', 'team-003', 'completed'),
('sa-003', 'event-002', 'team-003', 'completed'),
('sa-004', 'event-003', 'team-001', 'completed'),
('sa-005', 'event-004', 'team-004', 'assigned'),
('sa-006', 'event-004', 'team-002', 'assigned'),
('sa-007', 'event-005', 'team-003', 'scheduled'),
('sa-008', 'event-005', 'team-005', 'scheduled');

-- Insert sample invoices
INSERT INTO invoices 
(invoice_id, project_id, customer_id, invoice_number, invoice_date, due_date, status, subtotal, tax_rate, tax_amount, discount_percentage, discount_amount, total, amount_paid, balance)
VALUES
('inv-001', 'proj-001', 'cust-001', '2025-03-001', '2025-03-15', '2025-04-15', 'paid', 3200.00, 7.50, 240.00, 5.00, 160.00, 3280.00, 3280.00, 0.00),
('inv-002', 'proj-002', 'cust-002', '2025-05-001', '2025-05-15', '2025-06-15', 'partial', 2800.00, 7.50, 210.00, 0.00, 0.00, 3010.00, 1500.00, 1510.00);

-- Insert sample payments
INSERT INTO payments 
(payment_id, invoice_id, payment_date, payment_method, amount, reference_number)
VALUES
('pay-001', 'inv-001', '2025-03-20', 'credit_card', 3280.00, 'CC-78901'),
('pay-002', 'inv-002', '2025-05-20', 'check', 1500.00, 'CHK-12345');

-- Insert sample communications
INSERT INTO communications 
(communication_id, customer_id, project_id, communication_type, subject, content, direction, status, communication_date)
VALUES
('comm-001', 'cust-001', 'proj-001', 'email', 'Project Completion', 'Thank you for choosing our services. Your project has been completed. Please let us know if you have any questions.', 'outgoing', 'sent', '2025-03-15 16:30:00'),
('comm-002', 'cust-001', 'proj-001', 'email', 'Re: Project Completion', 'Thank you for the great work! We are very happy with the results.', 'incoming', 'received', '2025-03-16 09:15:00'),
('comm-003', 'cust-002', 'proj-002', 'phone', 'Schedule Confirmation', 'Called to confirm the schedule for the wallpaper installation project.', 'outgoing', 'completed', '2025-05-12 11:20:00'),
('comm-004', 'cust-003', 'proj-003', 'email', 'Project Proposal', 'Sending over the detailed proposal for the office repainting project.', 'outgoing', 'sent', '2025-05-10 14:45:00'),
('comm-005', 'cust-004', 'proj-004', 'email', 'Quote Follow-up', 'Following up on the quote we sent last week. Please let me know if you have any questions.', 'outgoing', 'sent', '2025-05-19 10:30:00');
