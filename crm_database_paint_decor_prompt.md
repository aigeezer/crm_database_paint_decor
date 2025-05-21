# CRM Database for Painting and Decorating Companies

<s>
I am a database architecture expert with 15+ years experience designing CRM systems for specialized trade industries. I specialize in creating scalable, industry-specific database solutions that connect business workflows with data management.
</s>

<instruction>
Design a comprehensive CRM database system for painting and decorating companies that handles the complete business workflow from lead generation to project completion and follow-up.

<requirements>
- Create a normalized relational database schema with appropriate tables and relationships
- Include all necessary entities for the painting/decorating business workflow
- Design a system that manages leads, estimates, projects, clients, properties, scheduling, crews, materials, and finances
- Ensure the structure is optimized for both office staff and mobile field crews
- Include documentation on integration with accounting systems and estimating tools
- Provide security considerations for protecting sensitive customer and business data
</requirements>

<workspace>
This prompt will use the directory structure at /Users/tony/crm_database_paint_decor/ for all file operations:
- Database schema files in /Users/tony/crm_database_paint_decor/schema/
- SQL implementation in /Users/tony/crm_database_paint_decor/sql/
- Documentation in /Users/tony/crm_database_paint_decor/docs/
- API endpoints in /Users/tony/crm_database_paint_decor/api/
</workspace>

<continuity_resources>
- GitHub Repository: https://github.com/aigeezer/crm_database_paint_decor
- Todoist Project: 
  * Project ID: 2354150782
  * Direct URL: https://app.todoist.com/app/project/6c3MRp8FgWxghVcm
  * Access: Open the URL or search for "CRM Database - Paint & Decor" in your Todoist app
  * Contains: Implementation tasks, documentation tasks, and testing milestones
- Project Plan: /Users/tony/crm_database_paint_decor/project_plan.md
- Knowledge Graph Entities: PaintDecorCRM, ClientManagement, ProjectWorkflow, MaterialTracking

To continue work on this project in a future session, use one of these approaches:
1. Upload the original prompt file (crm_database_paint_decor_prompt.md) to a new chat
2. Say: "Continue working on the CRM database for painting and decorating companies based on project_plan.md"
3. Provide the path to STATUS.md: "Please continue the CRM project by reviewing /Users/tony/crm_database_paint_decor/STATUS.md"
</continuity_resources>

Please structure your response with these key sections:

1. **Business Process Analysis**
   - Identify key workflows for painting and decorating businesses
   - Map data requirements to each business process
   - Document integration touchpoints with other systems

2. **Core Database Schema Design**
   - Entity-Relationship Diagram (ERD)
   - Table definitions with fields, data types, and constraints
   - Relationship mappings with cardinality
   - Indexing strategy for performance optimization

3. **Key Entity Specifications**
   - Client/Customer management
   - Property/Location tracking
   - Project and job management
   - Estimate and quote generation
   - Scheduling and resource allocation
   - Material inventory and cost tracking
   - Crew management and scheduling
   - Financial transactions and reporting

4. **Implementation Guidelines**
   - SQL creation scripts
   - Security recommendations
   - Integration strategies with accounting and estimating tools
   - Mobile access considerations
   - Data migration approach for existing businesses

Think step by step about the unique needs of painting and decorating businesses, considering seasonal fluctuations, project complexity variations, and the balance between office and field operations.
</instruction>

## Key Entity Structure

### 1. Core Entities

#### Customers
- Customer information and contact details
- Customer classification (residential, commercial)
- Customer preferences and history
- Multiple properties/locations

#### Properties
- Detailed property information
- Building characteristics relevant to painting/decorating
- Access instructions and limitations
- Historical work record

#### Projects
- Project specifications and requirements
- Scope of work
- Timeline and scheduling
- Status tracking
- Quality control checkpoints

#### Estimates
- Detailed line items
- Material specifications
- Labor calculations
- Pricing formulas
- Approval workflow

#### Services
- Service types and categories
- Standard pricing models
- Required skills and certifications
- Expected duration metrics

### 2. Operational Entities

#### Materials
- Paint, wallpaper, and supply inventory
- Supplier relationships
- Cost tracking
- Usage allocation by project

#### Crew Members
- Employee information
- Skills and certifications
- Availability and scheduling
- Performance metrics

#### Schedule
- Calendar integration
- Resource allocation
- Milestone tracking
- Weather dependencies

#### Tasks
- Task assignments
- Completion tracking
- Quality control checks
- Follow-up actions

### 3. Financial Entities

#### Invoices
- Billing information
- Payment tracking
- Partial payments
- Terms and conditions

#### Expenses
- Material costs
- Labor costs
- Overhead allocation
- Profitability analysis

#### Transactions
- Payment processing
- Refund handling
- Accounting system integration
- Financial reporting

## Success Criteria

The CRM database will be considered successful if it:

1. Captures all essential data points in the painting/decorating business workflow
2. Maintains data integrity through proper relationships and constraints
3. Supports efficient data retrieval for common operational queries
4. Facilitates integration with estimating, scheduling, and accounting systems
5. Provides a foundation for both reporting and operational processes
6. Incorporates industry-specific requirements like seasonal scheduling
7. Supports field operations through mobile-friendly data structures
8. Includes proper security measures for sensitive customer and financial data
