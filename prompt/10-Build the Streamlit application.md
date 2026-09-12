Build a polished Streamlit in Snowflake application for RegIntel Copilot.

Navigation:
1. Executive Overview
2. Risk Signal Monitor
3. Alert Investigation
4. Evidence Explorer
5. Policy Intelligence
6. Case Management
7. Regulatory Report Builder
8. Audit Trail
9. About and Limitations

Executive Overview:
- alerts by risk domain and severity
- alert trend
- open cases
- cases awaiting review
- top explainable rule triggers
- liquidity-risk indicator
- clear synthetic-data banner

Risk Signal Monitor:
- filters for date, domain, severity, rule, and status
- sortable alerts
- display reason codes and risk components
- avoid red-only color encoding

Alert Investigation:
- alert summary
- customer and account context from approved curated views
- transaction timeline
- triggered rules
- observed value versus threshold
- linked evidence
- retrieved policy passages
- open-case action

Copilot interaction:
- natural-language question box
- suggested questions
- structured answer sections
- visible source references
- evidence drawer
- limitations section
- no unsupported answer when evidence is missing

Case Management:
- case state
- evidence checklist
- draft finding narrative
- policy citations
- reviewer comments
- approve and reject controls visible only to authorized reviewers

Report Builder:
- generate a draft investigation report from a selected case
- include report version, case ID, alert IDs, evidence table, applicable policy
  passages, analyst conclusion, limitations, review status, and audit metadata
- support downloadable HTML or another format supported safely in Streamlit
- watermark unapproved reports as DRAFT

Audit Trail:
- timestamp
- user
- action
- case or alert ID
- query ID
- status
- hide sensitive request content when not authorized

Engineering requirements:
- Use Snowpark session access.
- Use parameterized Snowflake queries.
- Do not embed passwords or tokens.
- Separate data-access functions from UI.
- Handle no-data, permission, and AI-service errors gracefully.
- Use caching only where it cannot leak role-specific data.
- Add accessible labels and explanatory tooltips.
- Use a professional banking and compliance visual style.
- Add a persistent disclaimer that the application provides decision support,
  not an autonomous fraud determination.
- Add sample questions optimized for the demo.
- Add comments describing how to deploy in Streamlit in Snowflake.
- Validate Python syntax and imports.