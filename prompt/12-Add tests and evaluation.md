Create and execute the project test suite in the dedicated REGINTEL
environment.

Data tests:
- expected row counts
- unique IDs
- required fields
- valid references
- valid timestamps
- no real-looking PII
- account balance consistency
- transaction amount validity

Risk-rule tests:
- positive cases
- negative cases
- threshold boundary cases
- duplicate alert prevention
- rule version persistence
- score-component reconciliation

Evidence tests:
- every alert has a rule reference
- every finding has evidence
- evidence IDs resolve to immutable snapshots
- hashes can be recomputed
- policy citations resolve to indexed paragraphs
- exact excerpts match source content
- unsupported questions do not fabricate citations

Workflow tests:
- valid and invalid case transitions
- approved findings cannot be overwritten
- rejected findings retain history
- reviewer separation is enforced

Security tests:
- viewer cannot access RAW tables
- viewer cannot approve findings
- analyst cannot alter audit events
- application role accesses only approved objects
- no secrets appear in repository files

Application tests:
- empty states
- unavailable Cortex service
- missing policy match
- no evidence
- SQL error
- unauthorized action
- report generation
- structured-answer validation

Evaluation:
- Compare alerts with the planted synthetic-scenario validation table.
- Calculate precision, recall, and false-positive count only for synthetic
  demo data.
- Report results honestly.
- Do not tune the evaluation using hidden expected labels without documenting
  that tuning.
- Produce tests/test_results.md with passed, failed, and skipped tests.
- Fix errors where safe.
- Do not weaken tests merely to make them pass.