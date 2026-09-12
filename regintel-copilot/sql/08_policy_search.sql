-- ============================================================================
-- RegIntel Copilot: 08_policy_search.sql
-- SQL-based lexical search over policy chunks (fallback for no Cortex Search).
-- ============================================================================

USE ROLE REGINTEL_ADMIN;
USE DATABASE REGINTEL;
USE WAREHOUSE COMPUTE_WH;

-- Policy search view: keyword matching with relevance scoring
CREATE OR REPLACE VIEW POLICY.V_POLICY_SEARCH AS
SELECT
    CHUNK_ID, POLICY_ID, POLICY_VERSION, SECTION_ID, PARAGRAPH_ID,
    SOURCE_FILENAME, CHUNK_TEXT
FROM POLICY.POLICY_CHUNKS;

-- Search procedure: returns matching policy passages for a query
CREATE OR REPLACE PROCEDURE APP.SEARCH_POLICY(QUERY_TEXT VARCHAR)
RETURNS TABLE(POLICY_ID VARCHAR, POLICY_VERSION INTEGER, SECTION_ID VARCHAR,
    PARAGRAPH_ID VARCHAR, SOURCE_FILENAME VARCHAR, EXCERPT VARCHAR, RELEVANCE_SCORE NUMBER)
LANGUAGE SQL
AS
$$
DECLARE
    res RESULTSET;
BEGIN
    -- Simple keyword search with word-level matching
    res := (
        SELECT
            POLICY_ID, POLICY_VERSION, SECTION_ID, PARAGRAPH_ID, SOURCE_FILENAME,
            CHUNK_TEXT AS EXCERPT,
            -- Score based on keyword matches
            (CASE WHEN LOWER(CHUNK_TEXT) LIKE '%' || LOWER(:QUERY_TEXT) || '%' THEN 10 ELSE 0 END
            + ARRAY_SIZE(
                SPLIT(LOWER(CHUNK_TEXT), SPLIT_PART(LOWER(:QUERY_TEXT), ' ', 1))
              ) - 1
            ) AS RELEVANCE_SCORE
        FROM POLICY.POLICY_CHUNKS
        WHERE LOWER(CHUNK_TEXT) LIKE '%' || SPLIT_PART(LOWER(:QUERY_TEXT), ' ', 1) || '%'
           OR LOWER(CHUNK_TEXT) LIKE '%' || SPLIT_PART(LOWER(:QUERY_TEXT), ' ', 2) || '%'
           OR LOWER(CHUNK_TEXT) LIKE '%' || SPLIT_PART(LOWER(:QUERY_TEXT), ' ', 3) || '%'
        ORDER BY RELEVANCE_SCORE DESC
        LIMIT 5
    );
    RETURN TABLE(res);
END
$$;

-- Grant execute to app role
GRANT USAGE ON PROCEDURE APP.SEARCH_POLICY(VARCHAR) TO ROLE REGINTEL_APP_ROLE;
GRANT USAGE ON PROCEDURE APP.SEARCH_POLICY(VARCHAR) TO ROLE REGINTEL_ANALYST;
