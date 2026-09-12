# SYNTHETIC HACKATHON POLICY — NOT LEGAL, COMPLIANCE, OR REGULATORY ADVICE

## Policy: Liquidity Risk Policy
- **Policy ID:** POL-LIQ-001
- **Version:** 1
- **Effective Date:** 2026-01-01
- **Status:** Active (Demonstration Only)

---

### S1. Scope
#### S1.P1
This policy governs liquidity risk monitoring within the RegIntel Copilot demonstration. It covers sustained balance declines that may indicate liquidity stress.

---

### S2. Indicators and Rules
#### S2.1 Sustained Material Liquidity Decline (LIQ_001)
##### S2.1.P1
Monitor accounts where closing balance declines by more than 50% over a 7-day rolling window. This threshold is a demonstration value.

##### S2.1.P2
Evidence required: daily balance snapshots for the decline period, opening and closing balances, credit and debit activity contributing to the decline, and available liquidity calculations.

##### S2.1.P3
The calculation method: percentage change = ((current_balance - balance_7_days_ago) / balance_7_days_ago) * 100. A value below -50% triggers the alert.

---

### S3. Investigation Expectations
#### S3.P1
Liquidity decline alerts should assess whether the decline reflects normal business activity (e.g., scheduled payments) or indicates potential financial distress requiring escalation.

---

### S4. Escalation
#### S4.P1
Accounts showing more than 70% liquidity decline over 7 days must be escalated to the compliance reviewer with a recommendation for enhanced monitoring.

---

### S5. Limitations
#### S5.P1
This is a synthetic demonstration policy. Actual liquidity risk management requires compliance with applicable regulatory frameworks including Basel III liquidity coverage ratio requirements.
