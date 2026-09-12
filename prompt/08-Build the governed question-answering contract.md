Design the application-level question-answering contract.

The copilot must support:
- alert and account investigation
- transaction-risk explanation
- policy questions
- liquidity-risk summaries
- credit-risk summaries
- evidence collection
- draft finding generation
- report generation

Every answer must contain this structured response:

{
  "answer_status": "SUPPORTED | PARTIALLY_SUPPORTED | NOT_SUPPORTED",
  "summary": "...",
  "risk_signals": [
    {
      "rule_id": "...",
      "rule_version": "...",
      "observed_value": "...",
      "threshold": "...",
      "explanation": "..."
    }
  ],
  "transaction_evidence": [
    {
      "transaction_id": "...",
      "timestamp": "...",
      "amount": "...",
      "source_view": "..."
    }
  ],
  "policy_evidence": [
    {
      "policy_id": "...",
      "policy_version": "...",
      "section_id": "...",
      "paragraph_id": "...",
      "source_filename": "...",
      "excerpt": "..."
    }
  ],
  "limitations": [],
  "recommended_human_action": "...",
  "generated_at": "...",
  "query_id": "..."
}

Rules:
- SQL results are the source of truth for customer, account, transaction,
  alert, and risk values.
- Retrieved policy passages are the only source for policy statements.
- Separate facts from interpretations.
- If sources conflict, show the conflict.
- If no policy passage is retrieved, do not create a policy citation.
- If no data evidence exists, return NOT_SUPPORTED.
- Never expose generated SQL containing sensitive literals to a viewer role.
- Log the question, source objects, query IDs, output status, and evidence
  references.
- Do not log secrets or unnecessary sensitive values.
- Findings remain DRAFT until a compliance reviewer approves them.

If Cortex Analyst or a semantic layer is available, create the minimum
governed semantic object needed for approved curated views. If not available,
implement parameterized query templates. Do not expose unrestricted
natural-language-to-SQL against RAW schemas.