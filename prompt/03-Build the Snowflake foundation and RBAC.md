Create the Snowflake environment scripts for RegIntel Copilot.

Recommended logical objects:
- Database: REGINTEL
- Schemas:
  - RAW
  - CURATED
  - POLICY
  - RISK
  - CASE_MGMT
  - AUDIT
  - APP

Recommended roles:
- REGINTEL_ADMIN
- REGINTEL_ENGINEER
- REGINTEL_ANALYST
- REGINTEL_COMPLIANCE_REVIEWER
- REGINTEL_EXECUTIVE_VIEWER
- REGINTEL_APP_ROLE

Requirements:
1. Generate 00_environment_check.sql to inspect current database privileges,
   role, warehouse, Cortex availability, Streamlit support, and existing
   object-name conflicts.
2. Generate 01_roles_and_database.sql using least privilege.
3. Do not execute ACCOUNTADMIN-level grants automatically.
4. Clearly separate statements that need an administrator.
5. Do not grant broad ownership or ALL PRIVILEGES unnecessarily.
6. Grant business users access only to curated views, alerts, evidence,
   approved findings, and reports.
7. Restrict raw synthetic customer details to engineering and approved
   compliance roles.
8. Make warehouse and role names configurable.
9. Add comments to every database, schema, role, table, and view.
10. Include rollback statements in 13_cleanup.sql, but do not execute them.
11. Validate all generated SQL for syntax and object dependency order.

After generating the scripts:
- Show the privilege matrix.
- Identify statements requiring elevated permissions.
- Do not execute elevated statements.