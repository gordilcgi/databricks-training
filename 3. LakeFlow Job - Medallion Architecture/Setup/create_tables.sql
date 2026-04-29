-- Databricks notebook source
-- DBTITLE 1,Create Bronze Schema
CREATE SCHEMA IF NOT EXISTS
demo_catalog.bronze;

-- COMMAND ----------

-- DBTITLE 1,Create Bronze Table
CREATE or REPLACE TABLE `demo_catalog`.`bronze`.`table_bronze` (
  Name STRING,
  Age INT,
  State STRING,
  Covid_Status STRING,
  Quarantine_Status STRING,
  source_file STRING,
  processing_time TIMESTAMP)

-- COMMAND ----------

-- DBTITLE 1,create silver schema
CREATE SCHEMA IF NOT EXISTS
demo_catalog.silver;

-- COMMAND ----------

-- DBTITLE 1,Create Silver Table
CREATE or REPLACE TABLE `demo_catalog`.`silver`.`table_silver` (
  Name STRING,
  Age INT,
  state STRING,
  Covid_Status STRING,
  Quarantine_Status STRING,
  source_file STRING,
  processing_time TIMESTAMP)

-- COMMAND ----------

-- DBTITLE 1,create gold schema
CREATE SCHEMA IF NOT EXISTS
demo_catalog.gold;

-- COMMAND ----------

-- DBTITLE 1,Create Gold Table
CREATE OR REPLACE TABLE `demo_catalog`.`gold`.`table_gold` (
  state STRING,
  age_group STRING,
  total_tests INT,
  positive INT,
  negative INT,
  update_time TIMESTAMP)
