-- =============================================================================
-- TEST SUITE: Cortex Integration Tests
-- Database: REGINTEL
-- Description: Validates Cortex AI functions, search services, semantic views,
--              procedures, and Streamlit app existence.
-- =============================================================================

USE DATABASE REGINTEL;
USE SCHEMA PUBLIC;

-- Cortex COMPLETE returns non-empty output
SELECT 'CORTEX_COMPLETE_WORKS' AS test_name,
       CASE WHEN LEN(response) > 0 THEN 'PASS' ELSE 'FAIL' END AS status,
       'Response length: ' || LEN(response)::STRING || ' chars' AS details
  FROM (SELECT SNOWFLAKE.CORTEX.COMPLETE('llama3.1-8b', 'Say hello') AS response)

UNION ALL

-- Cortex Search service POLICY_SEARCH_SVC exists
-- NOTE: Run separately: SHOW CORTEX SEARCH SERVICES IN SCHEMA PUBLIC;
-- Then verify POLICY_SEARCH_SVC appears and is ACTIVE.
-- Inline check via INFORMATION_SCHEMA (best-effort):
SELECT 'CORTEX_SEARCH_SVC_EXISTS',
       CASE WHEN cnt > 0 THEN 'PASS' ELSE 'FAIL' END,
       CASE WHEN cnt > 0 THEN 'POLICY_SEARCH_SVC found' ELSE 'POLICY_SEARCH_SVC not found (verify with SHOW CORTEX SEARCH SERVICES)' END
  FROM (SELECT COUNT(*) AS cnt
          FROM INFORMATION_SCHEMA.SERVICES
         WHERE SERVICE_NAME = 'POLICY_SEARCH_SVC')

UNION ALL

-- Policy chunks: 22 rows in POLICY_CHUNKS
SELECT 'POLICY_CHUNKS_COUNT',
       CASE WHEN cnt = 22 THEN 'PASS' ELSE 'FAIL' END,
       'Expected 22 rows in POLICY_CHUNKS, got ' || cnt::STRING
  FROM (SELECT COUNT(*) AS cnt FROM POLICY_CHUNKS)

UNION ALL

-- Policy documents: 4 rows in POLICY_DOCUMENTS
SELECT 'POLICY_DOCUMENTS_COUNT',
       CASE WHEN cnt = 4 THEN 'PASS' ELSE 'FAIL' END,
       'Expected 4 rows in POLICY_DOCUMENTS, got ' || cnt::STRING
  FROM (SELECT COUNT(*) AS cnt FROM POLICY_DOCUMENTS)

UNION ALL

-- Semantic view REGINTEL_SEMANTIC_VIEW exists
SELECT 'SEMANTIC_VIEW_EXISTS',
       CASE WHEN cnt > 0 THEN 'PASS' ELSE 'FAIL' END,
       CASE WHEN cnt > 0 THEN 'REGINTEL_SEMANTIC_VIEW found' ELSE 'REGINTEL_SEMANTIC_VIEW NOT found' END
  FROM (SELECT COUNT(*) AS cnt
          FROM INFORMATION_SCHEMA.VIEWS
         WHERE TABLE_NAME = 'REGINTEL_SEMANTIC_VIEW'
           AND TABLE_SCHEMA = 'PUBLIC')

UNION ALL

-- Procedure COPILOT_ASK exists
SELECT 'PROC_COPILOT_ASK_EXISTS',
       CASE WHEN cnt > 0 THEN 'PASS' ELSE 'FAIL' END,
       CASE WHEN cnt > 0 THEN 'COPILOT_ASK procedure found' ELSE 'COPILOT_ASK procedure NOT found' END
  FROM (SELECT COUNT(*) AS cnt
          FROM INFORMATION_SCHEMA.PROCEDURES
         WHERE PROCEDURE_NAME = 'COPILOT_ASK'
           AND PROCEDURE_SCHEMA = 'PUBLIC')

UNION ALL

-- Procedure GENERATE_FINDING_NARRATIVE exists
SELECT 'PROC_GENERATE_FINDING_NARRATIVE_EXISTS',
       CASE WHEN cnt > 0 THEN 'PASS' ELSE 'FAIL' END,
       CASE WHEN cnt > 0 THEN 'GENERATE_FINDING_NARRATIVE procedure found' ELSE 'GENERATE_FINDING_NARRATIVE procedure NOT found' END
  FROM (SELECT COUNT(*) AS cnt
          FROM INFORMATION_SCHEMA.PROCEDURES
         WHERE PROCEDURE_NAME = 'GENERATE_FINDING_NARRATIVE'
           AND PROCEDURE_SCHEMA = 'PUBLIC')

UNION ALL

-- Streamlit REGINTEL_COPILOT exists
SELECT 'STREAMLIT_EXISTS',
       CASE WHEN cnt > 0 THEN 'PASS' ELSE 'FAIL' END,
       CASE WHEN cnt > 0 THEN 'REGINTEL_COPILOT Streamlit found' ELSE 'REGINTEL_COPILOT Streamlit NOT found' END
  FROM (SELECT COUNT(*) AS cnt
          FROM INFORMATION_SCHEMA.STREAMLITS
         WHERE STREAMLIT_NAME = 'REGINTEL_COPILOT')

ORDER BY test_name;
