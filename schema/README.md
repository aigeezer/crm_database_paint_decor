# Entity-Relationship Diagram (ERD)

This folder contains the Entity-Relationship Diagram for the CRM Database for Painting and Decorating Companies.

## File Description

- `erd.puml`: PlantUML file containing the database schema diagram definition

## How to Use

To generate a visual diagram from the PlantUML file:

1. Install PlantUML (https://plantuml.com/starting)
2. Run the following command:
   ```
   plantuml erd.puml
   ```
3. This will generate an `erd.png` file with the visual diagram

## Alternative Online Visualization

You can also use online PlantUML renderers:

1. Visit https://www.planttext.com/ or https://plantuml.com/plantuml/
2. Copy the contents of the `erd.puml` file
3. Paste into the editor
4. The visual diagram will be generated automatically

## Diagram Description

The ERD includes all major entities in the CRM database system with their relationships:

- Customer and Property Management
- Project and Estimate Handling
- Material and Inventory Tracking
- Team Member Management
- Scheduling and Task Assignment
- Financial Records (Invoices and Payments)
- Communication History

Each entity includes its attributes with data types and indicates primary and foreign keys.
