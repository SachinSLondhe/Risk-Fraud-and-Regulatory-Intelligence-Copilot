# RegIntel Copilot — Judging Criteria Mapping

**GCC Snowflake Hackathon 2026**

This document maps every feature of RegIntel Copilot to the three hackathon judging criteria: **Real-World Relevance**, **Technical Execution**, and **Solution Completeness**.

---

## 1. Real-World Relevance

> Does the solution address a genuine banking problem with identifiable users, measurable business impact, and appropriate human oversight?

### The Problem

Banking compliance teams manually review thousands of alerts daily across anti-money laundering (AML), fraud, credit risk, and liquidity risk domains. Current workflows suffer from:

- **Alert fatigue** — analysts triage hundreds of alerts with limited context, leading to inconsistent prioritization.
- **Scattered evidence** — transaction data, customer profiles, and regulatory policies live in separate systems, forcing manual cross-referencing.
- **Narrative bottleneck** — investigators spend hours writing findings that summarize the same patterns repeatedly.
- **Audit gaps** — the chain from signal detection to final report lacks a single, tamper-evident record.

### Target Users

| Role | How They Use RegIntel Copilot |
|------|-------------------------------|
| **Compliance Analyst** | Triages alerts, reviews risk scores, explores evidence, uses Copilot Chat to query data and policies. |
| **Investigator** | Runs alert investigations, inspects transaction timelines, generates draft findings with AI assistance. |
| **Reviewer** | Approves or rejects AI-generated findings, manages case status workflow, ensures regulatory standards. |
| **Executive / Audit** | Consumes investigation reports, reviews audit trails, monitors portfolio-level risk metrics. |

### Business Impact

| Metric | Before | With RegIntel Copilot |
|--------|--------|----------------------|
| Evidence gathering | Manual cross-system lookup | Automated: customer context, transactions, policy citations assembled per alert |
| Investigation narrative | Written from scratch per case | AI-generated draft with evidence links and policy references |
| Consistency | Varies by analyst experience | Deterministic scoring rules + standardized evidence schema |
| Audit readiness | Reconstructed after the fact | Built-in: every action logged with query ID, timestamp, role |

### Human-in-the-Loop Controls

RegIntel Copilot treats AI as an assistant, never as a decision-maker:

- **DRAFT label** — All AI-generated findings are marked `DRAFT` until a human reviewer explicitly approves them. No AI output reaches a regulatory filing without human sign-off.
- **Deterministic risk scores** — Risk scores are computed by 9 SQL rules with visible thresholds (e.g., transaction velocity > 5x baseline = HIGH). The LLM never produces or modifies a risk score.
- **Immutable evidence** — Every evidence record includes a SHA-256 hash of its content. Once written, evidence cannot be altered without detection.
- **DRAFT watermark on reports** — Investigation reports carry a visible DRAFT watermark until the finding status is finalized, preventing premature distribution.

---

## 2. Technical Execution

> Is the solution built on Snowflake's native capabilities with explainable logic, proper security, and production-grade architecture?

### 100% Snowflake-Native Stack

Every component runs inside Snowflake — no external services, no sidecar infrastructure:

| Component | Snowflake Service | Purpose |
|-----------|-------------------|---------|
| Data processing | **Snowpark (Python)** | Risk rule execution, evidence generation, data pipeline orchestration |
| AI narratives | **Cortex COMPLETE** | Draft finding generation with model switching (llama3.1-8b, llama3.1-70b, llama3.3-70b) |
| Policy retrieval | **Cortex Search** | Semantic search over indexed regulatory policies (snowflake-arctic-embed-m-v1.5) |
| Natural language query | **Cortex Analyst + Semantic Views** | Governed NL-to-SQL over investigation data, grounded in semantic model |
| Agentic orchestration | **Cortex Agent** | Multi-tool copilot combining Cortex Search + Cortex Analyst for chat |
| Frontend | **Streamlit-in-Snowflake** | 7-page interactive application with role-aware navigation |

### Explainable, Deterministic Risk Scoring

The 9 SQL rules are fully visible and auditable — no black-box ML scoring:

| # | Rule | Domain | Threshold Logic |
|---|------|--------|-----------------|
| 1 | Structuring Detection | AML | Transactions just below reporting thresholds within rolling window |
| 2 | Rapid Movement | AML | Funds in-and-out within 24–48 hours exceeding velocity baseline |
| 3 | Geographic Risk | AML | Transactions involving high-risk jurisdictions (FATF list) |
| 4 | Velocity Spike | Fraud | Transaction count > 5x rolling 30-day average |
| 5 | Channel Anomaly | Fraud | Unusual channel/device pattern deviation from customer profile |
| 6 | Amount Anomaly | Fraud | Single transaction > 10x customer median |
| 7 | Concentration Risk | Credit | Exposure to single counterparty > threshold percentage of portfolio |
| 8 | Rating Migration | Credit | Rapid credit rating downgrades within observation period |
| 9 | Liquidity Gap | Liquidity | Asset-liability maturity mismatch exceeding buffer thresholds |

Each rule produces a score with a human-readable explanation stored alongside the alert. Analysts can inspect exactly why an alert fired.

### Semantic Policy Retrieval

- Regulatory policies are chunked, embedded with `snowflake-arctic-embed-m-v1.5`, and indexed via Cortex Search.
- When an investigator reviews an alert, relevant policy sections are retrieved semantically — not by keyword match.
- Policy citations appear in AI-generated findings with source references, enabling reviewers to verify grounding.

### Governed Natural Language Interface

- Cortex Analyst is backed by a Semantic View that defines the governed schema — table relationships, metric definitions, and permitted joins.
- The Copilot Chat combines Cortex Agent with both Cortex Search (policies) and Cortex Analyst (data), ensuring responses are grounded in actual data and indexed policies rather than hallucinated.
- Model switching allows trading off latency vs. capability: llama3.1-8b for fast lookups, llama3.1-70b / llama3.3-70b for complex reasoning.

### Security and Access Control

6 RBAC roles enforce least-privilege access:

| Role | Access Level |
|------|-------------|
| `REGINTEL_ADMIN` | Full DDL/DML, role management, system configuration |
| `REGINTEL_INVESTIGATOR` | Read alerts, create findings, generate evidence, run investigations |
| `REGINTEL_REVIEWER` | Approve/reject findings, manage case status, generate reports |
| `REGINTEL_ANALYST` | Read-only access to alerts, evidence, and dashboards |
| `REGINTEL_AUDITOR` | Read-only access to audit trail and investigation history |
| `REGINTEL_READONLY` | View-only access to dashboards and summary metrics |

### Full Audit Trail

- Every database action is logged with a Snowflake query ID, timestamp, and executing role.
- The audit log is append-only — records cannot be modified or deleted by application roles.
- Audit entries link back to the specific alert, evidence, finding, or report they relate to.

---

## 3. Solution Completeness

> Does the solution cover the full lifecycle from signal detection through investigation, evidence gathering, findings, review, reporting, and audit?

### End-to-End Workflow

```
Signal Detection → Alert Generation → Investigation → Evidence Assembly
    → Finding (AI Draft) → Human Review → Report Generation → Audit Trail
```

Each stage is implemented as a distinct, functional component:

#### Stage 1: Risk Signal Detection
- 9 deterministic SQL rules scan transaction and customer data across 4 risk domains (AML, Fraud, Credit, Liquidity).
- Rules execute via Snowpark stored procedures with configurable thresholds.

#### Stage 2: Alert Generation
- Rules produce **776 alerts** with **916 evidence records** derived from **10 planted risk scenarios**.
- Each alert carries: risk domain, rule ID, severity, risk score, affected customer, and triggering data reference.

#### Stage 3: Investigation
- **Alert Investigation page** presents a unified view per alert: customer profile, transaction timeline, related alerts, and semantically retrieved policy excerpts.
- Investigators can drill into any dimension without leaving the Snowflake environment.

#### Stage 4: Evidence Assembly
- **Evidence Explorer** allows inspection of all evidence records linked to an alert.
- Each record stores structured JSON content with a SHA-256 integrity hash.
- Evidence is immutable once created — the hash allows downstream verification.

#### Stage 5: Finding Generation
- AI-generated draft narratives summarize the alert, evidence, and applicable policy.
- Findings are **versioned** — each edit creates a new version, preserving history.
- Every finding links to its supporting evidence records and policy citations.
- Findings are explicitly labeled `DRAFT` and carry no regulatory weight until human approval.

#### Stage 6: Review and Case Management
- Reviewers manage case status through a defined workflow (Open → Under Review → Escalated → Closed).
- Approval or rejection of AI findings is a deliberate human action with an audit record.

#### Stage 7: Report Generation
- **Investigation Report Builder** compiles alert details, evidence, findings, and policy references into a structured report.
- Reports carry a `DRAFT` watermark until the underlying finding is approved.
- Reports are generated within Snowflake and can be exported for regulatory submission.

#### Stage 8: Audit Trail
- Complete, append-only log of every action: alert creation, evidence generation, finding drafts, review decisions, report generation.
- Each entry includes query ID, timestamp, acting role, and affected object reference.

---

## Feature-to-Criterion Mapping

| Feature | Real-World Relevance | Technical Execution | Solution Completeness |
|---------|:-------------------:|:-------------------:|:---------------------:|
| 9 deterministic SQL risk rules | Addresses alert fatigue with consistent, explainable scoring | Pure SQL with visible thresholds — no LLM scoring | Stage 1: Signal Detection |
| 776 alerts / 916 evidence from 10 scenarios | Demonstrates realistic alert volume from planted risk patterns | Snowpark pipeline orchestration | Stage 2: Alert Generation |
| Alert Investigation page | Unified context eliminates cross-system lookup | Streamlit-in-Snowflake with Snowpark data layer | Stage 3: Investigation |
| Evidence Explorer with SHA-256 hashes | Tamper-evident evidence chain for regulators | Immutable records with cryptographic integrity | Stage 4: Evidence Assembly |
| AI-generated draft findings (Cortex COMPLETE) | Reduces narrative writing burden by hours per case | Model switching (llama3.1-8b/70b, llama3.3-70b) | Stage 5: Finding Generation |
| DRAFT label on AI findings | Human-in-the-loop: AI assists, humans decide | Status field enforced at data layer | Stage 5–6: Finding → Review |
| Versioned findings with evidence + policy links | Full provenance for regulatory examination | Append-only version history in Snowflake | Stage 5: Finding Generation |
| Semantic policy retrieval (Cortex Search) | Policy-grounded evidence, not analyst memory | snowflake-arctic-embed-m-v1.5 embeddings | Stage 3–5: Investigation → Finding |
| Copilot Chat (Cortex Agent) | NL access to data + policies for all skill levels | Cortex Agent + Cortex Analyst + Cortex Search | Cross-cutting: all stages |
| Semantic View for governed NL queries | Prevents hallucinated metrics in regulatory context | Cortex Analyst grounded in semantic model | Cross-cutting: query layer |
| Case management workflow | Mirrors real compliance review process | Status state machine in Streamlit | Stage 6: Review |
| Investigation Report Builder | Regulatory-ready output with DRAFT watermark | Streamlit report generation within Snowflake | Stage 7: Reporting |
| 6 RBAC roles with least-privilege | Segregation of duties required by regulators | Snowflake native role hierarchy | Cross-cutting: security |
| Full audit trail with query IDs | Examination-ready evidence for regulators and auditors | Append-only logging tied to Snowflake query IDs | Stage 8: Audit Trail |
| DRAFT watermark on reports | Prevents premature regulatory submission | Conditional rendering in report builder | Stage 7: Reporting |

---

## Known Limitations

These are acknowledged scope boundaries for a hackathon submission, not defects:

| Limitation | Impact | Production Path |
|------------|--------|-----------------|
| Synthetic data only | Risk scenarios are planted, not derived from live feeds | Connect to core banking transaction feeds and real-time streaming ingestion |
| 10 planted scenarios | Covers 4 domains but not the full taxonomy of risk patterns | Expand rule library to 50+ rules with institution-specific calibration |
| Single-user session state | Streamlit session state does not persist across users or sessions | Add persistent case assignment and workflow state in database tables |
| No real-time alerting | Rules run as batch procedures, not streaming | Implement Snowpipe Streaming + Dynamic Tables for continuous detection |
| Policy corpus is sample-sized | Demonstrates retrieval but not full regulatory library | Ingest complete regulatory corpus (BSA/AML Manual, FFIEC, Basel III) |
| No external system integration | Alerts do not feed into case management platforms (e.g., Actimize, NICE) | Build API layer or Snowflake External Functions for bidirectional sync |
| Model selection is manual | Users switch models; no automatic routing by complexity | Implement query complexity classifier for automatic model routing |
| No SAR/STR auto-formatting | Reports are structured but not in FinCEN SAR or equivalent format | Add regulatory template engine for jurisdiction-specific filing formats |
| Limited load testing | Tested with hackathon-scale data, not production volume | Benchmark with 10M+ transactions and 100K+ alerts for performance validation |

---

## What Production Would Require

Beyond resolving the limitations above, a production deployment would need:

1. **Data integration** — Real-time feeds from core banking, payment rails, and customer onboarding systems via Snowpipe Streaming.
2. **Model governance** — Formal model risk management (SR 11-7 / SS1/23) documentation for any AI component influencing regulatory decisions.
3. **Regulatory templates** — SAR, STR, and CTR auto-population with jurisdiction-specific formatting (FinCEN, FCA, MAS, etc.).
4. **Penetration testing** — Security review of the Streamlit application layer and RBAC configuration.
5. **Change management** — Version-controlled deployment pipeline for rule changes, policy updates, and model upgrades.
6. **Monitoring** — Operational dashboards for rule execution health, model latency, evidence generation throughput, and audit log completeness.
7. **Multi-tenancy** — Isolation between business units or legal entities sharing the same Snowflake account.
8. **Disaster recovery** — Cross-region replication for audit trail and evidence stores with defined RPO/RTO targets.
