-- ============================================================================
-- 01 — Churn rate by tenure cohort
-- ----------------------------------------------------------------------------
-- NOTE on framing: this dataset has NO signup/acquisition date — only `tenure`
-- (months as a subscriber). A calendar-month acquisition cohort is therefore
-- impossible without fabricating dates. We cohort by TENURE BAND instead: the
-- same "lifecycle stage" lens the EDA used to surface the early-churn danger
-- window. Each cohort answers "how do subscribers of this age churn?".
--
-- Dialect: PostgreSQL (also runs on DuckDB). One CTE per logical step.
-- ============================================================================

WITH base AS (
    -- Step 1: keep only what we need + encode the target as 0/1.
    SELECT
        tenure,
        CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END AS is_churned
    FROM subscribers
),

tenure_cohort AS (
    -- Step 2: assign each subscriber to a tenure band (the "cohort").
    SELECT
        CASE
            WHEN tenure <= 3  THEN '00-03 months'
            WHEN tenure <= 6  THEN '04-06 months'
            WHEN tenure <= 12 THEN '07-12 months'
            WHEN tenure <= 24 THEN '13-24 months'
            WHEN tenure <= 48 THEN '25-48 months'
            ELSE                   '49-72 months'
        END AS cohort,
        is_churned
    FROM base
),

cohort_summary AS (
    -- Step 3: aggregate churn per cohort.
    SELECT
        cohort,
        COUNT(*)        AS subscribers,
        SUM(is_churned) AS churned,
        AVG(is_churned) AS churn_rate
    FROM tenure_cohort
    GROUP BY cohort
)

-- Step 4: present, formatted as percentages and ordered by lifecycle stage.
SELECT
    cohort,
    subscribers,
    churned,
    ROUND(churn_rate * 100, 1) AS churn_rate_pct
FROM cohort_summary
ORDER BY cohort;
