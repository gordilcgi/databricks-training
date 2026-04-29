-- Databricks notebook source
-- MAGIC %md
-- MAGIC Consume data from the raw file and store data into bronze table.

-- COMMAND ----------

USE CATALOG DEMO_CATALOG

-- COMMAND ----------

CREATE OR REFRESH STREAMING TABLE bronze.table_bronze AS
SELECT * EXCEPT(_rescued_data), 
       _metadata.file_path AS source_file, 
       current_timestamp() AS processing_time
FROM
  STREAM read_files('/Volumes/demo_catalog/demo_schema/demo_volume/jobsfiles', format => 'csv');
