Act as the lead Snowflake solution architect, data engineer, security engineer,
AI engineer, and Streamlit developer for a hackathon application named
RegIntel Copilot.

Problem statement:
Banking and NBFC teams need to manage fraud, liquidity risk, credit risk, AML
investigations, regulatory reporting, and policy compliance. Build a copilot
that combines transaction and account data with policy text. A business or
compliance user must be able to ask natural-language questions and receive
governed, explainable, evidence-backed answers. The application must cover the
flow from risk signal to evidence to documented finding and report.

Primary judging criteria:
1. Real-world relevance
2. Technical execution
3. Solution completeness

Build a working Snowflake-native MVP using:
- Snowflake tables and views
- SQL-based explainable risk rules
- synthetic data only
- Cortex Search for policy retrieval, if enabled
- a semantic layer or Cortex Analyst only if available
- Cortex Agent only if available
- Streamlit in Snowflake
- audit logging
- evidence and citation tracking
- role-based access control
- report generation

Non-negotiable controls:
- Never use real customer data or personally identifiable information.
- Do not invent evidence, transaction IDs, policy passages, risk scores,
  regulatory citations, or source references.
- All risk scores must come from deterministic SQL or explicitly documented
  calculations.
- AI-generated findings must be labeled as draft until human approval.
- Every answer must include source transaction IDs, applicable rule IDs,
  evidence timestamps, and policy passage references.
- If evidence is unavailable, clearly state that evidence was not found.
- Do not make autonomous decisions to block accounts, reject customers, or
  file regulatory reports.
- Use least-privilege roles.
- Do not create external network access.
- Do not drop or replace existing objects outside the project database.
- Use CREATE IF NOT EXISTS where practical.
- Prefix project objects with REGINTEL or place them in a dedicated
  REGINTEL database.
- Make all names configurable.
- Generate reproducible scripts and a README.

First:
1. Inspect the current directory.
2. Inspect my current Snowflake role and accessible capabilities.
3. Determine whether Cortex Search, Cortex Analyst, Cortex Agents, Streamlit,
   and document processing functions are enabled.
4. Do not change anything yet.
5. Produce a phased implementation plan.
6. List assumptions, dependencies, security risks, and fallback approaches.
7. Show the proposed folder structure.
8. Wait for my review before executing the implementation.