Create 10_case_management.sql and 11_audit_logging.sql.

Implement this workflow:

NEW ALERT
  -> OPEN CASE
  -> INVESTIGATING
  -> DRAFT FINDING
  -> REVIEW REQUIRED
  -> APPROVED or REJECTED
  -> CLOSED

Requirements:
- An alert can create a case.
- A case can reference multiple evidence records.
- Findings are versioned and immutable after approval.
- Editing an approved finding creates a new draft version.
- Only the compliance reviewer role can approve or reject a finding.
- Application users cannot delete audit events.
- Store evidence snapshots so later data changes do not alter the original
  investigation basis.
- Hash evidence payloads to demonstrate integrity.
- Store policy ID and policy version used by each finding.
- Store generated-by and approved-by separately.
- Store the underlying Snowflake query ID where available.
- Clearly label machine-generated narrative.
- Record every state transition.
- Prevent illegal state transitions.
- Add views for:
  - open cases
  - cases awaiting review
  - approved findings
  - evidence history
  - complete case timeline
- Create sample procedures or controlled transactions for state changes.
- Do not create autonomous reporting or submission to external regulators.
- Add SQL tests for permissions, immutability, state transitions, and evidence
  completeness.