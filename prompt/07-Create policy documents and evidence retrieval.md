Create four clearly labeled synthetic demonstration policy documents:

1. policy_docs/aml_policy.md
2. policy_docs/transaction_monitoring_policy.md
3. policy_docs/credit_risk_policy.md
4. policy_docs/liquidity_risk_policy.md

Each document must:
- State prominently that it is a synthetic hackathon policy and not legal,
  compliance, or regulatory advice.
- Have a policy ID and version.
- Have effective date fields.
- Use numbered sections and stable paragraph IDs.
- Define scope, control objective, indicators, investigation expectations,
  evidence requirements, escalation, approvals, retention, and limitations.
- Map policy sections to the risk rule IDs.
- Avoid claiming that a rule or threshold is required by AML, Basel, RBI, or
  any other regulator unless an authoritative source has been provided.
- Do not copy copyrighted or proprietary policy language.

Then:
1. Create a Snowflake stage suitable for loading these markdown files.
2. Generate loading instructions rather than assuming local file access.
3. Create a chunking process that preserves POLICY_ID, POLICY_VERSION,
   SECTION_ID, PARAGRAPH_ID, and source filename.
4. If Cortex Search is enabled, create a search service over the policy chunks.
5. If Cortex Search is not enabled, create a fallback SQL lexical search over
   the policy chunks.
6. Build a test query such as:
   “What evidence is required when rapid movement of funds is detected?”
7. Ensure every returned passage includes policy ID, version, section,
   paragraph ID, filename, and exact excerpt.
8. Never return a policy citation that was not retrieved from the indexed
   content.
9. Document how policy-version changes are handled without silently rewriting
   historical findings.