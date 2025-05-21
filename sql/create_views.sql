/*
Views for the CRM database for painting and decorating companies.
These views provide useful abstractions for common queries and reports.
*/

-- Active Projects with Customer and Property Information
CREATE VIEW vw_active_projects AS
SELECT
    p.project_id,
    p.project_name,
    p.project_type,
    p.status,
    p.start_date,
    p.end_date,
    p.estimated_hours,
    p.actual_hours,
    c.customer_id,
    c.first_name,
    c.last_name,
    c.company_name,
    c.email,
    c.phone,
    pr.property_id,
    pr.property_name,
    pr.address_line1,
    pr.city,
    pr.state,
    pr.zip_code
FROM
    projects p
    JOIN customers c ON p.customer_id = c.customer_id
    JOIN properties pr ON p.property_id = pr.property_id
WHERE
    p.status NOT IN ('completed', 'cancelled', 'archived')
ORDER BY
    p.start_date;

-- Project Financial Summary
CREATE VIEW vw_project_financials AS
SELECT
    p.project_id,
    p.project_name,
    p.status,
    c.customer_id,
    c.first_name,
    c.last_name,
    c.company_name,
    COALESCE(e.total, 0) as estimated_total,
    COALESCE(SUM(pm.total_cost), 0) as material_costs,
    COALESCE(SUM(i.total), 0) as invoiced_amount,
    COALESCE(SUM(py.amount), 0) as paid_amount,
    COALESCE(SUM(i.total), 0) - COALESCE(SUM(py.amount), 0) as balance_due
FROM
    projects p
    JOIN customers c ON p.customer_id = c.customer_id
    LEFT JOIN (
        SELECT project_id, MAX(total) as total
        FROM estimates
        WHERE status = 'approved'
        GROUP BY project_id
    ) e ON p.project_id = e.project_id
    LEFT JOIN project_materials pm ON p.project_id = pm.project_id
    LEFT JOIN invoices i ON p.project_id = i.project_id
    LEFT JOIN payments py ON i.invoice_id = py.invoice_id
GROUP BY
    p.project_id, p.project_name, p.status, c.customer_id, c.first_name, c.last_name, c.company_name, e.total;

-- Team Member Schedule
CREATE VIEW vw_team_schedule AS
SELECT
    tm.team_member_id,
    tm.first_name,
    tm.last_name,
    se.event_id,
    se.title as event_title,
    se.start_datetime,
    se.end_datetime,
    p.project_id,
    p.project_name,
    pr.address_line1 as location,
    pr.city,
    pr.state,
    sa.status as assignment_status
FROM
    team_members tm
    JOIN schedule_assignments sa ON tm.team_member_id = sa.team_member_id
    JOIN schedule_events se ON sa.event_id = se.event_id
    JOIN projects p ON se.project_id = p.project_id
    JOIN properties pr ON p.property_id = pr.property_id
WHERE
    tm.is_active = TRUE
ORDER BY
    tm.last_name, tm.first_name, se.start_datetime;

-- Upcoming Tasks
CREATE VIEW vw_upcoming_tasks AS
SELECT
    t.task_id,
    t.task_name,
    t.description,
    t.status,
    t.priority,
    t.due_date,
    tm.first_name || ' ' || tm.last_name as assigned_to_name,
    p.project_id,
    p.project_name,
    c.first_name || ' ' || c.last_name as customer_name,
    c.company_name,
    pr.address_line1,
    pr.city,
    pr.state
FROM
    tasks t
    JOIN projects p ON t.project_id = p.project_id
    JOIN customers c ON p.customer_id = c.customer_id
    JOIN properties pr ON p.property_id = pr.property_id
    LEFT JOIN team_members tm ON t.assigned_to = tm.team_member_id
WHERE
    t.status NOT IN ('completed', 'cancelled')
    AND t.due_date >= CURRENT_DATE
ORDER BY
    t.due_date, t.priority;

-- Customer Project History
CREATE VIEW vw_customer_project_history AS
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.company_name,
    c.email,
    c.phone,
    p.project_id,
    p.project_name,
    p.project_type,
    p.status,
    p.start_date,
    p.end_date,
    COALESCE(SUM(i.total), 0) as total_billed,
    COALESCE(SUM(py.amount), 0) as total_paid,
    COUNT(DISTINCT com.communication_id) as communication_count
FROM
    customers c
    LEFT JOIN projects p ON c.customer_id = p.customer_id
    LEFT JOIN invoices i ON p.project_id = i.project_id
    LEFT JOIN payments py ON i.invoice_id = py.invoice_id
    LEFT JOIN communications com ON c.customer_id = com.customer_id
GROUP BY
    c.customer_id, c.first_name, c.last_name, c.company_name, c.email, c.phone,
    p.project_id, p.project_name, p.project_type, p.status, p.start_date, p.end_date
ORDER BY
    c.last_name, c.first_name, p.start_date DESC;

-- Material Usage By Project
CREATE VIEW vw_material_usage AS
SELECT
    p.project_id,
    p.project_name,
    p.status,
    m.material_id,
    m.material_name,
    m.material_type,
    m.brand,
    pm.quantity,
    pm.unit_cost,
    pm.total_cost
FROM
    projects p
    JOIN project_materials pm ON p.project_id = pm.project_id
    JOIN materials m ON pm.material_id = m.material_id
ORDER BY
    p.project_name, m.material_name;

-- Estimate vs Actual Costs
CREATE VIEW vw_estimate_vs_actual AS
SELECT
    p.project_id,
    p.project_name,
    p.status,
    e.estimate_id,
    e.estimate_number,
    e.total as estimated_total,
    COALESCE(SUM(pm.total_cost), 0) as actual_material_cost,
    p.estimated_hours,
    p.actual_hours,
    CASE 
        WHEN p.actual_hours IS NOT NULL THEN p.actual_hours - p.estimated_hours
        ELSE 0
    END as hours_variance,
    CASE
        WHEN e.total > 0 AND SUM(pm.total_cost) > 0 
        THEN (SUM(pm.total_cost) / e.total * 100) - 100
        ELSE 0
    END as cost_variance_percentage
FROM
    projects p
    LEFT JOIN estimates e ON p.project_id = e.project_id AND e.status = 'approved'
    LEFT JOIN project_materials pm ON p.project_id = pm.project_id
GROUP BY
    p.project_id, p.project_name, p.status, e.estimate_id, e.estimate_number, e.total, 
    p.estimated_hours, p.actual_hours;

-- Revenue by Period
CREATE VIEW vw_revenue_by_period AS
SELECT
    EXTRACT(YEAR FROM i.invoice_date) as year,
    EXTRACT(MONTH FROM i.invoice_date) as month,
    COUNT(DISTINCT i.invoice_id) as invoice_count,
    SUM(i.total) as total_revenue,
    SUM(p.amount) as collected_revenue,
    SUM(i.total) - SUM(p.amount) as outstanding_revenue
FROM
    invoices i
    LEFT JOIN payments p ON i.invoice_id = p.invoice_id
GROUP BY
    EXTRACT(YEAR FROM i.invoice_date), EXTRACT(MONTH FROM i.invoice_date)
ORDER BY
    year DESC, month DESC;

-- Team Productivity
CREATE VIEW vw_team_productivity AS
SELECT
    tm.team_member_id,
    tm.first_name || ' ' || tm.last_name as team_member_name,
    COUNT(DISTINCT pta.project_id) as assigned_projects,
    COUNT(DISTINCT t.task_id) as assigned_tasks,
    COUNT(DISTINCT CASE WHEN t.status = 'completed' THEN t.task_id END) as completed_tasks,
    COALESCE(SUM(p.actual_hours), 0) as total_hours_logged,
    CASE
        WHEN COUNT(DISTINCT t.task_id) > 0 
        THEN CAST(COUNT(DISTINCT CASE WHEN t.status = 'completed' THEN t.task_id END) AS FLOAT) / COUNT(DISTINCT t.task_id) * 100
        ELSE 0
    END as task_completion_rate
FROM
    team_members tm
    LEFT JOIN project_team_assignments pta ON tm.team_member_id = pta.team_member_id
    LEFT JOIN tasks t ON tm.team_member_id = t.assigned_to
    LEFT JOIN projects p ON pta.project_id = p.project_id
WHERE
    tm.is_active = TRUE
GROUP BY
    tm.team_member_id, tm.first_name, tm.last_name
ORDER BY
    team_member_name;
