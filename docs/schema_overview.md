# CRM Database Schema Overview

This document provides a high-level overview of the core entities and relationships in the CRM database system for painting and decorating companies.

## Core Entities

### Customers
The central entity for storing client information, including:
- Contact details
- Classification (residential/commercial)
- Source of lead
- Communication preferences
- Relationship history

### Properties
Represents locations where work is performed:
- Property details (address, size, type)
- Access information
- Special conditions
- Historical work record
- Related customer

### Projects
Encompasses individual painting/decorating jobs:
- Project specifications
- Timeline
- Status tracking
- Related property and customer
- Assigned team members
- Financial aspects

### Estimates
Detailed quotations provided to customers:
- Line items for services
- Material specifications
- Pricing calculations
- Terms and conditions
- Status (draft, sent, approved, rejected)

### Services
Catalog of services offered:
- Service categories
- Default pricing structures
- Required skills and resources
- Estimated durations

## Operational Entities

### Materials
Tracks all supplies used in projects:
- Paint, wallpaper, and other materials
- Supplier information
- Cost tracking
- Inventory management
- Usage allocation

### Team Members
Information about employees and contractors:
- Contact information
- Skills and certifications
- Availability
- Performance metrics
- Payment rates

### Schedule
Manages timing of all activities:
- Calendar events
- Resource allocation
- Project milestones
- Availability tracking

### Tasks
Tracks specific actions to be completed:
- Task descriptions
- Assignments
- Due dates
- Status tracking
- Dependency management

## Financial Entities

### Invoices
Records of billing to customers:
- Invoice details
- Line items
- Payment terms
- Status tracking

### Payments
Tracks financial transactions:
- Payment amounts
- Payment methods
- Transaction dates
- Allocation to invoices

### Expenses
Records costs associated with projects:
- Material costs
- Labor expenses
- Overhead allocations
- Vendor payments

## Key Relationships

1. Customers ↔ Properties (One-to-Many)
2. Properties ↔ Projects (One-to-Many)
3. Customers ↔ Projects (One-to-Many)
4. Projects ↔ Estimates (One-to-Many)
5. Projects ↔ Services (Many-to-Many)
6. Projects ↔ Materials (Many-to-Many)
7. Projects ↔ Team Members (Many-to-Many)
8. Projects ↔ Tasks (One-to-Many)
9. Projects ↔ Invoices (One-to-Many)
10. Invoices ↔ Payments (One-to-Many)
11. Projects ↔ Expenses (One-to-Many)
12. Projects ↔ Schedule (One-to-Many)

A detailed Entity-Relationship Diagram (ERD) will be developed in the next phase to visually represent these relationships and include attribute details.
