Create docs/demo_script.md for a concise, compelling hackathon demonstration.

The story must show:
1. A compliance analyst sees a new risk signal.
2. The analyst opens the alert.
3. The application explains the exact rule and observed values.
4. The analyst reviews the source transactions.
5. The application retrieves relevant policy passages.
6. The analyst asks a natural-language question.
7. The response contains SQL-backed facts and policy-backed citations.
8. The analyst opens a case.
9. The application creates a draft finding.
10. A reviewer approves or rejects the finding.
11. The system generates an audit-ready report.
12. The audit trail proves who did what, when, and using which evidence.

Include:
- exact sample questions
- expected screens
- expected synthetic alert and case IDs
- judge-friendly talking points
- fallback steps if a Cortex capability is unavailable
- a short explanation of why the solution is not simply a dashboard
- mapping to all judging criteria
- known limitations
- suggested next steps for productionization

Also create docs/judging_criteria.md with this structure:

Real-world relevance:
- banking problem addressed
- target users
- business impact
- human-in-the-loop controls

Technical execution:
- Snowflake-native components
- explainable SQL signals
- policy retrieval
- governed natural-language interface
- auditability
- security

Solution completeness:
- signal
- investigation
- evidence
- finding
- review
- report
- audit trail