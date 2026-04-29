-- Databricks notebook source
-- DBTITLE 1,Use catalog
USE CATALOG DEMO_PATIENT

-- COMMAND ----------

-- DBTITLE 1,Create silver table
CREATE OR REFRESH MATERIALIZED VIEW SILVER.PATIENT_SILVER AS
SELECT
  *,
  CASE
    WHEN
      TRIM(age) > 0
      and TRIM(age) < 18
    THEN
      'child'
    WHEN
      TRIM(age) >= 18
      and TRIM(age) < 65
    THEN
      'adult'
    WHEN TRIM(age) >= 65 THEN 'senior'
    ELSE 'unknown'
  END as age_group
FROM
  BRONZE.PATIENT_BRONZE
WHERE
  TRY_CAST(TRIM(age) as INT) is not NULL
  AND (
    TRY_CAST(TRIM(zipcode) as INT) is not NULL
    and LEN(zipcode) = 5
  )
