-- ============================================================================
-- RegIntel Copilot: 13_cleanup.sql
-- Drops ALL project objects. DO NOT EXECUTE unless you want a full reset.
-- ============================================================================

-- Run as ACCOUNTADMIN to clean up everything
-- USE ROLE ACCOUNTADMIN;

-- Drop database (cascades all schemas, tables, views, procedures)
-- DROP DATABASE IF EXISTS REGINTEL;

-- Drop roles
-- DROP ROLE IF EXISTS REGINTEL_APP_ROLE;
-- DROP ROLE IF EXISTS REGINTEL_EXECUTIVE_VIEWER;
-- DROP ROLE IF EXISTS REGINTEL_COMPLIANCE_REVIEWER;
-- DROP ROLE IF EXISTS REGINTEL_ANALYST;
-- DROP ROLE IF EXISTS REGINTEL_ENGINEER;
-- DROP ROLE IF EXISTS REGINTEL_ADMIN;

-- NOTE: Uncomment the statements above to execute cleanup.
-- This will permanently destroy all project data and objects.
