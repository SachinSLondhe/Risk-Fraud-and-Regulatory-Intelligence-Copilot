Using the approved plan, create the local project structure.

Use this structure unless a Snowflake-supported convention requires a
documented adjustment:

regintel-copilot/
  README.md
  config/
    project_config.example.yml
  sql/
    00_environment_check.sql
    01_roles_and_database.sql
    02_core_tables.sql
    03_synthetic_data.sql
    04_data_quality.sql
    05_risk_features.sql
    06_risk_rules.sql
    07_alert_pipeline.sql
    08_policy_search.sql
    09_semantic_layer.sql
    10_case_management.sql
    11_audit_logging.sql
    12_demo_queries.sql
    13_cleanup.sql
  streamlit/
    streamlit_app.py
    environment.yml
    pages/
  policy_docs/
    aml_policy.md
    transaction_monitoring_policy.md
    credit_risk_policy.md
    liquidity_risk_policy.md
  tests/
    test_data_quality.sql
    test_risk_rules.sql
    test_evidence_integrity.sql
    test_rbac.sql
  docs/
    architecture.md
    threat_model.md
    demo_script.md
    judging_criteria.md

Requirements:
- Do not put secrets, account identifiers, usernames, or passwords in files.
- Add placeholders for database, warehouse, and role names.
- Include comments explaining how every file contributes to the signal,
  evidence, finding, and report workflow.
- Add a .gitignore appropriate for Python, Snowflake CLI, Streamlit, local
  environment files, and generated reports.
- Display the resulting directory tree and summarize each file.