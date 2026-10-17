-- ============================================================================
-- 02 — Churn vs retention rate by plan type (Contract)
-- ----------------------------------------------------------------------------
-- The EDA found `Contract` to be the single strongest churn driver. This query
-- quantifies it as a clean retention table the business can act on.
--
-- Dialect: PostgreSQL (also runs on DuckDB). One CTE per logical step.
-- ============================================================================

WITH base AS (
    -- Step 1: select the plan dimension + encode the target as 0/1.
    SELECT
        Contract AS plan_type,
        CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END AS is_churned
    FROM subscribers
),

plan_summary AS (
    -- Step 2: aggregate volume and churn per plan type.
    SELECT
        plan_type,
        COUNT(*)        AS subscribers,
        SUM(is_churned) AS churned,
        AVG(is_churned) AS churn_rate
    FROM base
    GROUP BY plan_type
)

-- Step 3: present churn AND its complement (retention), worst plan first.
SELECT
    plan_type,
    subscribers,
    churned,
    ROUND(churn_rate * 100, 1)       AS churn_rate_pct,
    ROUND((1 - churn_rate) * 100, 1) AS retention_rate_pct
FROM plan_summary
ORDER BY churn_rate DESC;
