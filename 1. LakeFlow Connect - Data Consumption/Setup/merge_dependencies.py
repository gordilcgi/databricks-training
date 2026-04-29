# Databricks notebook source
# DBTITLE 1,create volume directory
dbutils.fs.mkdirs('/Volumes/demo_catalog/demo_schema/demo_volume/merge_target/')

# COMMAND ----------

# DBTITLE 1,copy files
move_files(move_from='/Volumes/workspace/default/testdata/',move_to='/Volumes/demo_catalog/demo_schema/demo_volume/merge_target/',n=1)

# COMMAND ----------

# DBTITLE 1,create volume directory
dbutils.fs.mkdirs('/Volumes/demo_catalog/demo_schema/demo_volume/merge_source/')

# COMMAND ----------

# DBTITLE 1,copy files
move_files(move_from='/Volumes/workspace/default/testdata/',move_to='/Volumes/demo_catalog/demo_schema/demo_volume/merge_source/',n=1)
