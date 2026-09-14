# RegIntel Copilot — Project Brief

**GCC Snowflake Hackathon 2026**

---

## What It Is

RegIntel Copilot is a **Risk, Fraud & Regulatory Intelligence Copilot** built entirely on Snowflake. It helps banking compliance teams detect suspicious activity, investigate alerts, gather evidence, draft findings, and produce audit-ready reports — all from natural-language questions grounded in actual data and indexed policy documents.

---

## The Problem

Banking compliance teams manually review thousands of transaction monitoring alerts daily. Investigators must cross-reference transaction data, customer profiles, risk rules, and regulatory policies across multiple systems. This process is slow, inconsistent, and hard to audit. Key pain points:

- **Alert fatigue** — analysts spend hours on each alert, many of which are false positives
- **Evidence scattering** — transaction data, customer context, and policy references live in different systems
- **Inconsistent findings** — narrative quality varies across investigators
- **Audit gaps** — regulators require complete evidence chains that are hard to reconstruct after the fact

---

## The Solution

RegIntel Copilot brings the entire investigation lifecycle into a single Snowflake-native application:

```
Risk Signal → Alert → Investigation → Evidence → Finding → Review → Report → Audit Trail
```

### Core Capabilities

| Capability | How It Works |
|-----------|--------------|
| **Risk Detection** | 9 deterministic SQL rules across AML, Fraud, Credit, and Liquidity domains with visible thresholds — no black-box AI scoring |
| **AI-Powered Investigation** | Multi-turn Copilot Chat using Cortex COMPLETE, grounded in real alert data and indexed policy passages |
| **Semantic Policy Search** | Cortex Search Service retrieves relevant policy sections using natural language (snowflake-arctic-embed-m-v1.5) |
| **Draft Finding Generation** | AI-generated investigation narratives from evidence, explicitly labeled DRAFT until human approval |
| **Case Management** | Full workflow: open case → investigate → draft finding → review → approve/reject → close |
| **Audit Trail** | Every action, query, and state change logged with timestamps, user identity, and query IDs |
| **Investigation Reports** | Assembled from evidence + findings + policy citations with DRAFT watermark on unapproved reports |

---

## Technical Architecture

**100% Snowflake-native** — no external services, APIs, or infrastructure.

| Layer | Snowflake Services Used |
|-------|------------------------|
| **UI** | Streamlit-in-Snowflake (10-page application) |
| **AI** | Cortex COMPLETE (3 models), Cortex Search, Semantic View, Cortex Agent |
| **Compute** | Snowpark Python, stored procedures, SQL feature views |
| **Data** | Standard tables, curated views, policy chunks, evidence records |
| **Security** | 6 RBAC roles with least-privilege grants |

### Cortex AI Integration

| Feature | Service | Model/Engine |
|---------|---------|--------------|
| Copilot Chat | CORTEX.COMPLETE | llama3.1-8b / llama3.1-70b / llama3.3-70b (user-selectable) |
| Policy Search | Cortex Search Service | snowflake-arctic-embed-m-v1.5 |
| Finding Generator | CORTEX.COMPLETE | llama3.1-70b |
| Structured Queries | Cortex Analyst | Semantic View (7 tables, relationships) |
| Unified Agent | Cortex Agent | Analyst + PolicySearch tools |

---

## Data Scale

| Object | Count |
|--------|-------|
| Customers | 500 |
| Accounts | 700 |
| Transactions | 45,051 |
| Daily Balances | 56,790 |
| Risk Rules | 9 (across 4 domains) |
| Alerts Generated | 776 |
| Evidence Records | 916 |
| Policy Documents | 4 |
| Policy Chunks (indexed) | 22 |
| Planted Suspicious Scenarios | 10 (S01–S10) |
| RBAC Roles | 6 |
| Streamlit Pages | 10 |

---

## 10 Planted Scenarios

| ID | Pattern | Domain |
|----|---------|--------|
| S01 | Structuring (just-below-threshold deposits) | AML |
| S02 | Rapid movement of funds | AML |
| S03 | Dormant account reactivation | AML |
| S04 | Unusual transaction geography | AML |
| S05 | Transaction velocity anomaly | Fraud |
| S06 | New counterparty concentration | Fraud |
| S07 | Circular fund movement (A→B→C→A) | AML |
| S08 | Sudden credit utilization spike | Credit |
| S09 | Sustained liquidity decline | Liquidity |
| S10 | Mule account behavior | Fraud |

---

## Key Design Decisions

1. **Deterministic risk scores** — SQL rules with visible thresholds, never LLM-generated. Auditors can inspect exactly why an alert fired.

2. **Grounded AI answers** — The Copilot retrieves actual data (alerts, transactions, balances) and indexed policy passages before generating any response. No hallucinated evidence.

3. **DRAFT-until-approved** — AI-generated findings are explicitly labeled as machine-generated drafts. Only a compliance reviewer role can approve, creating a clear human-in-the-loop control.

4. **Evidence immutability** — Evidence records include SHA-256 hashes. Append-only design prevents tampering.

5. **Full audit trail** — Every copilot query, case state change, finding revision, and approval is logged with timestamp, user, and Snowflake query ID.

---

## Streamlit Application Pages

| Page | Purpose |
|------|---------|
| **Copilot Chat** | Multi-turn AI Q&A with model switching, suggested questions, account focus |
| **Executive Overview** | KPI metrics: total alerts, open cases, review queue, rule triggers |
| **Risk Signal Monitor** | Filterable alert grid (domain, severity, status) |
| **Alert Investigation** | Deep-dive: customer context, transactions, policy evidence, open-case action |
| **Evidence Explorer** | JSON evidence inspection with SHA-256 hashes |
| **Policy Intelligence** | Semantic search over regulatory policy documents via Cortex Search |
| **Case Management** | Case lifecycle: status updates, findings, approve/reject, timeline |
| **Report Builder** | Assembled investigation report with DRAFT watermark |
| **Audit Trail** | Complete activity log |
| **About** | Architecture, controls, and limitations |

---

## Database Schema

```
REGINTEL (database)
├── RAW          — Source tables (customers, accounts, transactions, balances)
├── CURATED      — Business views (masked/enriched)
├── RISK         — Detection engine (rules, alerts, evidence, 8 feature views)
├── POLICY       — Regulatory docs (documents, chunks, Cortex Search service)
├── CASE_MGMT    — Investigation workflow (cases, findings, evidence links)
├── AUDIT        — Compliance trail (activity log, audit views)
└── APP          — Application layer (Streamlit, semantic view, agent, procedures)
```

---

## Test Results

**38/41 tests pass (92.7%)**

| Suite | Pass | Fail | Notes |
|-------|------|------|-------|
| Data Quality | 11/11 | 0 | Row counts, uniqueness, FK integrity, amounts |
| Risk Rules | 14/16 | 2 | FRD_002 threshold not met by planted data (honest gap) |
| Case Workflow + Cortex | 13/14 | 1 | Semantic view exists but not in INFORMATION_SCHEMA (test limitation) |

---

## Operational Cost

| Component | Credits/Day | Notes |
|-----------|------------|-------|
| Warehouse (COMPUTE_WH) | ~0.86 | Queries, Streamlit, procedures |
| Cortex AI Functions | ~0.0002 | LLM calls (COMPLETE) |
| Cortex Search | Included | Incremental refresh, 1-hour lag |
| **Total** | **~0.86** | **~$2.60/day at $3/credit** |

---

## Project Structure

```
regintel-copilot/
├── config/                          # Configuration templates
│   └── project_config.example.yml
├── docs/                            # Documentation
│   ├── demo_script.md               # 12-step demo narrative
│   └── judging_criteria.md          # Judging criteria mapping
├── policy_docs/                     # 4 synthetic policy documents
│   ├── aml_policy.md
│   ├── credit_risk_policy.md
│   ├── liquidity_risk_policy.md
│   └── transaction_monitoring_policy.md
├── sql/                             # 14 deployment scripts (execute in order)
│   ├── 00_environment_check.sql
│   ├── 01_roles_and_database.sql
│   ├── 02_core_tables.sql
│   ├── 03_synthetic_data.sql
│   ├── 04_data_quality.sql
│   ├── 05_risk_features.sql
│   ├── 06_risk_rules.sql
│   ├── 07_alert_pipeline.sql
│   ├── 08_policy_search.sql
│   ├── 09_semantic_layer.sql
│   ├── 10_case_management.sql
│   ├── 11_audit_logging.sql
│   ├── 12_demo_queries.sql
│   └── 13_cleanup.sql
├── streamlit/                       # Streamlit application
│   ├── streamlit_app.py             # Main app (543 lines, 10 pages)
│   └── environment.yml
├── tests/                           # Test suites + results
│   ├── test_data_quality.sql
│   ├── test_risk_rules.sql
│   ├── test_case_workflow.sql
│   ├── test_cortex_integration.sql
│   └── test_results.md              # Actual results: 38/41 pass
├── REGINTEL_AGENT.agent.yaml        # Cortex Agent spec
├── REGINTEL_SEMANTIC_VIEW.sv.yaml   # Semantic View definition
├── .gitignore
└── README.md
```

---

## Limitations

- **Synthetic data only** — no real PII; all names, accounts, and transactions are fictitious
- **Policy documents are synthetic** — demonstrate structure and retrieval, not actual regulations
- **Thresholds are demonstration values** — not calibrated for production
- **FRD_002 rule** does not fire (planted data below threshold) — 8/9 rules operational
- **Single-account scope** — no cross-account or organization-level deployment
- **Not production-ready** without: parameterized queries, RLS policies, network policies, external key management, model fine-tuning, real regulatory content

---

## Why This Is Not Just a Dashboard

Traditional compliance dashboards display data. RegIntel Copilot is different:

1. **Conversational investigation** — analysts ask follow-up questions in natural language, with context maintained across the conversation
2. **Evidence grounding** — every AI response is backed by actual alert data and indexed policy passages, not general knowledge
3. **End-to-end workflow** — from risk signal detection through finding approval and audit trail, all in one application
4. **Human-in-the-loop governance** — AI assists but never decides; findings require human review and explicit approval
5. **Audit-native** — every interaction is logged, creating a complete investigation record for regulators

---

*Built entirely on Snowflake. Synthetic data only. GCC Snowflake Hackathon 2026.*
