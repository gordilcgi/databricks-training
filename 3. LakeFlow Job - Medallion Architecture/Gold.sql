-- Databricks notebook source
-- MAGIC %md
-- MAGIC Use silver data and create the aggregated data for downstream consumption like BI, AI etc.

-- COMMAND ----------

-- DBTITLE 1,Use Demo Catalog
USE CATALOG demo_catalog

-- COMMAND ----------

-- DBTITLE 1,Create Gold data from silver table
-- Aggregate and pivot data from silver.table_silver
WITH age_grouped AS (
  SELECT
    state,
    CASE
      WHEN age BETWEEN 0 AND 9 THEN '0-9'
      WHEN age BETWEEN 10 AND 19 THEN '10-19'
      WHEN age BETWEEN 20 AND 29 THEN '20-29'
      WHEN age BETWEEN 30 AND 39 THEN '30-39'
      WHEN age BETWEEN 40 AND 49 THEN '40-49'
      WHEN age BETWEEN 50 AND 59 THEN '50-59'
      WHEN age BETWEEN 60 AND 69 THEN '60-69'
      WHEN age BETWEEN 70 AND 79 THEN '70-79'
      WHEN age >= 80 THEN '80+'
      ELSE 'Unknown'
    END AS age_group,
    covid_status
  FROM
    silver.table_silver
),
aggregated AS (
  SELECT
    state,
    age_group,
    COUNT(*) AS total_tests,
    SUM(
      CASE
        WHEN upper(covid_status) = 'P' THEN 1
        ELSE 0
      END
    ) AS positive,
    SUM(
      CASE
        WHEN upper(covid_status) = 'N' THEN 1
        ELSE 0
      END
    ) AS negative
  FROM
    age_grouped
  GROUP BY
    state,
    age_group
) -- Merge aggregated data into gold.table_gold
MERGE INTO
  gold.table_gold AS gold
USING
  aggregated AS src
ON
  gold.state = src.state
  AND gold.age_group = src.age_group
WHEN MATCHED THEN UPDATE SET
  gold.total_tests = src.total_tests,
  gold.positive = src.positive,
  gold.negative = src.negative,
  gold.update_time = current_timestamp()
WHEN NOT MATCHED THEN INSERT (state, age_group, total_tests, positive, negative, update_time)
  VALUES (src.state, src.age_group, src.total_tests, src.positive, src.negative, current_timestamp());

-- COMMAND ----------

select * from gold.table_gold
order by 1, 2
