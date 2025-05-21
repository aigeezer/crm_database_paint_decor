/*
Basic SQL file structure for a CRM database for painting and decorating companies.
This file contains the core table definitions with appropriate relationships.
*/

-- Enable foreign key constraints and set other database settings
PRAGMA foreign_keys = ON;

-- Customers table
CREATE TABLE customers (
    customer_id VARCHAR(36) PRIMARY KEY,
    customer_type VARCHAR(20) NOT NULL CHECK (customer_type IN ('residential', 'commercial', 'government')),
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    company_name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    address_line1 VARCHAR(100),
    address_line2 VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50),
    zip_code VARCHAR(20),
    country VARCHAR(50) DEFAULT 'USA',
    lead_source VARCHAR(50),
    referral_source VARCHAR(100),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

-- Properties table
CREATE TABLE properties (
    property_id VARCHAR(36) PRIMARY KEY,
    customer_id VARCHAR(36) NOT NULL,
    property_name VARCHAR(100),
    property_type VARCHAR(50) NOT NULL,
    address_line1 VARCHAR(100) NOT NULL,
    address_line2 VARCHAR(100),
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    zip_code VARCHAR(20) NOT NULL,
    country VARCHAR(50) DEFAULT 'USA',
    square_footage INTEGER,
    number_of_rooms INTEGER,
    number_of_stories INTEGER,
    year_built INTEGER,
    special_instructions TEXT,
    access_code VARCHAR(20),
    has_pets BOOLEAN DEFAULT FALSE,
    has_alarm BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Projects table
CREATE TABLE projects (
    project_id VARCHAR(36) PRIMARY KEY,
    customer_id VARCHAR(36) NOT NULL,
    property_id VARCHAR(36) NOT NULL,
    project_name VARCHAR(100) NOT NULL,
    project_type VARCHAR(50) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'lead',
    description TEXT,
    start_date DATE,
    end_date DATE,
    estimated_hours DECIMAL(10,2),
    actual_hours DECIMAL(10,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (property_id) REFERENCES properties(property_id)
);

-- Estimates table
CREATE TABLE estimates (
    estimate_id VARCHAR(36) PRIMARY KEY,
    project_id VARCHAR(36) NOT NULL,
    estimate_number VARCHAR(20) NOT NULL,
    estimate_date DATE NOT NULL,
    valid_until DATE,
    status VARCHAR(20) NOT NULL DEFAULT 'draft',
    subtotal DECIMAL(10,2) NOT NULL,
    tax_rate DECIMAL(5,2),
    tax_amount DECIMAL(10,2),
    discount_percentage DECIMAL(5,2),
    discount_amount DECIMAL(10,2),
    total DECIMAL(10,2) NOT NULL,
    notes TEXT,
    terms_conditions TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (project_id) REFERENCES projects(project_id)
);

-- Services table
CREATE TABLE services (
    service_id VARCHAR(36) PRIMARY KEY,
    service_name VARCHAR(100) NOT NULL,
    service_category VARCHAR(50) NOT NULL,
    description TEXT,
    unit_type VARCHAR(20) NOT NULL,
    default_price DECIMAL(10,2),
    default_hours DECIMAL(5,2),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Estimate line items table
CREATE TABLE estimate_line_items (
    line_item_id VARCHAR(36) PRIMARY KEY,
    estimate_id VARCHAR(36) NOT NULL,
    service_id VARCHAR(36),
    item_type VARCHAR(20) NOT NULL,
    description TEXT NOT NULL,
    quantity DECIMAL(10,2) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    line_total DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (estimate_id) REFERENCES estimates(estimate_id),
    FOREIGN KEY (service_id) REFERENCES services(service_id)
);

-- Team members table
CREATE TABLE team_members (
    team_member_id VARCHAR(36) PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20),
    role VARCHAR(50) NOT NULL,
    hourly_rate DECIMAL(10,2),
    is_active BOOLEAN DEFAULT TRUE,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Project team assignments
CREATE TABLE project_team_assignments (
    assignment_id VARCHAR(36) PRIMARY KEY,
    project_id VARCHAR(36) NOT NULL,
    team_member_id VARCHAR(36) NOT NULL,
    role_on_project VARCHAR(50),
    start_date DATE,
    end_date DATE,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (project_id) REFERENCES projects(project_id),
    FOREIGN KEY (team_member_id) REFERENCES team_members(team_member_id)
);

-- Materials table
CREATE TABLE materials (
    material_id VARCHAR(36) PRIMARY KEY,
    material_name VARCHAR(100) NOT NULL,
    material_type VARCHAR(50) NOT NULL,
    description TEXT,
    sku VARCHAR(50),
    brand VARCHAR(50),
    default_unit VARCHAR(20) NOT NULL,
    cost_per_unit DECIMAL(10,2),
    markup_percentage DECIMAL(5,2) DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Project materials
CREATE TABLE project_materials (
    project_material_id VARCHAR(36) PRIMARY KEY,
    project_id VARCHAR(36) NOT NULL,
    material_id VARCHAR(36) NOT NULL,
    quantity DECIMAL(10,2) NOT NULL,
    unit_cost DECIMAL(10,2) NOT NULL,
    total_cost DECIMAL(10,2) NOT NULL,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (project_id) REFERENCES projects(project_id),
    FOREIGN KEY (material_id) REFERENCES materials(material_id)
);

-- Tasks table
CREATE TABLE tasks (
    task_id VARCHAR(36) PRIMARY KEY,
    project_id VARCHAR(36) NOT NULL,
    assigned_to VARCHAR(36),
    task_name VARCHAR(100) NOT NULL,
    description TEXT,
    status VARCHAR(20) NOT NULL DEFAULT 'pending',
    priority VARCHAR(20) DEFAULT 'medium',
    due_date DATE,
    completed_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (project_id) REFERENCES projects(project_id),
    FOREIGN KEY (assigned_to) REFERENCES team_members(team_member_id)
);

-- Schedule events
CREATE TABLE schedule_events (
    event_id VARCHAR(36) PRIMARY KEY,
    project_id VARCHAR(36) NOT NULL,
    event_type VARCHAR(50) NOT NULL,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    start_datetime TIMESTAMP NOT NULL,
    end_datetime TIMESTAMP NOT NULL,
    all_day BOOLEAN DEFAULT FALSE,
    location VARCHAR(100),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (project_id) REFERENCES projects(project_id)
);

-- Schedule assignments
CREATE TABLE schedule_assignments (
    assignment_id VARCHAR(36) PRIMARY KEY,
    event_id VARCHAR(36) NOT NULL,
    team_member_id VARCHAR(36) NOT NULL,
    status VARCHAR(20) DEFAULT 'pending',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (event_id) REFERENCES schedule_events(event_id),
    FOREIGN KEY (team_member_id) REFERENCES team_members(team_member_id)
);

-- Invoices table
CREATE TABLE invoices (
    invoice_id VARCHAR(36) PRIMARY KEY,
    project_id VARCHAR(36) NOT NULL,
    customer_id VARCHAR(36) NOT NULL,
    invoice_number VARCHAR(20) NOT NULL,
    invoice_date DATE NOT NULL,
    due_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'draft',
    subtotal DECIMAL(10,2) NOT NULL,
    tax_rate DECIMAL(5,2),
    tax_amount DECIMAL(10,2),
    discount_percentage DECIMAL(5,2),
    discount_amount DECIMAL(10,2),
    total DECIMAL(10,2) NOT NULL,
    amount_paid DECIMAL(10,2) DEFAULT 0,
    balance DECIMAL(10,2),
    notes TEXT,
    terms TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (project_id) REFERENCES projects(project_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Payments table
CREATE TABLE payments (
    payment_id VARCHAR(36) PRIMARY KEY,
    invoice_id VARCHAR(36) NOT NULL,
    payment_date DATE NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    reference_number VARCHAR(50),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (invoice_id) REFERENCES invoices(invoice_id)
);

-- Communications table
CREATE TABLE communications (
    communication_id VARCHAR(36) PRIMARY KEY,
    customer_id VARCHAR(36) NOT NULL,
    project_id VARCHAR(36),
    communication_type VARCHAR(20) NOT NULL,
    subject VARCHAR(100),
    content TEXT,
    direction VARCHAR(10) NOT NULL,
    status VARCHAR(20) NOT NULL,
    communication_date TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (project_id) REFERENCES projects(project_id)
);

-- Create indexes for performance optimization
CREATE INDEX idx_customers_email ON customers(email);
CREATE INDEX idx_customers_phone ON customers(phone);
CREATE INDEX idx_properties_customer_id ON properties(customer_id);
CREATE INDEX idx_projects_customer_id ON projects(customer_id);
CREATE INDEX idx_projects_property_id ON projects(property_id);
CREATE INDEX idx_projects_status ON projects(status);
CREATE INDEX idx_estimates_project_id ON estimates(project_id);
CREATE INDEX idx_invoices_project_id ON invoices(project_id);
CREATE INDEX idx_invoices_customer_id ON invoices(customer_id);
CREATE INDEX idx_payments_invoice_id ON payments(invoice_id);
CREATE INDEX idx_tasks_project_id ON tasks(project_id);
CREATE INDEX idx_tasks_assigned_to ON tasks(assigned_to);
CREATE INDEX idx_schedule_events_project_id ON schedule_events(project_id);
CREATE INDEX idx_communications_customer_id ON communications(customer_id);
CREATE INDEX idx_communications_project_id ON communications(project_id);
