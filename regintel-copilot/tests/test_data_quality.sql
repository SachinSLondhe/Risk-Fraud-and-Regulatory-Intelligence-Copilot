-- =============================================================================
-- TEST SUITE: Data Quality Tests
-- Database: REGINTEL
-- Description: Validates row counts, uniqueness, referential integrity, and
--              value constraints across core tables.
-- =============================================================================

USE DATABASE REGINTEL;
USE SCHEMA PUBLIC;

-- Row count: CUSTOMERS = 500
SELECT 'ROW_COUNT_CUSTOMERS' AS test_name,
       CASE WHEN cnt = 500 THEN 'PASS' ELSE 'FAIL' END AS status,
       'Expected 500, got ' || cnt::STRING AS details
  FROM (SELECT COUNT(*) AS cnt FROM CUSTOMERS)

UNION ALL

-- Row count: ACCOUNTS = 700
SELECT 'ROW_COUNT_ACCOUNTS',
       CASE WHEN cnt = 700 THEN 'PASS' ELSE 'FAIL' END,
       'Expected 700, got ' || cnt::STRING
  FROM (SELECT COUNT(*) AS cnt FROM ACCOUNTS)

UNION ALL

-- Row count: TRANSACTIONS > 40000
SELECT 'ROW_COUNT_TRANSACTIONS',
       CASE WHEN cnt > 40000 THEN 'PASS' ELSE 'FAIL' END,
       'Expected >40000, got ' || cnt::STRING
  FROM (SELECT COUNT(*) AS cnt FROM TRANSACTIONS)

UNION ALL

-- Row count: ACCOUNT_DAILY_BALANCE > 50000
SELECT 'ROW_COUNT_ACCOUNT_DAILY_BALANCE',
       CASE WHEN cnt > 50000 THEN 'PASS' ELSE 'FAIL' END,
       'Expected >50000, got ' || cnt::STRING
  FROM (SELECT COUNT(*) AS cnt FROM ACCOUNT_DAILY_BALANCE)

UNION ALL

-- Unique IDs: no duplicate CUSTOMER_ID
SELECT 'UNIQUE_CUSTOMER_ID',
       CASE WHEN dup_cnt = 0 THEN 'PASS' ELSE 'FAIL' END,
       dup_cnt::STRING || ' duplicate CUSTOMER_ID values found'
  FROM (SELECT COUNT(*) AS dup_cnt
          FROM (SELECT CUSTOMER_ID FROM CUSTOMERS GROUP BY CUSTOMER_ID HAVING COUNT(*) > 1))

UNION ALL

-- Unique IDs: no duplicate ACCOUNT_ID
SELECT 'UNIQUE_ACCOUNT_ID',
       CASE WHEN dup_cnt = 0 THEN 'PASS' ELSE 'FAIL' END,
       dup_cnt::STRING || ' duplicate ACCOUNT_ID values found'
  FROM (SELECT COUNT(*) AS dup_cnt
          FROM (SELECT ACCOUNT_ID FROM ACCOUNTS GROUP BY ACCOUNT_ID HAVING COUNT(*) > 1))

UNION ALL

-- Unique IDs: no duplicate TRANSACTION_ID
SELECT 'UNIQUE_TRANSACTION_ID',
       CASE WHEN dup_cnt = 0 THEN 'PASS' ELSE 'FAIL' END,
       dup_cnt::STRING || ' duplicate TRANSACTION_ID values found'
  FROM (SELECT COUNT(*) AS dup_cnt
          FROM (SELECT TRANSACTION_ID FROM TRANSACTIONS GROUP BY TRANSACTION_ID HAVING COUNT(*) > 1))

UNION ALL

-- Required fields: no NULL CUSTOMER_ID in CUSTOMERS
SELECT 'NOT_NULL_CUSTOMER_ID',
       CASE WHEN null_cnt = 0 THEN 'PASS' ELSE 'FAIL' END,
       null_cnt::STRING || ' NULL CUSTOMER_ID rows in CUSTOMERS'
  FROM (SELECT COUNT(*) AS null_cnt FROM CUSTOMERS WHERE CUSTOMER_ID IS NULL)

UNION ALL

-- Required fields: no NULL ACCOUNT_ID in ACCOUNTS
SELECT 'NOT_NULL_ACCOUNT_ID',
       CASE WHEN null_cnt = 0 THEN 'PASS' ELSE 'FAIL' END,
       null_cnt::STRING || ' NULL ACCOUNT_ID rows in ACCOUNTS'
  FROM (SELECT COUNT(*) AS null_cnt FROM ACCOUNTS WHERE ACCOUNT_ID IS NULL)

UNION ALL

-- Required fields: no NULL TRANSACTION_ID in TRANSACTIONS
SELECT 'NOT_NULL_TRANSACTION_ID',
       CASE WHEN null_cnt = 0 THEN 'PASS' ELSE 'FAIL' END,
       null_cnt::STRING || ' NULL TRANSACTION_ID rows in TRANSACTIONS'
  FROM (SELECT COUNT(*) AS null_cnt FROM TRANSACTIONS WHERE TRANSACTION_ID IS NULL)

UNION ALL

-- RISK_SCORE between 0 and 100 in CUSTOMERS
SELECT 'RISK_SCORE_RANGE',
       CASE WHEN bad_cnt = 0 THEN 'PASS' ELSE 'FAIL' END,
       bad_cnt::STRING || ' CUSTOMERS with RISK_SCORE outside 0-100'
  FROM (SELECT COUNT(*) AS bad_cnt FROM CUSTOMERS WHERE RISK_SCORE < 0 OR RISK_SCORE > 100)

UNION ALL

-- Referential integrity: every ACCOUNT.CUSTOMER_ID exists in CUSTOMERS
SELECT 'FK_ACCOUNT_CUSTOMER',
       CASE WHEN orphan_cnt = 0 THEN 'PASS' ELSE 'FAIL' END,
       orphan_cnt::STRING || ' ACCOUNTS reference non-existent CUSTOMER_ID'
  FROM (SELECT COUNT(*) AS orphan_cnt
          FROM ACCOUNTS a
          LEFT JOIN CUSTOMERS c ON a.CUSTOMER_ID = c.CUSTOMER_ID
         WHERE c.CUSTOMER_ID IS NULL)

UNION ALL

-- Referential integrity: every TRANSACTION.ACCOUNT_ID exists in ACCOUNTS
SELECT 'FK_TRANSACTION_ACCOUNT',
       CASE WHEN orphan_cnt = 0 THEN 'PASS' ELSE 'FAIL' END,
       orphan_cnt::STRING || ' TRANSACTIONS reference non-existent ACCOUNT_ID'
  FROM (SELECT COUNT(*) AS orphan_cnt
          FROM TRANSACTIONS t
          LEFT JOIN ACCOUNTS a ON t.ACCOUNT_ID = a.ACCOUNT_ID
         WHERE a.ACCOUNT_ID IS NULL)

UNION ALL

-- Amount validity: all TRANSACTION.AMOUNT > 0
SELECT 'POSITIVE_TRANSACTION_AMOUNT',
       CASE WHEN bad_cnt = 0 THEN 'PASS' ELSE 'FAIL' END,
       bad_cnt::STRING || ' TRANSACTIONS with AMOUNT <= 0'
  FROM (SELECT COUNT(*) AS bad_cnt FROM TRANSACTIONS WHERE AMOUNT <= 0)

UNION ALL

-- All 10 scenarios exist in SCENARIO_VALIDATION (S01-S10)
SELECT 'SCENARIO_VALIDATION_COMPLETE',
       CASE WHEN scenario_cnt = 10 THEN 'PASS' ELSE 'FAIL' END,
       'Expected 10 scenarios (S01-S10), found ' || scenario_cnt::STRING
  FROM (SELECT COUNT(DISTINCT SCENARIO_ID) AS scenario_cnt
          FROM SCENARIO_VALIDATION
         WHERE SCENARIO_ID IN ('S01','S02','S03','S04','S05','S06','S07','S08','S09','S10'))

ORDER BY test_name;
