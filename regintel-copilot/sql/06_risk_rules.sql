-- ============================================================================
-- RegIntel Copilot: 06_risk_rules.sql
-- Versioned risk rules and combined alert candidate view.
-- ============================================================================

USE ROLE REGINTEL_ADMIN;
USE DATABASE REGINTEL;
USE WAREHOUSE COMPUTE_WH;

-- -------------------------------------------------------
-- Seed risk rules
-- -------------------------------------------------------
INSERT INTO RISK.RISK_RULES (RULE_ID, RULE_NAME, RISK_DOMAIN, RULE_DESCRIPTION, RULE_VERSION,
    SEVERITY, THRESHOLD_CONFIG, EFFECTIVE_FROM, ACTIVE_FLAG, POLICY_REFERENCE)
VALUES
    ('AML_001', 'Structuring Detection', 'AML',
     'Detects repeated transactions just below a configurable threshold within a rolling window.',
     1, 'HIGH', PARSE_JSON('{"threshold_amount": 50000, "min_txn_count": 3, "window_days": 7, "lower_bound": 45000}'),
     '2026-01-01', TRUE, 'POL-AML-001 S3.1'),

    ('AML_002', 'Rapid Movement of Funds', 'AML',
     'Detects large credits followed by outbound transfers within configurable hours.',
     1, 'HIGH', PARSE_JSON('{"min_credit_amount": 100000, "max_hours_between": 24, "min_pct_moved": 50}'),
     '2026-01-01', TRUE, 'POL-AML-001 S3.2'),

    ('AML_003', 'Dormant Account Reactivation', 'AML',
     'Detects significant activity on accounts that were dormant for extended periods.',
     1, 'MEDIUM', PARSE_JSON('{"min_dormant_days": 60, "min_reactivation_amount": 500000}'),
     '2026-01-01', TRUE, 'POL-AML-001 S3.3'),

    ('AML_004', 'Unusual Transaction Geography', 'AML',
     'Detects transactions from/to countries inconsistent with account history.',
     1, 'MEDIUM', PARSE_JSON('{"max_normal_countries": 3, "min_amount": 50000}'),
     '2026-01-01', TRUE, 'POL-AML-001 S3.4'),

    ('FRD_001', 'Transaction Velocity Anomaly', 'FRAUD',
     'Detects unusually high transaction frequency within short time windows.',
     1, 'HIGH', PARSE_JSON('{"max_txn_per_hour": 10, "window_hours": 1}'),
     '2026-01-01', TRUE, 'POL-TXM-001 S2.1'),

    ('FRD_002', 'New Device High Value', 'FRAUD',
     'Detects high-value transactions from devices not previously seen for the account.',
     1, 'MEDIUM', PARSE_JSON('{"min_amount": 100000, "device_lookback_days": 90}'),
     '2026-01-01', TRUE, 'POL-TXM-001 S2.2'),

    ('FRD_003', 'Potential Mule Account', 'FRAUD',
     'Detects accounts receiving from multiple sources then quickly moving funds out.',
     1, 'HIGH', PARSE_JSON('{"min_credit_sources": 3, "min_pct_moved_out": 70, "window_days": 7}'),
     '2026-01-01', TRUE, 'POL-TXM-001 S2.3'),

    ('CRD_001', 'Sudden Credit Utilization', 'CREDIT',
     'Detects rapid increase in credit utilization percentage.',
     1, 'MEDIUM', PARSE_JSON('{"max_utilization_pct": 80, "min_increase_pct": 50}'),
     '2026-01-01', TRUE, 'POL-CRD-001 S2.1'),

    ('LIQ_001', 'Sustained Liquidity Decline', 'LIQUIDITY',
     'Detects material decline in closing balance over consecutive days.',
     1, 'HIGH', PARSE_JSON('{"min_decline_pct": 50, "window_days": 7}'),
     '2026-01-01', TRUE, 'POL-LIQ-001 S2.1');

-- -------------------------------------------------------
-- Combined Alert Candidates View
-- -------------------------------------------------------
CREATE OR REPLACE VIEW RISK.V_ALERT_CANDIDATES AS

-- AML_001: Structuring
SELECT
    'AML_001' AS RULE_ID, 1 AS RULE_VERSION, 'AML' AS RISK_DOMAIN,
    'Structuring Detection' AS RULE_NAME,
    S.ACCOUNT_ID,
    A.CUSTOMER_ID,
    S.TRANSACTION_IDS[0]::VARCHAR AS PRIMARY_TRANSACTION_ID,
    ROUND(LEAST(S.TXN_COUNT_NEAR_THRESHOLD * 15.0, 100), 2) AS RISK_SCORE,
    'HIGH' AS SEVERITY,
    S.TXN_COUNT_NEAR_THRESHOLD AS OBSERVED_VALUE,
    '3' AS THRESHOLD_VALUE,
    'Risk signal detected: ' || S.TXN_COUNT_NEAR_THRESHOLD || ' transactions between 45000-49999 in 7 days (threshold: 3). Total: ' || S.TOTAL_NEAR_THRESHOLD AS EXPLANATION,
    'POL-AML-001 S3.1' AS POLICY_REFERENCE,
    CURRENT_TIMESTAMP() AS EVAL_TIMESTAMP
FROM RISK.V_FEAT_STRUCTURING S
JOIN RAW.ACCOUNTS A ON S.ACCOUNT_ID = A.ACCOUNT_ID

UNION ALL

-- AML_002: Rapid movement
SELECT
    'AML_002', 1, 'AML', 'Rapid Movement of Funds',
    R.ACCOUNT_ID, AC.CUSTOMER_ID, R.CREDIT_TXN_ID,
    ROUND(LEAST(R.PCT_MOVED * 0.8, 100), 2),
    'HIGH',
    R.PCT_MOVED, '50',
    'Risk signal detected: ' || R.PCT_MOVED || '% of incoming ' || R.CREDIT_AMOUNT || ' moved out within ' || R.MINUTES_BETWEEN || ' minutes',
    'POL-AML-001 S3.2',
    CURRENT_TIMESTAMP()
FROM RISK.V_FEAT_RAPID_MOVEMENT R
JOIN RAW.ACCOUNTS AC ON R.ACCOUNT_ID = AC.ACCOUNT_ID
WHERE R.PCT_MOVED >= 30
QUALIFY ROW_NUMBER() OVER (PARTITION BY R.ACCOUNT_ID, R.CREDIT_TXN_ID ORDER BY R.PCT_MOVED DESC) = 1

UNION ALL

-- AML_003: Dormant reactivation
SELECT
    'AML_003', 1, 'AML', 'Dormant Account Reactivation',
    D.ACCOUNT_ID, AC.CUSTOMER_ID, NULL,
    ROUND(LEAST(D.DORMANT_DAYS * 0.5, 100), 2),
    'MEDIUM',
    D.DORMANT_DAYS, '60',
    'Risk signal detected: Dormant account (' || D.DORMANT_DAYS || ' days inactive) reactivated with new transactions',
    'POL-AML-001 S3.3',
    CURRENT_TIMESTAMP()
FROM RISK.V_FEAT_DORMANCY D
JOIN RAW.ACCOUNTS AC ON D.ACCOUNT_ID = AC.ACCOUNT_ID
WHERE D.DORMANT_DAYS >= 60

UNION ALL

-- AML_004: Unusual geography
SELECT
    'AML_004', 1, 'AML', 'Unusual Transaction Geography',
    DC.ACCOUNT_ID, AC.CUSTOMER_ID, NULL,
    ROUND(LEAST(DC.DISTINCT_DEST_COUNTRIES_30D * 20.0, 100), 2),
    'MEDIUM',
    DC.DISTINCT_DEST_COUNTRIES_30D, '3',
    'Risk signal detected: ' || DC.DISTINCT_DEST_COUNTRIES_30D || ' distinct destination countries in 30 days (threshold: 3)',
    'POL-AML-001 S3.4',
    CURRENT_TIMESTAMP()
FROM RISK.V_FEAT_DEST_COUNTRIES DC
JOIN RAW.ACCOUNTS AC ON DC.ACCOUNT_ID = AC.ACCOUNT_ID
WHERE DC.DISTINCT_DEST_COUNTRIES_30D > 3

UNION ALL

-- FRD_001: Velocity anomaly
SELECT
    'FRD_001', 1, 'FRAUD', 'Transaction Velocity Anomaly',
    R.ACCOUNT_ID, AC.CUSTOMER_ID, R.TRANSACTION_ID,
    ROUND(LEAST(R.TXN_COUNT_24H * 5.0, 100), 2),
    'HIGH',
    R.TXN_COUNT_24H, '10',
    'Risk signal detected: ' || R.TXN_COUNT_24H || ' transactions in 24h window (threshold: 10)',
    'POL-TXM-001 S2.1',
    CURRENT_TIMESTAMP()
FROM RISK.V_FEAT_ROLLING_24H R
JOIN RAW.ACCOUNTS AC ON R.ACCOUNT_ID = AC.ACCOUNT_ID
WHERE R.TXN_COUNT_24H > 10
QUALIFY ROW_NUMBER() OVER (PARTITION BY R.ACCOUNT_ID ORDER BY R.TXN_COUNT_24H DESC) = 1

UNION ALL

-- CRD_001: Credit utilization
SELECT
    'CRD_001', 1, 'CREDIT', 'Sudden Credit Utilization',
    CU.ACCOUNT_ID, CU.CUSTOMER_ID, NULL,
    ROUND(LEAST(CU.UTILIZATION_PCT, 100), 2),
    'MEDIUM',
    CU.UTILIZATION_PCT, '80',
    'Risk signal detected: Credit utilization at ' || CU.UTILIZATION_PCT || '% (threshold: 80%)',
    'POL-CRD-001 S2.1',
    CURRENT_TIMESTAMP()
FROM RISK.V_FEAT_CREDIT_UTILIZATION CU
WHERE CU.UTILIZATION_PCT > 80

UNION ALL

-- LIQ_001: Liquidity decline
SELECT
    'LIQ_001', 1, 'LIQUIDITY', 'Sustained Liquidity Decline',
    LD.ACCOUNT_ID, AC.CUSTOMER_ID, NULL,
    ROUND(LEAST(ABS(LD.PCT_CHANGE_7D), 100), 2),
    'HIGH',
    LD.PCT_CHANGE_7D, '-50',
    'Risk signal detected: Closing balance declined ' || LD.PCT_CHANGE_7D || '% over 7 days (threshold: -50%)',
    'POL-LIQ-001 S2.1',
    CURRENT_TIMESTAMP()
FROM RISK.V_FEAT_LIQUIDITY_DECLINE LD
JOIN RAW.ACCOUNTS AC ON LD.ACCOUNT_ID = AC.ACCOUNT_ID
WHERE LD.PCT_CHANGE_7D < -50
QUALIFY ROW_NUMBER() OVER (PARTITION BY LD.ACCOUNT_ID ORDER BY LD.PCT_CHANGE_7D ASC) = 1

UNION ALL

-- FRD_003: Mule behavior
SELECT
    'FRD_003', 1, 'FRAUD', 'Potential Mule Account',
    M.ACCOUNT_ID, AC.CUSTOMER_ID, NULL,
    ROUND(LEAST(M.PCT_MOVED_OUT * 0.9, 100), 2),
    'HIGH',
    M.UNIQUE_CREDIT_SOURCES_24H, '3',
    'Risk signal detected: ' || M.UNIQUE_CREDIT_SOURCES_24H || ' unique credit sources, ' || M.PCT_MOVED_OUT || '% funds moved out within window',
    'POL-TXM-001 S2.3',
    CURRENT_TIMESTAMP()
FROM RISK.V_FEAT_MULE_BEHAVIOR M
JOIN RAW.ACCOUNTS AC ON M.ACCOUNT_ID = AC.ACCOUNT_ID
WHERE M.PCT_MOVED_OUT >= 70;

-- Grant access
GRANT SELECT ON ALL VIEWS IN SCHEMA RISK TO ROLE REGINTEL_ANALYST;
GRANT SELECT ON ALL VIEWS IN SCHEMA RISK TO ROLE REGINTEL_APP_ROLE;
GRANT SELECT ON ALL VIEWS IN SCHEMA RISK TO ROLE REGINTEL_EXECUTIVE_VIEWER;
GRANT SELECT ON ALL TABLES IN SCHEMA RISK TO ROLE REGINTEL_ANALYST;
GRANT SELECT ON ALL TABLES IN SCHEMA RISK TO ROLE REGINTEL_APP_ROLE;
