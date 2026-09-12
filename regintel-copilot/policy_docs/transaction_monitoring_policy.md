# SYNTHETIC HACKATHON POLICY — NOT LEGAL, COMPLIANCE, OR REGULATORY ADVICE

## Policy: Transaction Monitoring Policy
- **Policy ID:** POL-TXM-001
- **Version:** 1
- **Effective Date:** 2026-01-01
- **Status:** Active (Demonstration Only)

---

### S1. Scope
#### S1.P1
This policy governs the monitoring of transaction patterns for fraud detection within the RegIntel Copilot demonstration. It covers velocity anomalies, device-based risk signals, and mule account detection.

---

### S2. Indicators and Rules
#### S2.1 Transaction Velocity Anomaly (FRD_001)
##### S2.1.P1
Monitor for accounts with more than 10 transactions within a 1-hour window. This threshold is a demonstration value.

##### S2.1.P2
Evidence required: transaction count within the window, individual transaction details, device and channel information, and account holder profile.

#### S2.2 New Device High Value (FRD_002)
##### S2.2.P1
Flag transactions exceeding 100,000 INR from devices not previously associated with the account within a 90-day lookback period.

##### S2.2.P2
Investigation must verify: device identifier, transaction amount, historical device usage for the account, and whether the account holder reported a new device.

#### S2.3 Potential Mule Account (FRD_003)
##### S2.3.P1
Detect accounts receiving funds from 3 or more distinct counterparties where 70% or more of the received amount is subsequently transferred out within a 7-day window.

##### S2.3.P2
Evidence required: all incoming transaction details with counterparty IDs, outbound transaction details, percentage of funds moved, time between credits and debits, and destination account analysis.

---

### S3. Investigation Expectations
#### S3.P1
Fraud alerts should be investigated with priority given to the potential financial impact. Multiple concurrent rule triggers on the same account indicate higher priority.

---

### S4. Evidence Requirements
#### S4.P1
Transaction monitoring evidence must preserve the exact timestamps, amounts, counterparty identifiers, and channel information for all transactions in the analysis window.

---

### S5. Escalation
#### S5.P1
Accounts triggering both FRD_001 (velocity) and FRD_003 (mule behavior) simultaneously must be escalated immediately to the compliance review team.

---

### S6. Limitations
#### S6.P1
This is a synthetic demonstration policy. All thresholds are for hackathon demonstration purposes only and do not represent regulatory requirements.
