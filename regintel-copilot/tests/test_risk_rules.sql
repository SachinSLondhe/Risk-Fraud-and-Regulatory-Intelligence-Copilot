-- =============================================================================
-- TEST SUITE: Risk Rules & Alert Tests
-- Database: REGINTEL
-- Description: Validates risk rule catalog, alert generation, scoring, evidence,
--              and deduplication.
-- =============================================================================

USE DATABASE REGINTEL;
USE SCHEMA PUBLIC;

-- All 9 rules exist in RISK_RULES
SELECT 'ALL_RULES_EXIST' AS test_name,
       CASE WHEN rule_cnt = 9 THEN 'PASS' ELSE 'FAIL' END AS status,
       'Expected 9 rules, found ' || rule_cnt::STRING AS details
  FROM (SELECT COUNT(DISTINCT RULE_ID) AS rule_cnt
          FROM RISK_RULES
         WHERE RULE_ID IN ('AML_001','AML_002','AML_003','AML_004',
                           'FRD_001','FRD_002','FRD_003',
                           'CRD_001','LIQ_001'))

UNION ALL

-- AML_001 fires at least once
SELECT 'ALERT_COUNT_AML_001',
       CASE WHEN cnt > 0 THEN 'PASS' ELSE 'FAIL' END,
       cnt::STRING || ' alerts for AML_001'
  FROM (SELECT COUNT(*) AS cnt FROM ALERTS WHERE RULE_ID = 'AML_001')

UNION ALL

-- AML_002 fires at least once
SELECT 'ALERT_COUNT_AML_002',
       CASE WHEN cnt > 0 THEN 'PASS' ELSE 'FAIL' END,
       cnt::STRING || ' alerts for AML_002'
  FROM (SELECT COUNT(*) AS cnt FROM ALERTS WHERE RULE_ID = 'AML_002')

UNION ALL

-- AML_003 fires at least once
SELECT 'ALERT_COUNT_AML_003',
       CASE WHEN cnt > 0 THEN 'PASS' ELSE 'FAIL' END,
       cnt::STRING || ' alerts for AML_003'
  FROM (SELECT COUNT(*) AS cnt FROM ALERTS WHERE RULE_ID = 'AML_003')

UNION ALL

-- AML_004 fires at least once
SELECT 'ALERT_COUNT_AML_004',
       CASE WHEN cnt > 0 THEN 'PASS' ELSE 'FAIL' END,
       cnt::STRING || ' alerts for AML_004'
  FROM (SELECT COUNT(*) AS cnt FROM ALERTS WHERE RULE_ID = 'AML_004')

UNION ALL

-- FRD_001 fires at least once
SELECT 'ALERT_COUNT_FRD_001',
       CASE WHEN cnt > 0 THEN 'PASS' ELSE 'FAIL' END,
       cnt::STRING || ' alerts for FRD_001'
  FROM (SELECT COUNT(*) AS cnt FROM ALERTS WHERE RULE_ID = 'FRD_001')

UNION ALL

-- FRD_002 fires at least once
SELECT 'ALERT_COUNT_FRD_002',
       CASE WHEN cnt > 0 THEN 'PASS' ELSE 'FAIL' END,
       cnt::STRING || ' alerts for FRD_002'
  FROM (SELECT COUNT(*) AS cnt FROM ALERTS WHERE RULE_ID = 'FRD_002')

UNION ALL

-- FRD_003 fires at least once
SELECT 'ALERT_COUNT_FRD_003',
       CASE WHEN cnt > 0 THEN 'PASS' ELSE 'FAIL' END,
       cnt::STRING || ' alerts for FRD_003'
  FROM (SELECT COUNT(*) AS cnt FROM ALERTS WHERE RULE_ID = 'FRD_003')

UNION ALL

-- CRD_001 fires at least once
SELECT 'ALERT_COUNT_CRD_001',
       CASE WHEN cnt > 0 THEN 'PASS' ELSE 'FAIL' END,
       cnt::STRING || ' alerts for CRD_001'
  FROM (SELECT COUNT(*) AS cnt FROM ALERTS WHERE RULE_ID = 'CRD_001')

UNION ALL

-- LIQ_001 fires at least once
SELECT 'ALERT_COUNT_LIQ_001',
       CASE WHEN cnt > 0 THEN 'PASS' ELSE 'FAIL' END,
       cnt::STRING || ' alerts for LIQ_001'
  FROM (SELECT COUNT(*) AS cnt FROM ALERTS WHERE RULE_ID = 'LIQ_001')

UNION ALL

-- Every alert has RISK_SCORE between 0 and 100
SELECT 'ALERT_RISK_SCORE_RANGE',
       CASE WHEN bad_cnt = 0 THEN 'PASS' ELSE 'FAIL' END,
       bad_cnt::STRING || ' alerts with RISK_SCORE outside 0-100'
  FROM (SELECT COUNT(*) AS bad_cnt FROM ALERTS WHERE RISK_SCORE < 0 OR RISK_SCORE > 100)

UNION ALL

-- Every alert references a valid RULE_ID + RULE_VERSION in RISK_RULES
SELECT 'ALERT_VALID_RULE_REFERENCE',
       CASE WHEN orphan_cnt = 0 THEN 'PASS' ELSE 'FAIL' END,
       orphan_cnt::STRING || ' alerts reference non-existent RULE_ID/RULE_VERSION'
  FROM (SELECT COUNT(*) AS orphan_cnt
          FROM ALERTS a
          LEFT JOIN RISK_RULES r ON a.RULE_ID = r.RULE_ID AND a.RULE_VERSION = r.RULE_VERSION
         WHERE r.RULE_ID IS NULL)

UNION ALL

-- Every alert has a non-empty EXPLANATION
SELECT 'ALERT_HAS_EXPLANATION',
       CASE WHEN empty_cnt = 0 THEN 'PASS' ELSE 'FAIL' END,
       empty_cnt::STRING || ' alerts with NULL or empty EXPLANATION'
  FROM (SELECT COUNT(*) AS empty_cnt
          FROM ALERTS
         WHERE EXPLANATION IS NULL OR TRIM(EXPLANATION) = '')

UNION ALL

-- Evidence records exist (ALERT_EVIDENCE count > 0)
SELECT 'ALERT_EVIDENCE_EXISTS',
       CASE WHEN cnt > 0 THEN 'PASS' ELSE 'FAIL' END,
       cnt::STRING || ' rows in ALERT_EVIDENCE'
  FROM (SELECT COUNT(*) AS cnt FROM ALERT_EVIDENCE)

UNION ALL

-- No duplicate alerts for same ACCOUNT_ID + RULE_ID combination
SELECT 'NO_DUPLICATE_ALERTS',
       CASE WHEN dup_cnt = 0 THEN 'PASS' ELSE 'FAIL' END,
       dup_cnt::STRING || ' duplicate ACCOUNT_ID+RULE_ID combinations in ALERTS'
  FROM (SELECT COUNT(*) AS dup_cnt
          FROM (SELECT ACCOUNT_ID, RULE_ID
                  FROM ALERTS
                 GROUP BY ACCOUNT_ID, RULE_ID
                HAVING COUNT(*) > 1))

ORDER BY test_name;
