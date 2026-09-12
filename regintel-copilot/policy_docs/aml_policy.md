# SYNTHETIC HACKATHON POLICY — NOT LEGAL, COMPLIANCE, OR REGULATORY ADVICE

## Policy: Anti-Money Laundering (AML) Policy
- **Policy ID:** POL-AML-001
- **Version:** 1
- **Effective Date:** 2026-01-01
- **Status:** Active (Demonstration Only)

---

### S1. Scope
#### S1.P1
This policy applies to all synthetic accounts and transactions within the RegIntel Copilot demonstration environment. It defines indicators, investigation expectations, and evidence requirements for anti-money laundering monitoring.

#### S1.P2
This policy does NOT represent actual regulatory requirements. All thresholds are demonstration values chosen for hackathon purposes.

---

### S2. Control Objective
#### S2.P1
Detect and investigate potential money laundering patterns including structuring, rapid fund movement, dormant account reactivation, and unusual geographic activity.

---

### S3. Indicators and Rules
#### S3.1 Structuring Detection (AML_001)
##### S3.1.P1
Monitor for repeated transactions just below configurable reporting thresholds within a rolling window. The demonstration threshold is 50,000 INR with a lower bound of 45,000 INR and a minimum of 3 transactions within 7 days.

##### S3.1.P2
When structuring is detected, the investigation must document: the number of transactions, individual amounts, time window, account holder profile, and any counterparty relationships.

#### S3.2 Rapid Movement of Funds (AML_002)
##### S3.2.P1
Monitor for accounts receiving large credits (demonstration threshold: 100,000 INR) followed by outbound transfers within 24 hours where 50% or more of the incoming amount is moved.

##### S3.2.P2
Evidence requirements: incoming transaction details, all outbound transactions within the window, counterparty identifiers, transfer channels, and geographic routing.

#### S3.3 Dormant Account Reactivation (AML_003)
##### S3.3.P1
Monitor accounts classified as dormant (no activity for 60+ days) that receive significant deposits (demonstration threshold: 500,000 INR) and initiate outbound transfers.

##### S3.3.P2
Investigation must verify: account dormancy period, reactivation trigger, amounts involved, and whether the account holder has been re-verified.

#### S3.4 Unusual Transaction Geography (AML_004)
##### S3.4.P1
Monitor for transactions involving countries not consistent with the account holder's established geographic profile. Alert when more than 3 distinct destination countries are observed within 30 days.

##### S3.4.P2
Evidence must include: country codes involved, transaction amounts, the account's historical country profile, and any legitimate business justification on file.

---

### S4. Investigation Expectations
#### S4.P1
All alerts must be reviewed within the timeframes defined by severity: HIGH within 24 hours, MEDIUM within 72 hours, LOW within 7 business days.

#### S4.P2
Investigators must document their analysis using only evidence retrieved from the system. No external evidence may be referenced without first being attached to the case.

---

### S5. Evidence Requirements
#### S5.P1
Every finding must include: transaction evidence with IDs and timestamps, rule evaluation details with thresholds and observed values, applicable policy citations with section and paragraph references, and the investigator's analysis.

#### S5.P2
Evidence snapshots must be immutable once created. Any subsequent changes to source data do not alter the evidence used in the original investigation.

---

### S6. Escalation
#### S6.P1
Cases with HIGH severity that show multiple rule triggers for the same account must be escalated to the compliance reviewer within 24 hours of initial alert.

---

### S7. Approvals and Review
#### S7.P1
Draft findings must be reviewed and approved by a compliance reviewer before they are considered final. The reviewer must verify that all cited evidence exists and supports the finding narrative.

---

### S8. Retention
#### S8.P1
All alerts, evidence, findings, and audit records must be retained for a minimum of 7 years in the demonstration environment.

---

### S9. Limitations
#### S9.P1
This is a synthetic demonstration policy. Actual AML compliance requires adherence to applicable laws and regulations in each jurisdiction, including but not limited to the Prevention of Money Laundering Act (PMLA) and Financial Action Task Force (FATF) recommendations.
