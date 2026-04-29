-- Databricks notebook source
-- MAGIC %md
-- MAGIC Consume data from the raw file and store data into bronze table.

-- COMMAND ----------

-- MAGIC %run ./Setup/python_utilities

-- COMMAND ----------

-- DBTITLE 1,Use Demo catalog
USE CATALOG demo_catalog

-- COMMAND ----------

-- DBTITLE 1,Read data file and create temp view
CREATE OR REPLACE TEMPORARY VIEW raw_data AS
SELECT * EXCEPT(_rescued_data), 
       _metadata.file_path AS source_file, 
       current_timestamp() AS processing_time
FROM read_files('/Volumes/demo_catalog/demo_schema/demo_volume/jobsfiles', format => 'csv');

-- COMMAND ----------

-- DBTITLE 1,Insert data into Bronze table
INSERT INTO bronze.table_bronze BY NAME
  SELECT
    *
  FROM
    raw_data;

-- COMMAND ----------

-- DBTITLE 1,Archive files
-- MAGIC %python
-- MAGIC move_files(move_from='/Volumes/demo_catalog/demo_schema/demo_volume/jobsfiles/', move_to='/Volumes/demo_catalog/demo_schema/demo_volume/jobsfiles/archive/', n=1)
