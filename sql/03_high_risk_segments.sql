-- ============================================================================
-- 03 — Rank the highest-risk subscriber segments (window functions)
-- ----------------------------------------------------------------------------
-- Segment = Contract x PaymentMethod x InternetService — the "less-committed"
-- profile the EDA flagged. We aggregate churn per segment, drop tiny/noisy
-- segments, then use window functions to RANK them and compare each against the
-- average segment churn. Output = a prioritized at-risk list for retention.
--
-- Dialect: PostgreSQL (also runs on DuckDB). One CTE per logical step.
-- ============================================================================

WITH base AS (
    -- Step 1: select the three segment dimensions + encode the target.
    SELECT
        Contract        AS plan_type,
        PaymentMethod   AS payment_method,
        InternetService AS internet_service,
        CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END AS is_churned
    FROM subscribers
),

segment_summary AS (
    -- Step 2: churn rate per unique segment.
    SELECT
        plan_type,
        payment_method,
        internet_service,
        COUNT(*)        AS subscribers,
        AVG(is_churned) AS churn_rate
    FROM base
    GROUP BY plan_type, payment_method, internet_service
),

actionable_segments AS (
    -- Step 3: keep only segments large enough to act on (avoid noisy tiny cells).
    SELECT *
    FROM segment_summary
    WHERE subscribers >= 50
),

ranked AS (
    -- Step 4: window functions — rank by risk, and expose the cohort-wide
    -- average so each segment can be read relative to the pack.
    SELECT
        plan_type,
        payment_method,
        internet_service,
        subscribers,
        churn_rate,
        RANK() OVER (ORDER BY churn_rate DESC) AS risk_rank,
        AVG(churn_rate) OVER ()                AS avg_segment_churn
    FROM actionable_segments
)

-- Step 5: present the top 10 riskiest segments vs the average.
SELECT
    risk_rank,
    plan_type,
    payment_method,
    internet_service,
    subscribers,
    ROUND(churn_rate * 100, 1)        AS churn_rate_pct,
    ROUND(avg_segment_churn * 100, 1) AS avg_segment_churn_pct
FROM ranked
WHERE risk_rank <= 10
ORDER BY risk_rank;
