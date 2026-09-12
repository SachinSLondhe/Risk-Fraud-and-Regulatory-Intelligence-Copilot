# RegIntel Copilot

Risk, Fraud and Regulatory Intelligence Copilot — GCC Snowflake Hackathon 2026

## Overview

RegIntel Copilot demonstrates how banking and NBFC compliance teams can use Snowflake-native tools to detect risk signals, investigate alerts, retrieve policy evidence, and produce audit-ready regulatory outputs from natural-language questions.

**All data is synthetic. This is a hackathon demonstration, not a production system.**

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Streamlit in Snowflake                      │
│  Executive Overview │ Alert Investigation │ Case Management   │
│  Policy Intelligence │ Report Builder │ Audit Trail           │
├─────────────────────────────────────────────────────────────┤
│                    QA Contract Layer                           │
│  Intent Routing │ Query Templates │ Policy Search              │
├─────────────────────────────────────────────────────────────┤
│                    Risk Engine                                 │
│  9 Deterministic Rules │ Feature Views │ Alert Pipeline        │
│  AML_001-004 │ FRD_001-003 │ CRD_001 │ LIQ_001               │
├─────────────────────────────────────────────────────────────┤
│                    Case Management                             │
│  Case Lifecycle │ Findings │ Evidence Hashing │ Audit Trail    │
├─────────────────────────────────────────────────────────────┤
│                    Data Layer                                  │
│  500 Customers │ 700 Accounts │ 45K+ Transactions             │
│  10 Planted Scenarios │ 4 Policy Documents │ 22 Policy Chunks │
└─────────────────────────────────────────────────────────────┘
```

## Quick Start

### Prerequisites
- Snowflake account with ACCOUNTADMIN access
- COMPUTE_WH warehouse available

### Deployment
Execute SQL scripts in order:
```
sql/00_environment_check.sql    -- Verify environment
sql/01_roles_and_database.sql   -- Create RBAC + database
sql/02_core_tables.sql          -- Create domain tables
sql/03_synthetic_data.sql       -- Generate synthetic data
sql/04_data_quality.sql         -- Validate data
sql/05_risk_features.sql        -- Create feature views
sql/06_risk_rules.sql           -- Seed rules + alert candidates
sql/07_alert_pipeline.sql       -- Materialize alerts
sql/08_policy_search.sql        -- Load policies + search
sql/09_semantic_layer.sql       -- Query templates
sql/10_case_management.sql      -- Case lifecycle procedures
sql/11_audit_logging.sql        -- Audit views
sql/12_demo_queries.sql         -- Test demo questions
```

### Streamlit Deployment
Upload files to stage and create Streamlit:
```sql
PUT 'file://streamlit/streamlit_app.py' @REGINTEL.APP.STREAMLIT_STAGE/ AUTO_COMPRESS=FALSE;
PUT 'file://streamlit/environment.yml' @REGINTEL.APP.STREAMLIT_STAGE/ AUTO_COMPRESS=FALSE;

CREATE STREAMLIT APP.REGINTEL_COPILOT
  ROOT_LOCATION = '@REGINTEL.APP.STREAMLIT_STAGE'
  MAIN_FILE = 'streamlit_app.py'
  QUERY_WAREHOUSE = 'COMPUTE_WH';
```

### Cleanup
```sql
-- Uncomment and execute sql/13_cleanup.sql
```

## Risk Rules

| Rule ID | Name | Domain | Severity |
|---------|------|--------|----------|
| AML_001 | Structuring Detection | AML | HIGH |
| AML_002 | Rapid Movement of Funds | AML | HIGH |
| AML_003 | Dormant Account Reactivation | AML | MEDIUM |
| AML_004 | Unusual Transaction Geography | AML | MEDIUM |
| FRD_001 | Transaction Velocity Anomaly | FRAUD | HIGH |
| FRD_002 | New Device High Value | FRAUD | MEDIUM |
| FRD_003 | Potential Mule Account | FRAUD | HIGH |
| CRD_001 | Sudden Credit Utilization | CREDIT | MEDIUM |
| LIQ_001 | Sustained Liquidity Decline | LIQUIDITY | HIGH |

## RBAC Roles

| Role | Access |
|------|--------|
| REGINTEL_ADMIN | Full project admin |
| REGINTEL_ENGINEER | DDL, ETL, raw data |
| REGINTEL_ANALYST | Curated views, alerts, cases |
| REGINTEL_COMPLIANCE_REVIEWER | Approve/reject findings |
| REGINTEL_EXECUTIVE_VIEWER | Read-only dashboards |
| REGINTEL_APP_ROLE | Streamlit service account |

## Demo Questions
1. Which open alerts have the highest risk score?
2. Why was account A000123 flagged?
3. Show accounts with 3+ counterparty credits moved within 24h
4. Which alerts were triggered by rapid movement of funds?
5. Show material liquidity declines over 7 balance dates
6. Create a draft finding for case C000017
7. What evidence is missing for case C000017?
8. Generate investigation report for case C000017

## Limitations
- Synthetic data only — no real PII
- Cortex AI unavailable on trial accounts — SQL-based fallbacks used
- Policy documents are synthetic demonstrations
- Thresholds are demonstration values, not regulatory requirements
- Not production-ready without additional security hardening
