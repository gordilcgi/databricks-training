-- Databricks notebook source
-- MAGIC %md
-- MAGIC ####MERGE INTO
-- MAGIC MERGE INTO in Databricks is a powerful tool for data ingestion, especially for data ingestion. It enables efficient, atomic, scalable upsert and delete operations. This command is useful when you have an existing Delta table and you wish to combine incoming data. 
-- MAGIC
-- MAGIC - Utilize MERGE INTO to perform updates, inserts, and deletes on Delta tables.
-- MAGIC - Apply MERGE INTO with schema enforcement to manage data integrity.
-- MAGIC - Apply MERGE INTO with schema evolution to evolve the target tables.
-- MAGIC
-- MAGIC As a part of ingestion, you can perform inserts, updates and deletes using data from a source table, view, or DataFrame into a target Delta table using the `MERGE` SQL operation. Delta Lake supports inserts, updates and deletes in `MERGE`, and supports extended syntax beyond the SQL standards to facilitate advanced use cases.
-- MAGIC <br></br>
-- MAGIC
-- MAGIC ```
-- MAGIC MERGE INTO target t
-- MAGIC USING source s
-- MAGIC ON {merge_condition}
-- MAGIC WHEN MATCHED THEN {matched_action}
-- MAGIC WHEN NOT MATCHED THEN {not_matched_action}
-- MAGIC ```

-- COMMAND ----------

-- DBTITLE 1,Get Merge Dependencies
-- MAGIC %run ./Setup/Setup_002

-- COMMAND ----------

-- DBTITLE 1,Create demo merge schema
CREATE SCHEMA IF NOT EXISTS
demo_catalog.demo_merge

-- COMMAND ----------

-- DBTITLE 1,set default catalog
USE CATALOG DEMO_CATALOG

-- COMMAND ----------

-- DBTITLE 1,Create target table using new file
CREATE OR REPLACE TABLE demo_merge.test_health_data
AS
SELECT * EXCEPT(_rescued_data)
FROM 
read_files('/Volumes/demo_catalog/demo_schema/demo_volume/merge_target/', FORMAT => 'csv')

-- COMMAND ----------

-- DBTITLE 1,View main target health data table
SELECT * FROM demo_merge.test_health_data

-- COMMAND ----------

-- DBTITLE 1,Create the update table using update file
CREATE OR REPLACE TABLE demo_merge.update_health_data
AS
SELECT * EXCEPT(_rescued_data)
FROM 
read_files('/Volumes/demo_catalog/demo_schema/demo_volume/merge_source/', FORMAT => 'csv')

-- COMMAND ----------

-- DBTITLE 1,View the table that contains the updates
SELECT *
FROM demo_merge.update_health_data

-- COMMAND ----------

-- DBTITLE 1,Merge the updates into the main table
MERGE INTO demo_merge.test_health_data target
USING demo_merge.update_health_data source
ON target.id = source.id
WHEN MATCHED AND source.status = 'update' THEN
  UPDATE SET 
    target.diagnosis = source.diagnosis,
    target.last_visit = source.last_visit
WHEN MATCHED AND source.status = 'delete' THEN
  DELETE
WHEN NOT MATCHED THEN
  INSERT (id, patient_name, diagnosis, last_visit)
  VALUES (source.id, source.patient_name, source.diagnosis, source.last_visit);

-- COMMAND ----------

-- DBTITLE 1,View the updated table
SELECT *
FROM demo_merge.test_health_data;

-- COMMAND ----------

-- DBTITLE 1,View the history of the updated table
DESCRIBE HISTORY demo_merge.test_health_data;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC You can use `VERSION AS OF` to query a specific version of the table. Query version *1* of the table to view the original data. 

-- COMMAND ----------

-- DBTITLE 1,Use time travel to view the original table
SELECT *
FROM demo_merge.test_health_data VERSION AS OF 0;
