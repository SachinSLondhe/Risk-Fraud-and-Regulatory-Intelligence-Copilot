# RegIntel Copilot - Test Results

**Database:** REGINTEL  
**Connection:** NN81187  
**Run Date:** 2026-09-14  
**Run By:** Cortex Code (automated)

---

## Summary

| Test Suite             | Tests | Passed | Failed | Skipped | Notes |
|------------------------|------:|-------:|-------:|--------:|-------|
| Data Quality           |    11 |     11 |      0 |       0 | All pass |
| Risk Rules & Alerts    |    16 |     14 |      2 |       0 | FRD_002 rule not firing (see notes) |
| Case Workflow & Cortex |    14 |     13 |      1 |       0 | Semantic view not in INFORMATION_SCHEMA (exists as separate object type) |
| **Total**              | **41**| **38** |  **3** |   **0** | **92.7% pass rate** |

---

## Detailed Results

### Data Quality Tests (11/11 PASS)

| # | Test Name | Status | Details |
|---|-----------|--------|---------|
| 1 | FK_ACCOUNT_CUSTOMER | PASS | 0 orphan accounts |
| 2 | FK_TRANSACTION_ACCOUNT | PASS | 0 orphan transactions |
| 3 | POSITIVE_AMOUNTS | PASS | 0 non-positive amounts |
| 4 | ROW_COUNT_ACCOUNTS | PASS | Expected 700, got 700 |
| 5 | ROW_COUNT_CUSTOMERS | PASS | Expected 500, got 500 |
| 6 | ROW_COUNT_DAILY_BALANCE | PASS | Expected >50000, got 56790 |
| 7 | ROW_COUNT_TRANSACTIONS | PASS | Expected >40000, got 45051 |
| 8 | SCENARIOS_S01_S10 | PASS | Found 10/10 scenarios |
| 9 | UNIQUE_ACCOUNT_ID | PASS | 0 duplicates |
| 10 | UNIQUE_CUSTOMER_ID | PASS | 0 duplicates |
| 11 | UNIQUE_TRANSACTION_ID | PASS | 0 duplicates |

### Risk Rules & Alert Tests (14/16 PASS)

| # | Test Name | Status | Details |
|---|-----------|--------|---------|
| 1 | RULE_COUNT_9 | PASS | Found 9 rules |
| 2 | ALERTS_EXIST | PASS | 776 total alerts |
| 3 | EVIDENCE_EXIST | PASS | 916 evidence records |
| 4 | SCORE_RANGE_0_100 | PASS | 0 alerts with score outside 0-100 |
| 5 | ALL_RULES_FIRE | **FAIL** | 8/9 rules have at least 1 alert (FRD_002 = 0) |
| 6 | VALID_RULE_REF | PASS | 0 alerts reference invalid rule |
| 7 | NON_EMPTY_EXPLANATION | PASS | 0 alerts with empty explanation |
| 8 | AML001_FIRES | PASS | 36 alerts (structuring) |
| 9 | AML002_FIRES | PASS | 3 alerts (rapid movement) |
| 10 | AML003_FIRES | PASS | 3 alerts (dormant reactivation) |
| 11 | AML004_FIRES | PASS | 1 alert (unusual geography) |
| 12 | FRD001_FIRES | PASS | 101 alerts (velocity anomaly) |
| 13 | FRD002_FIRES | **FAIL** | 0 alerts (new counterparty concentration — rule exists but threshold not met by planted data) |
| 14 | FRD003_FIRES | PASS | 1 alert (mule behavior) |
| 15 | CRD001_FIRES | PASS | 1 alert (credit utilization) |
| 16 | LIQ001_FIRES | PASS | 630 alerts (liquidity decline) |

> **Note on FRD_002:** The rule exists in RISK_RULES but the planted scenario S06 (counterparty concentration) does not cross the detection threshold configured for FRD_002. This is an honest gap — 8 of 9 rules fire successfully. The ALL_RULES_FIRE test correctly reports this.

### Case Workflow & Cortex Tests (13/14 PASS)

| # | Test Name | Status | Details |
|---|-----------|--------|---------|
| 1 | CASES_EXIST | PASS | 1 case |
| 2 | CASE_C000017 | PASS | C000017 found |
| 3 | FINDINGS_EXIST | PASS | 1 finding |
| 4 | CASE_EVIDENCE_LINKS | PASS | 2 links |
| 5 | AUDIT_LOG_ENTRIES | PASS | 8 entries |
| 6 | POLICY_DOCS_4 | PASS | 4/4 docs |
| 7 | POLICY_CHUNKS_22 | PASS | 22/22 chunks |
| 8 | PROC_OPEN_CASE | PASS | Exists |
| 9 | PROC_UPDATE_CASE | PASS | Exists |
| 10 | PROC_CREATE_FINDING | PASS | Exists |
| 11 | PROC_REVIEW_FINDING | PASS | Exists |
| 12 | PROC_COPILOT_ASK | PASS | Exists |
| 13 | PROC_GENERATE_FINDING | PASS | Exists |
| 14 | SEMANTIC_VIEW | **FAIL** | Not in INFORMATION_SCHEMA.TABLES (semantic views are a separate object type; confirmed via SHOW SEMANTIC VIEWS) |

> **Note on SEMANTIC_VIEW:** The semantic view `REGINTEL_SEMANTIC_VIEW` exists and is active (confirmed via `SHOW SEMANTIC VIEWS IN SCHEMA REGINTEL.APP`). It is not queryable through INFORMATION_SCHEMA.TABLES because semantic views are a distinct Snowflake object type. This is a test limitation, not a deployment issue.

### Cortex AI Verification (manual)

| Feature | Status | Details |
|---------|--------|---------|
| CORTEX.COMPLETE (llama3.1-8b) | PASS | Returns responses |
| CORTEX.COMPLETE (llama3.1-70b) | PASS | Returns responses |
| CORTEX.COMPLETE (llama3.3-70b) | PASS | Returns responses |
| POLICY_SEARCH_SVC | PASS | ACTIVE, 22 rows indexed, snowflake-arctic-embed-m-v1.5 |
| REGINTEL_SEMANTIC_VIEW | PASS | ACTIVE, extensions: CA, AI |
| REGINTEL_COPILOT (Streamlit) | PASS | Deployed, 10 pages |
| 6 RBAC Roles | PASS | All 6 REGINTEL_* roles exist |

---

## How to Run

Execute each test file against the REGINTEL database:
```
tests/test_data_quality.sql       -- 11 data integrity tests
tests/test_risk_rules.sql         -- 16 risk rule tests
tests/test_case_workflow.sql      -- 13 case + procedure tests
tests/test_cortex_integration.sql -- 8 Cortex AI tests
```

Each test returns columns: `TEST_NAME`, `STATUS` (PASS/FAIL), `DETAILS`.

**Note:** Test SQL files use unqualified table names. Prefix with schema (e.g., `REGINTEL.RAW.CUSTOMERS`) or set `USE DATABASE REGINTEL; USE SCHEMA RAW;` before running.
