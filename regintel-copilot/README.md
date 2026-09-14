# RegIntel Copilot

Risk, Fraud and Regulatory Intelligence Copilot — GCC Snowflake Hackathon 2026

## Overview

RegIntel Copilot demonstrates how banking and NBFC compliance teams can use Snowflake-native tools to detect risk signals, investigate alerts, retrieve policy evidence, and produce audit-ready regulatory outputs from natural-language questions.

**All data is synthetic. This is a hackathon demonstration, not a production system.**

## Architecture

```
┌──────────────────────────────────────────────────────────────────┐
│                    Streamlit in Snowflake                         │
│  Copilot Chat │ Executive Overview │ Risk Signal Monitor          │
│  Alert Investigation │ Evidence Explorer │ Policy Intelligence    │
│  Case Management │ Report Builder │ Audit Trail │ About          │
├──────────────────────────────────────────────────────────────────┤
│                    Cortex AI Layer                                │
│  CORTEX.COMPLETE (multi-model) │ Cortex Search │ Semantic View   │
│  Cortex Agent (Analyst + PolicySearch tools)                     │
├──────────────────────────────────────────────────────────────────┤
│                    QA Contract Layer                              │
│  COPILOT_ASK │ GENERATE_FINDING_NARRATIVE │ SEARCH_POLICY        │
│  Data-grounded answers │ Multi-turn conversation                 │
├──────────────────────────────────────────────────────────────────┤
│                    Risk Engine                                    │
│  9 Deterministic Rules │ 8 Feature Views │ Alert Pipeline        │
│  AML_001-004 │ FRD_001-003 │ CRD_001 │ LIQ_001                  │
├──────────────────────────────────────────────────────────────────┤
│                    Case Management & Audit                        │
│  Case Lifecycle │ Versioned Findings │ Evidence Hashing (SHA-256)│
│  Full Audit Trail │ State Machine Workflow                       │
├──────────────────────────────────────────────────────────────────┤
│                    Data Layer                                     │
│  500 Customers │ 700 Accounts │ 45K+ Transactions                │
│  56K+ Daily Balances │ 10 Planted Scenarios (S01-S10)            │
│  4 Policy Documents │ 22 Policy Chunks │ 6 RBAC Roles            │
└──────────────────────────────────────────────────────────────────┘
```

## Cortex AI Integration

| Feature | Service | Purpose |
|---------|---------|---------|
| Copilot Chat | `CORTEX.COMPLETE` | Multi-turn NL Q&A grounded in data + policy evidence |
| Policy Search | `CORTEX SEARCH SERVICE` | Semantic retrieval over policy docs (snowflake-arctic-embed-m-v1.5) |
| Finding Generator | `CORTEX.COMPLETE` | AI-drafted investigation narratives from evidence |
| Semantic View | `REGINTEL_SEMANTIC_VIEW` | Structured data model for Cortex Analyst |
| Cortex Agent | `REGINTEL_AGENT` | Unified agent with Analyst + PolicySearch tools |
| Model Switching | `llama3.1-8b/70b`, `llama3.3-70b` | Fast/Standard/Advanced modes in Copilot Chat |

## Quick Start

### Prerequisites
- Snowflake account with ACCOUNTADMIN access
- COMPUTE_WH warehouse available
- Cortex AI available in account region

### Deployment
Execute SQL scripts in order:
```
sql/00_environment_check.sql    -- Verify environment & Cortex availability
sql/01_roles_and_database.sql   -- Create RBAC (6 roles) + database (7 schemas)
sql/02_core_tables.sql          -- Create domain tables + curated views
sql/03_synthetic_data.sql       -- Generate synthetic data + 10 planted scenarios
sql/04_data_quality.sql         -- Validate data integrity
sql/05_risk_features.sql        -- Create 8 feature views
sql/06_risk_rules.sql           -- Seed 9 risk rules + alert candidates view
sql/07_alert_pipeline.sql       -- Materialize 776 alerts + 916 evidence records
sql/08_policy_search.sql        -- Load policies + Cortex Search service
sql/09_semantic_layer.sql       -- Semantic view + Cortex Agent + query templates
sql/10_case_management.sql      -- Case lifecycle procedures + demo case
sql/11_audit_logging.sql        -- Audit views + activity log
sql/12_demo_queries.sql         -- Validate demo scenarios
```

### Streamlit Deployment
```sql
PUT 'file://streamlit/streamlit_app.py' @REGINTEL.APP.STREAMLIT_STAGE/ AUTO_COMPRESS=FALSE OVERWRITE=TRUE;
PUT 'file://streamlit/environment.yml' @REGINTEL.APP.STREAMLIT_STAGE/ AUTO_COMPRESS=FALSE OVERWRITE=TRUE;

CREATE OR REPLACE STREAMLIT REGINTEL.APP.REGINTEL_COPILOT
  ROOT_LOCATION = '@REGINTEL.APP.STREAMLIT_STAGE'
  MAIN_FILE = 'streamlit_app.py'
  QUERY_WAREHOUSE = 'COMPUTE_WH'
  COMMENT = 'RegIntel Copilot - Risk, Fraud and Regulatory Intelligence';
```

### Cleanup
```sql
-- Review and execute sql/13_cleanup.sql (drops all objects)
```

## Database Schema

| Schema | Purpose | Key Objects |
|--------|---------|-------------|
| RAW | Source tables | CUSTOMERS, ACCOUNTS, TRANSACTIONS, ACCOUNT_DAILY_BALANCE, SCENARIO_VALIDATION |
| CURATED | Business views | V_CUSTOMERS, V_ACCOUNTS, V_TRANSACTIONS, V_DAILY_BALANCE |
| RISK | Detection engine | RISK_RULES, ALERTS, ALERT_EVIDENCE, 8 feature views, V_ALERT_CANDIDATES |
| POLICY | Regulatory docs | POLICY_DOCUMENTS, POLICY_CHUNKS, POLICY_SEARCH_SVC (Cortex Search) |
| CASE_MGMT | Investigation workflow | CASES, FINDINGS, CASE_EVIDENCE, 4 procedures, 3 views |
| AUDIT | Compliance trail | ACTIVITY_LOG, V_AUDIT_TRAIL, V_AUDIT_SUMMARY |
| APP | Application layer | REGINTEL_COPILOT (Streamlit), REGINTEL_SEMANTIC_VIEW, REGINTEL_AGENT, procedures |

## Risk Rules

| Rule ID | Name | Domain | Severity | Planted Scenario |
|---------|------|--------|----------|------------------|
| AML_001 | Structuring Detection | AML | HIGH | S01 |
| AML_002 | Rapid Movement of Funds | AML | HIGH | S02 |
| AML_003 | Dormant Account Reactivation | AML | MEDIUM | S03 |
| AML_004 | Unusual Transaction Geography | AML | MEDIUM | S04 |
| FRD_001 | Transaction Velocity Anomaly | FRAUD | HIGH | S05 |
| FRD_002 | New Counterparty Concentration | FRAUD | MEDIUM | S06 |
| FRD_003 | Potential Mule Account | FRAUD | HIGH | S10 |
| CRD_001 | Sudden Credit Utilization | CREDIT | MEDIUM | S08 |
| LIQ_001 | Sustained Liquidity Decline | LIQUIDITY | HIGH | S09 |

## RBAC Roles

| Role | Access Level |
|------|-------------|
| REGINTEL_ADMIN | Full project administration |
| REGINTEL_ENGINEER | DDL, ETL, raw data access |
| REGINTEL_ANALYST | Curated views, alerts, cases, copilot |
| REGINTEL_COMPLIANCE_REVIEWER | Approve/reject findings |
| REGINTEL_EXECUTIVE_VIEWER | Read-only dashboards |
| REGINTEL_APP_ROLE | Streamlit service account |

## Key Design Decisions

1. **Deterministic risk scores** — all scores from SQL rules with visible thresholds, never LLM-generated
2. **Evidence immutability** — SHA-256 hashes on evidence records, append-only design
3. **DRAFT-until-approved** — AI-generated findings explicitly labeled; only compliance reviewers can approve
4. **Grounded AI answers** — Copilot Chat retrieves actual data + indexed policy passages before generating responses
5. **Full audit trail** — every state change, copilot query, and finding revision is logged with timestamps and user identity

## Demo Questions

1. Which open alerts have the highest risk score and which rules contributed?
2. Why was account A000123 flagged? Show rule thresholds and observed values.
3. What evidence is required when rapid movement of funds is detected?
4. Show material liquidity declines over the last seven balance dates.
5. What evidence is missing before case C000017 can be submitted for review?
6. Show accounts that received funds from 3+ counterparties and moved most out within 24 hours.
7. Generate a draft finding for case C000017.
8. Generate an investigation report for case C000017.

## Project Structure

```
regintel-copilot/
├── config/                    # Configuration templates
├── docs/                      # Demo script, judging criteria
├── policy_docs/               # 4 synthetic policy documents (.md)
├── sql/                       # 14 SQL deployment scripts (00-13)
├── streamlit/                 # Streamlit app + environment.yml
├── tests/                     # Test SQL + results
├── REGINTEL_AGENT.agent.yaml  # Cortex Agent specification
├── REGINTEL_SEMANTIC_VIEW.sv.yaml  # Semantic view definition
├── .gitignore
└── README.md
```

## Limitations

- **Synthetic data only** — no real PII; all names, accounts, and transactions are fictitious
- **Policy documents are synthetic** — demonstrate structure and retrieval, not actual regulations
- **Thresholds are demonstration values** — not calibrated to real regulatory requirements
- **10 planted scenarios** — covers key patterns but not exhaustive for production
- **Single-account demo** — no cross-account or org-level deployment
- **Not production-ready** without: parameterized queries (SQL injection hardening), RLS policies, network policies, external key management, model fine-tuning, real regulatory content

## Cost

Operational cost in steady state: ~0.86 credits/day for warehouse compute + minimal AI function credits. Cortex Search service runs incrementally with 1-hour target lag.
