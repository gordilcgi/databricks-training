# Databricks notebook source
# DBTITLE 1,create datafiles directory in volume
dbutils.fs.mkdirs('/Volumes/demo_catalog/demo_schema/demo_volume/datafiles/')

# COMMAND ----------

# DBTITLE 1,create receivedfiles directory files
dbutils.fs.mkdirs('/Volumes/demo_catalog/demo_schema/demo_volume/receivedfiles/')

# COMMAND ----------

# DBTITLE 1,Move files from testdata to datafiles
move_files(move_from=f'/Volumes/workspace/default/testdata/', move_to='/Volumes/demo_catalog/demo_schema/demo_volume/datafiles/', n=9 )
