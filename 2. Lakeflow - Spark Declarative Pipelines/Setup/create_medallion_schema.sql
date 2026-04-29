-- Databricks notebook source
-- DBTITLE 1,Create Bronze schema
CREATE SCHEMA IF NOT EXISTS 
DEMO_CATALOG.bronze
COMMENT "Schema to store bronze data"

-- COMMAND ----------

-- DBTITLE 1,Create Silver Schema
CREATE SCHEMA IF NOT EXISTS 
DEMO_CATALOG.silver
COMMENT "Schema to store silver data"

-- COMMAND ----------

-- DBTITLE 1,Create Gold Schema
CREATE SCHEMA IF NOT EXISTS 
DEMO_CATALOG.gold
COMMENT "Schema to store gold data"
