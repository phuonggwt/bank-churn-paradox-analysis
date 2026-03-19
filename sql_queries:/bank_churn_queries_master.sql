-- =============================================================================
-- PROJECT: BANK CHURN ANALYSIS
-- PURPOSE: Data Cleaning, Feature Engineering & Strategic Insights
-- AUTHOR: Nguyen Thu Phuong
-- =============================================================================

-- -----------------------------------------------------------------------------
-- STEP 1: DATA CLEANING & FEATURE ENGINEERING
-- Goal: Create a cleaned table with segmented dimensions for better analysis.
-- -----------------------------------------------------------------------------
CREATE OR REPLACE TABLE `my-project-1-490219.bank_churn_analysis.bank_churn_cleaned` AS

SELECT *,
-- 1. KPI MAPPING
CASE 
    WHEN churn = 1 THEN 'Churned'
    ELSE 'Retained'
END AS churn_status,

-- 2. ENGAGEMENT MAPPING
CASE 
    WHEN active_member = 1 THEN 'Active' 
    ELSE 'Inactive' 
END AS activity_status,

-- 3. DEMOGRAPHIC SEGMENTATION
CASE 
    WHEN age < 30 THEN 'Under 30'
    WHEN age BETWEEN 30 AND 50 THEN '30-50'
    ELSE 'Over 50' 
END AS age_segment,

-- 4. CREDIT RISK PROFILING
CASE 
    WHEN credit_score >= 800 THEN '1. Exceptional'
    WHEN credit_score >= 740 THEN '2. Very Good'
    WHEN credit_score >= 670 THEN '3. Good'
    WHEN credit_score >= 580 THEN '4. Fair'
    ELSE '5. Poor' 
END AS credit_category,

-- 5. WEALTH & SPENDING HABITS
CASE 
    WHEN estimated_salary > 100000 AND balance > 50000 THEN 'Wealth Accumulators'
    WHEN estimated_salary > 100000 AND balance <= 50000 THEN 'High Spenders'
    WHEN estimated_salary <= 100000 AND balance > 50000 THEN 'Savers'
    ELSE 'Marginal'
END AS financial_persona,

-- 6. ANOMALY DETECTION
CASE 
    WHEN credit_score >= 700 AND balance = 0 THEN 'High Credit - Zero Balance'
    WHEN credit_score < 600 AND balance > 100000 THEN 'Low Credit - High Asset'
    ELSE 'Standard'
END AS behavior_paradox

-- 7. LOYALTY & TENURE MAPPING
CASE 
    WHEN tenure <= 2 THEN '1. Newbie (0-2y)'
    WHEN tenure BETWEEN 3 AND 7 THEN '2. Standard (3-7y)'
    ELSE '3. Veteran (>7y)'
END AS tenure_segment

-- 8. WEALTH MAPPING (NEW)
CASE 
    WHEN balance = 0 THEN '1. Zero Balance'
    WHEN balance > 0 AND balance <= 50000 THEN '2. Low (1-50k)'
    WHEN balance > 50000 AND balance <= 100000 THEN '3. Mid (50k-100k)'
    WHEN balance > 100000 AND balance <= 150000 THEN '4. High (100k-150k)'
    ELSE '5. Ultra High (>150k)'
END AS balance_segment

FROM `my-project-1-490219.bank_churn_analysis.raw_bank_churners`
WHERE 
    age BETWEEN 18 AND 100
    AND credit_score IS NOT NULL;
    
-- -----------------------------------------------------------------------------
-- STEP 2: ANALYTICAL QUERIES (For Visualizations)
-- -----------------------------------------------------------------------------

-- PART 1: GEOGRAPHIC ANALYSIS WITH GLOBAL BENCHMARK
-- This query combines country-level churn and the overall average in one table.

SELECT 
    country,
    COUNT(*) AS total_customers,
    SUM(churn) AS churned_customers,
    ROUND(AVG(churn) * 100, 2) AS churn_rate_percentage,
    
    -- Calculating the Global Average 

    ROUND(
        100 * (SUM(SUM(churn)) OVER() / SUM(COUNT(*)) OVER()), 
        2
    ) AS global_avg_churn

FROM `my-project-1-490219.bank_churn_analysis.bank_churn_cleaned`
GROUP BY country
ORDER BY churn_rate_percentage DESC;

-- PART 2: THE "WHO" ANALYSIS (DEMOGRAPHICS & WEALTH)
SELECT 
    Gender,
    age_segment,
    financial_persona,
    COUNT(*) AS total_customers,
    SUM(churn) AS churned_customers,
    ROUND(AVG(churn) * 100, 2) AS churn_rate_percentage
FROM `my-project-1-490219.bank_churn_analysis.bank_churn_cleaned`
GROUP BY 1, 2, 3
ORDER BY churn_rate_percentage DESC;

-- PART 3.1: VETERAN INACTIVITY
SELECT 
    activity_status,
    tenure_segment,
    COUNT(*) AS total_customers,
    ROUND(AVG(churn) * 100, 2) AS churn_rate_percentage
FROM `my-project-1-490219.bank_churn_analysis.bank_churn_cleaned`
GROUP BY 1, 2
ORDER BY churn_rate_percentage DESC;

-- PART 3.2: CREDIT SCORE VS CHURN RATE (FOCUS ON GERMANY)
-- Target: Export to "paradox2_credit_score_germany.csv"

SELECT 
  country,
  credit_category,
    COUNT(*) AS total_customers,
    SUM(churn) AS churned_customers,
    ROUND(AVG(churn) * 100, 2) AS churn_rate_percentage
FROM `my-project-1-490219.bank_churn_analysis.bank_churn_cleaned`
GROUP BY 1, 2
ORDER BY churn_rate_percentage DESC;

-- PART 3.3: PRODUCT OVERLOAD VS CHURN RATE

SELECT 
    products_number,
    COUNT(*) AS total_customers,
    SUM(churn) AS churned_customers,
    ROUND(AVG(churn) * 100, 2) AS churn_rate_percentage
FROM `my-project-1-490219.bank_churn_analysis.bank_churn_cleaned`
GROUP BY 1
ORDER BY churn_rate_percentage DESC;

-- PART 3.4: Track the loss of customers from the total base to the final active count

SELECT 
    'Total Starting' AS category, 
    COUNT(*) AS customer_count,
    1 AS sort_order
FROM `my-project-1-490219.bank_churn_analysis.bank_churn_cleaned`

UNION ALL

SELECT 
    CONCAT('Loss: ', country) AS category, 
    -SUM(churn) AS customer_count, -- Negative because it's a loss
    CASE 
        WHEN country = 'Germany' THEN 2 
        WHEN country = 'France' THEN 3 
        ELSE 4 
    END AS sort_order
FROM `my-project-1-490219.bank_churn_analysis.bank_churn_cleaned`
GROUP BY country

ORDER BY sort_order;
