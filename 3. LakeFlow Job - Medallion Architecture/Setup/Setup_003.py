# Databricks notebook source
# DBTITLE 1,Get Python functions
# MAGIC %run ./python_utilities

# COMMAND ----------

# DBTITLE 1,Create Medallion Tables
# MAGIC %run ./create_tables

# COMMAND ----------

# DBTITLE 1,Incoming jobfiles
dbutils.fs.mkdirs('/Volumes/demo_catalog/demo_schema/demo_volume/jobsfiles')

# COMMAND ----------

# DBTITLE 1,archive files
dbutils.fs.mkdirs('/Volumes/demo_catalog/demo_schema/demo_volume/jobsfiles/archive')
