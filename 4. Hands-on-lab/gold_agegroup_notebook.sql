-- Databricks notebook source
-- DBTITLE 1,Use Catalog
USE CATALOG DEMO_PATIENT

-- COMMAND ----------

-- DBTITLE 1,Create temp view from silver
CREATE OR REPLACE TEMPORARY VIEW gold_agegroup_view AS
SELECT
  age_group,
  diagnosis_category,
  count(*) as number_of_er_visits
FROM
  SILVER.PATIENT_SILVER
GROUP BY
  age_group,
  diagnosis_category

-- COMMAND ----------

-- DBTITLE 1,Merge into Gold table
MERGE INTO
  GOLD.PATIENT_GOLD_AGEGROUP AS TARGET
USING
  gold_agegroup_view AS SOURCE
ON
  TARGET.age_group = SOURCE.age_group
WHEN MATCHED AND TARGET.diagnosis_category = SOURCE.diagnosis_category THEN UPDATE SET *
WHEN NOT MATCHED THEN INSERT *
