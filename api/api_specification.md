# API Specification for Painting and Decorating CRM

## Overview

This document outlines the RESTful API endpoints for the Painting and Decorating CRM system. These endpoints provide programmatic access to the underlying database, enabling integration with mobile applications, third-party services, and custom interfaces.

## Base URL

```
https://api.paintdecorcrm.com/v1
```

## Authentication

All API requests require authentication using JSON Web Tokens (JWT).

### Obtaining a Token

```
POST /auth/login
```

**Request Body:**
```json
{
  "username": "string",
  "password": "string"
}
```

**Response:**
```json
{
  "token": "string",
  "expires": "datetime",
  "user": {
    "id": "integer",
    "username": "string",
    "full_name": "string",
    "role": "string"
  }
}
```

### Using the Token

Include the token in the Authorization header for all subsequent requests:

```
Authorization: Bearer {token}
```

## API Endpoints

### Customers

#### Get All Customers

```
GET /customers
```

**Query Parameters:**
- `page`: Page number (default: 1)
- `limit`: Items per page (default: 25, max: 100)
- `sort`: Field to sort by (default: last_name)
- `order`: Sort order (asc, desc)
- `search`: Search term
- `type`: Filter by customer type

**Response:**
```json
{
  "total": "integer",
  "page": "integer",
  "limit": "integer",
  "customers": [
    {
      "customer_id": "string",
      "customer_type": "string",
      "first_name": "string",
      "last_name": "string",
      "company_name": "string",
      "email": "string",
      "phone": "string",
      "address_line1": "string",
      "city": "string",
      "state": "string",
      "zip_code": "string",
      "is_active": "boolean",
      "created_at": "datetime"
    }
  ]
}
```

#### Get Customer by ID

```
GET /customers/{customer_id}
```

**Response:**
```json
{
  "customer_id": "string",
  "customer_type": "string",
  "first_name": "string",
  "last_name": "string",
  "company_name": "string",
  "email": "string",
  "phone": "string",
  "address_line1": "string",
  "address_line2": "string",
  "city": "string",
  "state": "string",
  "zip_code": "string",
  "country": "string",
  "lead_source": "string",
  "referral_source": "string",
  "notes": "string",
  "is_active": "boolean",
  "created_at": "datetime",
  "updated_at": "datetime"
}
```

#### Create Customer

```
POST /customers
```

**Request Body:**
```json
{
  "customer_type": "string",
  "first_name": "string",
  "last_name": "string",
  "company_name": "string",
  "email": "string",
  "phone": "string",
  "address_line1": "string",
  "address_line2": "string",
  "city": "string",
  "state": "string",
  "zip_code": "string",
  "country": "string",
  "lead_source": "string",
  "referral_source": "string",
  "notes": "string"
}
```

**Response:**
```json
{
  "customer_id": "string",
  "message": "Customer created successfully"
}
```

#### Update Customer

```
PUT /customers/{customer_id}
```

**Request Body:**
```json
{
  "customer_type": "string",
  "first_name": "string",
  "last_name": "string",
  "company_name": "string",
  "email": "string",
  "phone": "string",
  "address_line1": "string",
  "address_line2": "string",
  "city": "string",
  "state": "string",
  "zip_code": "string",
  "country": "string",
  "lead_source": "string",
  "referral_source": "string",
  "notes": "string",
  "is_active": "boolean"
}
```

**Response:**
```json
{
  "message": "Customer updated successfully"
}
```

#### Delete Customer

```
DELETE /customers/{customer_id}
```

**Response:**
```json
{
  "message": "Customer deleted successfully"
}
```

### Properties

#### Get Properties by Customer

```
GET /customers/{customer_id}/properties
```

**Response:**
```json
{
  "properties": [
    {
      "property_id": "string",
      "property_name": "string",
      "property_type": "string",
      "address_line1": "string",
      "city": "string",
      "state": "string",
      "zip_code": "string"
    }
  ]
}
```

#### Get Property by ID

```
GET /properties/{property_id}
```

**Response:**
```json
{
  "property_id": "string",
  "customer_id": "string",
  "property_name": "string",
  "property_type": "string",
  "address_line1": "string",
  "address_line2": "string",
  "city": "string",
  "state": "string",
  "zip_code": "string",
  "country": "string",
  "square_footage": "integer",
  "number_of_rooms": "integer",
  "number_of_stories": "integer",
  "year_built": "integer",
  "special_instructions": "string",
  "access_code": "string",
  "has_pets": "boolean",
  "has_alarm": "boolean",
  "created_at": "datetime",
  "updated_at": "datetime"
}
```

#### Create Property

```
POST /customers/{customer_id}/properties
```

**Request Body:**
```json
{
  "property_name": "string",
  "property_type": "string",
  "address_line1": "string",
  "address_line2": "string",
  "city": "string",
  "state": "string",
  "zip_code": "string",
  "country": "string",
  "square_footage": "integer",
  "number_of_rooms": "integer",
  "number_of_stories": "integer",
  "year_built": "integer",
  "special_instructions": "string",
  "access_code": "string",
  "has_pets": "boolean",
  "has_alarm": "boolean"
}
```

**Response:**
```json
{
  "property_id": "string",
  "message": "Property created successfully"
}
```

#### Update Property

```
PUT /properties/{property_id}
```

**Request Body:**
```json
{
  "property_name": "string",
  "property_type": "string",
  "address_line1": "string",
  "address_line2": "string",
  "city": "string",
  "state": "string",
  "zip_code": "string",
  "country": "string",
  "square_footage": "integer",
  "number_of_rooms": "integer",
  "number_of_stories": "integer",
  "year_built": "integer",
  "special_instructions": "string",
  "access_code": "string",
  "has_pets": "boolean",
  "has_alarm": "boolean"
}
```

**Response:**
```json
{
  "message": "Property updated successfully"
}
```

### Projects

#### Get All Projects

```
GET /projects
```

**Query Parameters:**
- `page`: Page number (default: 1)
- `limit`: Items per page (default: 25, max: 100)
- `status`: Filter by status
- `start_date`: Filter by start date (format: YYYY-MM-DD)
- `end_date`: Filter by end date (format: YYYY-MM-DD)
- `customer_id`: Filter by customer

**Response:**
```json
{
  "total": "integer",
  "page": "integer",
  "limit": "integer",
  "projects": [
    {
      "project_id": "string",
      "customer_id": "string",
      "property_id": "string",
      "project_name": "string",
      "project_type": "string",
      "status": "string",
      "start_date": "date",
      "end_date": "date",
      "customer_name": "string",
      "property_address": "string"
    }
  ]
}
```

#### Get Project by ID

```
GET /projects/{project_id}
```

**Response:**
```json
{
  "project_id": "string",
  "customer_id": "string",
  "property_id": "string",
  "project_name": "string",
  "project_type": "string",
  "status": "string",
  "description": "string",
  "start_date": "date",
  "end_date": "date",
  "estimated_hours": "number",
  "actual_hours": "number",
  "created_at": "datetime",
  "updated_at": "datetime",
  "customer": {
    "customer_id": "string",
    "first_name": "string",
    "last_name": "string",
    "company_name": "string",
    "email": "string",
    "phone": "string"
  },
  "property": {
    "property_id": "string",
    "property_name": "string",
    "address_line1": "string",
    "city": "string",
    "state": "string",
    "zip_code": "string"
  }
}
```

#### Create Project

```
POST /projects
```

**Request Body:**
```json
{
  "customer_id": "string",
  "property_id": "string",
  "project_name": "string",
  "project_type": "string",
  "status": "string",
  "description": "string",
  "start_date": "date",
  "end_date": "date",
  "estimated_hours": "number"
}
```

**Response:**
```json
{
  "project_id": "string",
  "message": "Project created successfully"
}
```

#### Update Project

```
PUT /projects/{project_id}
```

**Request Body:**
```json
{
  "project_name": "string",
  "project_type": "string",
  "status": "string",
  "description": "string",
  "start_date": "date",
  "end_date": "date",
  "estimated_hours": "number",
  "actual_hours": "number"
}
```

**Response:**
```json
{
  "message": "Project updated successfully"
}
```

#### Update Project Status

```
PATCH /projects/{project_id}/status
```

**Request Body:**
```json
{
  "status": "string"
}
```

**Response:**
```json
{
  "success": "boolean",
  "message": "string"
}
```

### Estimates

#### Get Estimates by Project

```
GET /projects/{project_id}/estimates
```

**Response:**
```json
{
  "estimates": [
    {
      "estimate_id": "string",
      "estimate_number": "string",
      "estimate_date": "date",
      "status": "string",
      "total": "number",
      "created_at": "datetime"
    }
  ]
}
```

#### Get Estimate by ID

```
GET /estimates/{estimate_id}
```

**Response:**
```json
{
  "estimate_id": "string",
  "project_id": "string",
  "estimate_number": "string",
  "estimate_date": "date",
  "valid_until": "date",
  "status": "string",
  "subtotal": "number",
  "tax_rate": "number",
  "tax_amount": "number",
  "discount_percentage": "number",
  "discount_amount": "number",
  "total": "number",
  "notes": "string",
  "terms_conditions": "string",
  "created_at": "datetime",
  "updated_at": "datetime",
  "line_items": [
    {
      "line_item_id": "string",
      "item_type": "string",
      "service_id": "string",
      "description": "string",
      "quantity": "number",
      "unit_price": "number",
      "line_total": "number"
    }
  ]
}
```

#### Create Estimate

```
POST /projects/{project_id}/estimates
```

**Request Body:**
```json
{
  "estimate_date": "date",
  "valid_until": "date",
  "subtotal": "number",
  "tax_rate": "number",
  "discount_percentage": "number",
  "notes": "string",
  "terms_conditions": "string",
  "line_items": [
    {
      "service_id": "string",
      "item_type": "string",
      "description": "string",
      "quantity": "number",
      "unit_price": "number"
    }
  ]
}
```

**Response:**
```json
{
  "estimate_id": "string",
  "estimate_number": "string",
  "message": "Estimate created successfully"
}
```

#### Update Estimate

```
PUT /estimates/{estimate_id}
```

**Request Body:**
```json
{
  "estimate_date": "date",
  "valid_until": "date",
  "status": "string",
  "subtotal": "number",
  "tax_rate": "number",
  "discount_percentage": "number",
  "notes": "string",
  "terms_conditions": "string"
}
```

**Response:**
```json
{
  "message": "Estimate updated successfully"
}
```

#### Update Estimate Status

```
PATCH /estimates/{estimate_id}/status
```

**Request Body:**
```json
{
  "status": "string"
}
```

**Response:**
```json
{
  "message": "Estimate status updated successfully"
}
```

### Services

#### Get All Services

```
GET /services
```

**Query Parameters:**
- `category`: Filter by service category
- `active`: Filter by active status (true/false)

**Response:**
```json
{
  "services": [
    {
      "service_id": "string",
      "service_name": "string",
      "service_category": "string",
      "unit_type": "string",
      "default_price": "number",
      "is_active": "boolean"
    }
  ]
}
```

#### Get Service by ID

```
GET /services/{service_id}
```

**Response:**
```json
{
  "service_id": "string",
  "service_name": "string",
  "service_category": "string",
  "description": "string",
  "unit_type": "string",
  "default_price": "number",
  "default_hours": "number",
  "is_active": "boolean",
  "created_at": "datetime",
  "updated_at": "datetime"
}
```

### Materials

#### Get All Materials

```
GET /materials
```

**Query Parameters:**
- `type`: Filter by material type
- `active`: Filter by active status (true/false)
- `search`: Search term

**Response:**
```json
{
  "materials": [
    {
      "material_id": "string",
      "material_name": "string",
      "material_type": "string",
      "brand": "string",
      "default_unit": "string",
      "cost_per_unit": "number",
      "is_active": "boolean"
    }
  ]
}
```

#### Get Project Materials

```
GET /projects/{project_id}/materials
```

**Response:**
```json
{
  "materials": [
    {
      "project_material_id": "string",
      "material_id": "string",
      "material_name": "string",
      "material_type": "string",
      "quantity": "number",
      "unit_cost": "number",
      "total_cost": "number"
    }
  ]
}
```

### Team Members

#### Get All Team Members

```
GET /team-members
```

**Query Parameters:**
- `role`: Filter by role
- `active`: Filter by active status (true/false)

**Response:**
```json
{
  "team_members": [
    {
      "team_member_id": "string",
      "first_name": "string",
      "last_name": "string",
      "email": "string",
      "role": "string",
      "is_active": "boolean"
    }
  ]
}
```

#### Get Team Member Schedule

```
GET /team-members/{team_member_id}/schedule
```

**Query Parameters:**
- `start_date`: Start date for schedule (format: YYYY-MM-DD)
- `end_date`: End date for schedule (format: YYYY-MM-DD)

**Response:**
```json
{
  "events": [
    {
      "event_id": "string",
      "project_id": "string",
      "event_type": "string",
      "title": "string",
      "start_datetime": "datetime",
      "end_datetime": "datetime",
      "location": "string",
      "status": "string"
    }
  ]
}
```

### Schedule

#### Get Project Schedule

```
GET /projects/{project_id}/schedule
```

**Response:**
```json
{
  "events": [
    {
      "event_id": "string",
      "event_type": "string",
      "title": "string",
      "description": "string",
      "start_datetime": "datetime",
      "end_datetime": "datetime",
      "all_day": "boolean",
      "location": "string",
      "team_members": [
        {
          "team_member_id": "string",
          "first_name": "string",
          "last_name": "string",
          "status": "string"
        }
      ]
    }
  ]
}
```

#### Create Schedule Event

```
POST /projects/{project_id}/schedule
```

**Request Body:**
```json
{
  "event_type": "string",
  "title": "string",
  "description": "string",
  "start_datetime": "datetime",
  "end_datetime": "datetime",
  "all_day": "boolean",
  "location": "string",
  "team_member_ids": [
    "string"
  ]
}
```

**Response:**
```json
{
  "event_id": "string",
  "message": "Schedule event created successfully"
}
```

### Tasks

#### Get Project Tasks

```
GET /projects/{project_id}/tasks
```

**Query Parameters:**
- `status`: Filter by task status
- `assigned_to`: Filter by assigned team member

**Response:**
```json
{
  "tasks": [
    {
      "task_id": "string",
      "task_name": "string",
      "status": "string",
      "priority": "string",
      "due_date": "date",
      "assigned_to": {
        "team_member_id": "string",
        "first_name": "string",
        "last_name": "string"
      }
    }
  ]
}
```

#### Create Task

```
POST /projects/{project_id}/tasks
```

**Request Body:**
```json
{
  "task_name": "string",
  "description": "string",
  "status": "string",
  "priority": "string",
  "due_date": "date",
  "assigned_to": "string"
}
```

**Response:**
```json
{
  "task_id": "string",
  "message": "Task created successfully"
}
```

### Invoices

#### Get Project Invoices

```
GET /projects/{project_id}/invoices
```

**Response:**
```json
{
  "invoices": [
    {
      "invoice_id": "string",
      "invoice_number": "string",
      "invoice_date": "date",
      "due_date": "date",
      "status": "string",
      "total": "number",
      "amount_paid": "number",
      "balance": "number"
    }
  ]
}
```

#### Get Invoice by ID

```
GET /invoices/{invoice_id}
```

**Response:**
```json
{
  "invoice_id": "string",
  "project_id": "string",
  "customer_id": "string",
  "invoice_number": "string",
  "invoice_date": "date",
  "due_date": "date",
  "status": "string",
  "subtotal": "number",
  "tax_rate": "number",
  "tax_amount": "number",
  "discount_percentage": "number",
  "discount_amount": "number",
  "total": "number",
  "amount_paid": "number",
  "balance": "number",
  "notes": "string",
  "terms": "string",
  "created_at": "datetime",
  "updated_at": "datetime",
  "payments": [
    {
      "payment_id": "string",
      "payment_date": "date",
      "payment_method": "string",
      "amount": "number",
      "reference_number": "string"
    }
  ]
}
```

#### Generate Invoice from Project

```
POST /projects/{project_id}/invoices
```

**Request Body:**
```json
{
  "invoice_date": "date",
  "due_date": "date",
  "include_materials": "boolean",
  "notes": "string",
  "terms": "string"
}
```

**Response:**
```json
{
  "invoice_id": "string",
  "invoice_number": "string",
  "total": "number",
  "message": "Invoice generated successfully"
}
```

#### Process Payment

```
POST /invoices/{invoice_id}/payments
```

**Request Body:**
```json
{
  "payment_date": "date",
  "payment_method": "string",
  "amount": "number",
  "reference_number": "string",
  "notes": "string"
}
```

**Response:**
```json
{
  "payment_id": "string",
  "new_balance": "number",
  "message": "Payment processed successfully"
}
```

### Reports

#### Financial Summary Report

```
GET /reports/financial-summary
```

**Query Parameters:**
- `start_date`: Start date (format: YYYY-MM-DD)
- `end_date`: End date (format: YYYY-MM-DD)
- `period`: Grouping period (day, week, month, year)

**Response:**
```json
{
  "report_period": {
    "start_date": "date",
    "end_date": "date",
    "period": "string"
  },
  "summary": {
    "total_revenue": "number",
    "collected_revenue": "number",
    "outstanding_revenue": "number",
    "project_count": "integer",
    "average_project_value": "number"
  },
  "periods": [
    {
      "period_start": "date",
      "period_end": "date",
      "revenue": "number",
      "collected": "number",
      "outstanding": "number",
      "project_count": "integer"
    }
  ]
}
```

#### Team Productivity Report

```
GET /reports/team-productivity
```

**Query Parameters:**
- `start_date`: Start date (format: YYYY-MM-DD)
- `end_date`: End date (format: YYYY-MM-DD)
- `team_member_id`: Filter by team member

**Response:**
```json
{
  "report_period": {
    "start_date": "date",
    "end_date": "date"
  },
  "team_members": [
    {
      "team_member_id": "string",
      "name": "string",
      "assigned_projects": "integer",
      "assigned_tasks": "integer",
      "completed_tasks": "integer",
      "total_hours": "number",
      "task_completion_rate": "number"
    }
  ]
}
```

## Error Handling

All endpoints return standard HTTP status codes:

- 200: Success
- 201: Created
- 400: Bad Request
- 401: Unauthorized
- 403: Forbidden
- 404: Not Found
- 500: Server Error

Error responses include a consistent format:

```json
{
  "error": {
    "code": "string",
    "message": "string",
    "details": {}
  }
}
```

## Rate Limiting

API requests are subject to rate limiting:

- 100 requests per minute per user
- 1,000 requests per hour per user

Rate limit headers are included in all responses:

```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1620000000
```

## Versioning

The API uses versioning in the URL path (e.g., `/v1/resource`). When breaking changes are introduced, a new version will be released.

## Pagination

List endpoints support pagination through the `page` and `limit` query parameters:

```
GET /resources?page=2&limit=50
```

Pagination metadata is included in list responses:

```json
{
  "total": 100,
  "page": 2,
  "limit": 50,
  "next_page": 3,
  "prev_page": 1
}
```

## Mobile Considerations

For mobile clients, the API provides:

1. **Reduced Payload Sizes:**
   - Use the `fields` parameter to request only needed fields
   - Example: `/customers?fields=customer_id,first_name,last_name,email`

2. **Batch Operations:**
   - Create multiple resources in a single request
   - Example: `POST /batch/tasks` with an array of tasks

3. **Sync Endpoints:**
   - Optimize for offline-first mobile apps
   - Example: `GET /sync?since=timestamp` to get changes since last sync

## Webhooks

The API supports webhooks for event notifications:

```
POST /webhooks
```

**Request Body:**
```json
{
  "url": "string",
  "events": [
    "customer.created",
    "project.status_changed",
    "invoice.paid"
  ],
  "secret": "string"
}
```

When events occur, the system sends a POST request to the registered URL with event data.
