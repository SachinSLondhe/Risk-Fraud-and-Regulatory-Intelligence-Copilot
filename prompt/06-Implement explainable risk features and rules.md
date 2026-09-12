Create 05_risk_features.sql and 06_risk_rules.sql.

Implement deterministic, configurable, explainable features for:
- transaction amount versus customer expected monthly turnover
- transaction amount versus trailing account behavior
- credits and debits inside configurable rolling windows
- number of transactions inside configurable rolling windows
- distinct destination countries
- first-seen device indicator
- first-seen counterparty indicator
- dormant-days-before-transaction
- percentage of incoming funds moved out
- time between incoming and outgoing transactions
- number of unique credit originators
- credit utilization
- liquidity decline percentage
- circular account flow indicators

Implement at least these versioned rules:
- AML_001: structuring
- AML_002: rapid movement of funds
- AML_003: dormant account reactivation
- AML_004: unusual transaction geography
- FRD_001: transaction velocity
- FRD_002: new device plus high-value transaction
- FRD_003: potential mule-account behavior
- CRD_001: sudden credit utilization increase
- LIQ_001: sustained material liquidity decline

For every triggered rule, return:
- RULE_ID
- RULE_VERSION
- RULE_NAME
- risk domain
- threshold used
- actual observed value
- risk contribution
- transaction or balance-date evidence
- a concise deterministic explanation
- policy reference key
- evaluation timestamp

Create a combined RISK.V_ALERT_CANDIDATES view.

Important:
- Do not ask an LLM to calculate numeric risk.
- Do not label an account fraudulent.
- Use language such as “risk signal detected” or “requires review.”
- Document all thresholds as hackathon demonstration values, not regulatory
  requirements.
- Avoid duplicate alerts for the same rule, account, transaction, and
  evaluation window.
- Include reason codes so an auditor can reconstruct the score.
- Add unit tests for positive, negative, and boundary conditions.
- Compare generated results with the hidden planted-scenario table and show
  precision and recall only for the synthetic dataset.