Create 03_synthetic_data.sql that generates a realistic but entirely synthetic
banking dataset.

Target demo scale:
- 500 synthetic customers
- 700 accounts
- approximately 50,000 transactions
- 90 days of account balances and transactions
- 25 to 50 intentionally suspicious scenarios

Include normal patterns and these controlled suspicious scenarios:
1. Structuring: repeated transactions immediately below a configurable
   threshold.
2. Rapid movement: incoming funds followed quickly by outgoing funds.
3. Dormant account reactivation with unusually high value activity.
4. Unusual geography: transaction country inconsistent with account history.
5. Velocity anomaly: many transactions in a short period.
6. New counterparty concentration.
7. Circular movement among a small group of accounts.
8. Sudden utilization of a large percentage of available credit.
9. Material liquidity decline over consecutive balance dates.
10. Potential mule behavior: multiple unrelated credits followed by an
    aggregated debit.

Requirements:
- Use deterministic seeded generation so the dataset can be recreated.
- Create a SCENARIO_ID for planted scenarios, but keep it in a protected
  validation table rather than exposing it to the application.
- Do not use actual personal names, addresses, email addresses, phone numbers,
  government IDs, or real account numbers.
- Use clearly fictitious country and branch combinations where possible.
- Separate data generation from test assertions.
- Record the expected alerts for planted scenarios in a test-only table.
- Add data distributions that avoid making every high-value transaction
  fraudulent.
- Generate both true-positive and benign edge cases.
- Ensure referential integrity.
- Make row volumes configurable.

After generating the SQL:
1. Explain the synthetic patterns.
2. Explain how false positives are represented.
3. Execute only if the target schemas are confirmed as dedicated to this
   project.
4. Run row-count, null, duplicate, and referential-integrity checks.