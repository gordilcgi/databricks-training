-- Databricks notebook source
-- DBTITLE 1,Use catalog
USE CATALOG DEMO_PATIENT

-- COMMAND ----------

-- DBTITLE 1,Bronze table
CREATE OR REFRESH STREAMING TABLE BRONZE.PATIENT_BRONZE AS
SELECT
  *
FROM
  STREAM read_files(
    args['file_location'],
    format => 'csv',
    delimiter => '|',
    mergeSchema => true
  )
