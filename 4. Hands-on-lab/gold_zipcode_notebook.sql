-- Databricks notebook source
-- DBTITLE 1,Use catalog
USE CATALOG DEMO_PATIENT

-- COMMAND ----------

-- DBTITLE 1,Create temp view from silver
CREATE OR REPLACE TEMPORARY VIEW gold_zipcode_view AS
SELECT
  zipcode,
  count(*) as number_of_er_visits
FROM
  SILVER.PATIENT_SILVER
GROUP BY
  zipcode

-- COMMAND ----------

-- DBTITLE 1,Merge into Gold table
MERGE INTO
  GOLD.PATIENT_GOLD_ZIPCODE AS TARGET
USING
  gold_zipcode_view AS SOURCE
ON
  TARGET.zipcode = SOURCE.zipcode
WHEN MATCHED THEN UPDATE SET *
WHEN NOT MATCHED THEN INSERT *
