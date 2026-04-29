# Databricks notebook source
# DBTITLE 1,Get Python Function
# MAGIC %run ./python_utilities

# COMMAND ----------

# DBTITLE 1,Create Medallion Schemas
# %run ./create_medallion_schema

# COMMAND ----------

# DBTITLE 1,Create states table
# MAGIC %run ./create_states_table

# COMMAND ----------

# DBTITLE 1,create DLT file folder in volume
dbutils.fs.mkdirs('/Volumes/demo_catalog/demo_schema/demo_volume/sdpfiles')
