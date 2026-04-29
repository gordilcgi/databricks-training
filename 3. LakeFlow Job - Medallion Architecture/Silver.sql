-- Databricks notebook source
-- MAGIC %md
-- MAGIC Use bronze data, clean data, transform data, validate data etc.

-- COMMAND ----------

-- DBTITLE 1,Use Demo_catalog
USE CATALOG demo_catalog

-- COMMAND ----------

-- DBTITLE 1,Create Temporary View from Bronze Table
CREATE OR REPLACE TEMPORARY VIEW silver_vw AS
SELECT
  b.* EXCEPT (state, processing_time),
  COALESCE(s.state_abbr, 'N/A') AS state,
  current_timestamp() AS processing_time
FROM
  bronze.table_bronze b
    LEFT JOIN reference.states s
      ON b.state = s.state_name
WHERE
  b.state IS NOT NULL
  AND b.age IS NOT NULL
  AND TRY_CAST(b.age AS INT) > 0
  AND b.name IS NOT NULL;

-- COMMAND ----------

-- DBTITLE 1,Insert the data into Silver Table
CREATE OR REPLACE TABLE silver.table_silver AS
SELECT
  *
from
  silver_vw;
