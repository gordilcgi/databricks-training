# Databricks notebook source
# MAGIC %md
# MAGIC # Developing a Simple Pipeline
# MAGIC
# MAGIC In this demonstration, we will create a simple Lakeflow Spark Declarative Pipeline project using the new **Lakeflow Pipeline Editor** with declarative SQL.
# MAGIC
# MAGIC
# MAGIC **Spark Declarative Pipelines (DLT)** can help process data incrementally, manage infrastructure, monitor, observe and optimize.

# COMMAND ----------

# DBTITLE 1,Environment Setup
# MAGIC %run ./Setup/Setup_004

# COMMAND ----------

# MAGIC %md
# MAGIC ###Follow below steps for creating a Spark Declarative Pipelines

# COMMAND ----------

# MAGIC %md
# MAGIC
# MAGIC ####Steps for creating DLT pipelines
# MAGIC In this course we have starter files for you to use in your pipeline. This demonstration uses the folder **Lakeflow - Spark Declarative Pipeline**. To create a pipeline and add existing assets to associate it with code files already available in your Workspace (including Git folders) complete the following:
# MAGIC
# MAGIC    a. For ease of use, open **Jobs & Pipelines** in a separate tab:
# MAGIC
# MAGIC   - On the main navigation bar, right-click on **Jobs & Pipelines** and select **Open in a New Tab**.
# MAGIC
# MAGIC    b. In **Jobs & Pipelines** select **Create** → **ETL Pipeline**.
# MAGIC
# MAGIC    c. Complete the pipeline creation page with the following:
# MAGIC
# MAGIC   - **Name**: `demo-spark-declarative-pipeline` 
# MAGIC   - **Default catalog**: Select your **demo_catalog** catalog
# MAGIC   - Notice there are a variety of options to start your pipeline.
# MAGIC
# MAGIC    d. In the options, select **Add existing assets**. In the popup, complete the following:
# MAGIC
# MAGIC   - **Pipeline root folder**: Select the **2 - Developing a Simple Pipeline Project** folder: 
# MAGIC     - `/Workspace/Users/<your-user-id>/Lakeflow -Spark Declarative Pipelines/Demo-Pipeline`
# MAGIC
# MAGIC   - **Source code paths**: Within the same root folder as above, select the **orders** folder: 
# MAGIC     - `/Workspace/Users/<your-user-id>/Lakeflow - Spark Declarative Pipelines/Demo-Pipeline/DLT Query`
# MAGIC
# MAGIC     **NOTE:** You can select folders containing SQL and Python files to be executed as part of the pipeline, or you can provide individual file paths. The specified files will be processed when the pipeline runs.
# MAGIC
# MAGIC    e. Click **Add**, This will create a pipeline and associate the correct files for this demonstration.
# MAGIC
# MAGIC

# COMMAND ----------

# DBTITLE 1,Add new file for 1st run
move_files('/Volumes/demo_catalog/demo_schema/demo_volume/datafiles/','/Volumes/demo_catalog/demo_schema/demo_volume/sdpfiles/',n = 1)

# COMMAND ----------

# MAGIC %md
# MAGIC Now select the **Run Pipeline** on the right top and observe the output.

# COMMAND ----------

# DBTITLE 1,Add one more file
move_files('/Volumes/demo_catalog/demo_schema/demo_volume/datafiles/','/Volumes/demo_catalog/demo_schema/demo_volume/sdpfiles/',n = 1)

# COMMAND ----------

# MAGIC %md
# MAGIC Now select the **Run Pipeline** on the right top and observe the output.__

# COMMAND ----------

# MAGIC %md 
# MAGIC #### Adding Data Quality Expectations
# MAGIC
# MAGIC Expectations are declarative rules that define the criteria for valid data within your pipeline. They provide greater insight into data quality metrics and allow you to fail updates or drop records when detecting invalid records. By specifying expectations, you can monitor, enforce, and report on data quality, ensuring that only clean and reliable data flows through your pipeline.
# MAGIC
# MAGIC **Possible expectation syntaxes:**
# MAGIC
# MAGIC - `EXPECT column_name IS NOT NULL`
# MAGIC - `EXPECT column_name > 0`
# MAGIC - `EXPECT column_name IN ('value1', 'value2', ...)`
# MAGIC - `EXPECT column_name LIKE 'pattern%'`
# MAGIC - `EXPECT column_name BETWEEN value1 AND value2`
# MAGIC - `EXPECT column_name = value`
# MAGIC - `EXPECT column_name <= value`
# MAGIC - `EXPECT column_name != value`
# MAGIC - `EXPECT custom_expression`
# MAGIC
# MAGIC **On violation actions:**
# MAGIC
# MAGIC - `ON VIOLATION DROP ROW`
# MAGIC - `ON VIOLATION FAIL UPDATE`
# MAGIC - `ON VIOLATION KEEP ROW`
# MAGIC - `ON VIOLATION UPDATE column_name = 'default_value'`

# COMMAND ----------

# MAGIC %md
# MAGIC
# MAGIC ####Add below validations in the silver table in pipeline
# MAGIC
# MAGIC 1. CONSTRAINT state_validation EXPECT (state is NOT NULL)
# MAGIC 2. CONSTRAINT covid_status_validation EXPECT (upper(covid_status) in ('P', 'N'))
# MAGIC   ON VIOLATION DROP ROW
# MAGIC 3. CONSTRAINT age_validation EXPECT (CAST(age AS INT) >= 0 )
# MAGIC   ON VIOLATION FAIL UPDATE

# COMMAND ----------

# DBTITLE 1,Add files with error
move_files('/Volumes/demo_catalog/demo_schema/demo_volume/datafiles/','/Volumes/demo_catalog/demo_schema/demo_volume/sdpfiles/',n = 1)

# COMMAND ----------

# MAGIC %md
# MAGIC Now select the **Run Pipeline** on the right top and observe the output.__
