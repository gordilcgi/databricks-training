-- Databricks notebook source
-- DBTITLE 1,Create catalog
CREATE CATALOG IF NOT EXISTS
DEMO_PATIENT

-- COMMAND ----------

-- DBTITLE 1,Use catalog
USE CATALOG DEMO_PATIENT

-- COMMAND ----------

CREATE VOLUME VOLUME_PATIENT

-- COMMAND ----------

-- DBTITLE 1,Create schema - Bronze
CREATE SCHEMA IF NOT EXISTS
BRONZE

-- COMMAND ----------

-- DBTITLE 1,Create schema - Silver
CREATE SCHEMA IF NOT EXISTS
SILVER

-- COMMAND ----------

-- DBTITLE 1,Create schema - Gold
CREATE SCHEMA IF NOT EXISTS
GOLD

-- COMMAND ----------

-- DBTITLE 1,Create Gold Table 1
CREATE OR REPLACE TABLE GOLD.PATIENT_GOLD_ZIPCODE
(
  zipcode STRING,
  number_of_er_visits int
)

-- COMMAND ----------

-- DBTITLE 1,Creae Gold Table 2
CREATE OR REPLACE TABLE GOLD.PATIENT_GOLD_AGEGROUP
(
  age_group STRING,
  diagnosis_category STRING,
  number_of_er_visits int
)
