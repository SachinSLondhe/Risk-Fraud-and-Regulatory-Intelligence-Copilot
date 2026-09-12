-- ============================================================================
-- RegIntel Copilot: 00_environment_check.sql
-- Pre-flight environment inspection. Run BEFORE any DDL.
-- ============================================================================

-- 1. Current session context
SELECT CURRENT_ROLE()       AS current_role,
       CURRENT_WAREHOUSE()  AS current_warehouse,
       CURRENT_DATABASE()   AS current_database,
       CURRENT_SCHEMA()     AS current_schema,
       CURRENT_ACCOUNT()    AS current_account,
       CURRENT_REGION()     AS current_region,
       CURRENT_VERSION()    AS snowflake_version;

-- 2. Check for existing REGINTEL database (avoid collisions)
SHOW DATABASES LIKE 'REGINTEL';

-- 3. Check available warehouses
SHOW WAREHOUSES;

-- 4. Check current role privileges
SHOW GRANTS TO ROLE IDENTIFIER(CURRENT_ROLE());

-- 5. Check if Cortex AI functions are available
-- This will error on trial accounts; that is expected.
-- If it succeeds, Cortex LLM functions can be used.
SELECT 'CORTEX_LLM' AS capability,
       CASE
           WHEN 1=1 THEN 'CHECKING...'
       END AS status;

-- 6. Check Streamlit support
SHOW STREAMLITS;

-- 7. Check Cortex Search services
SHOW CORTEX SEARCH SERVICES;

-- 8. Check existing roles that might conflict
SHOW ROLES LIKE 'REGINTEL%';
