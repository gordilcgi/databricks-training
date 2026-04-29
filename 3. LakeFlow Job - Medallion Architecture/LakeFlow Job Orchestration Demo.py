# Databricks notebook source
# DBTITLE 1,Get Python Utilities
# MAGIC %run ./Setup/Setup_003

# COMMAND ----------

# MAGIC %md
# MAGIC ###Create the Job
# MAGIC
# MAGIC Complete the following steps to create and name your job.
# MAGIC
# MAGIC 1. Right-click the **Jobs and Pipelines** button in the sidebar and select *Open Link in New Tab*.
# MAGIC
# MAGIC 2. In the new tab, confirm that you are in the **Jobs & Pipelines** tab.
# MAGIC
# MAGIC 3. Click the **Create** button and select **Job** from the dropdown.
# MAGIC
# MAGIC 4. In the top-left corner of the screen, you’ll see a default job name based on the current date and time (for example, *New Job Mar 19, 2026, 09:54 PM*).
# MAGIC
# MAGIC 5. Change the **Job Name** to the one provided in the previous cell (for example: **DEMO_COVID_JOB**).
# MAGIC
# MAGIC 6. Leave the job open and proceed to the next steps.
# MAGIC
# MAGIC **NOTE:** If you click on a recommended task (like **Notebook**), you will be redirected to a different page than shown in the screenshot below.

# COMMAND ----------

# MAGIC %md
# MAGIC ### Create the Notebook Tasks
# MAGIC
# MAGIC Complete the following steps to add a notebook task.
# MAGIC
# MAGIC 1. In the Lakeflow Jobs UI, Select the **Notebook** task type.
# MAGIC
# MAGIC 2. Configure the task using the settings below:
# MAGIC
# MAGIC | Setting         | Instructions |
# MAGIC |-----------------|--------------|
# MAGIC | **Task name**   | Enter **Bronze** |
# MAGIC | **Type**        | Select **Notebook** |
# MAGIC | **Source**      | Choose **Workspace** |
# MAGIC | **Path**        | Use the file navigator to locate and select **/Users/\<Your-User-ID>/3. LakeFlow Job - Medallion Architecture/Bronze** |
# MAGIC | **Compute**     | Select a **Serverless** cluster from the dropdown menu.
# MAGIC | **Create task** | Click **Create task** |
# MAGIC
# MAGIC 4. Keep the Lakeflow Jobs UI open, you’ll be adding another task in the next step.
# MAGIC
# MAGIC 5. Add Another task by select **add task**. Select **notebook** task from the drop down list.
# MAGIC
# MAGIC 6. Configure the task using the settings below:
# MAGIC
# MAGIC | Setting         | Instructions |
# MAGIC |-----------------|--------------|
# MAGIC | **Task name**   | Enter **Silver** |
# MAGIC | **Type**        | Select **Notebook** |
# MAGIC | **Source**      | Choose **Workspace** |
# MAGIC | **Path**        | Use the file navigator to locate and select **/Users/\<Your-User-ID>/3. LakeFlow Job - Medallion Architecture/Silver** |
# MAGIC | **Compute**     | Select a **Serverless Starter Warehouse** cluster from the dropdown menu.
# MAGIC | **Dependes On** | Select **Bronze**
# MAGIC | **Run if dependencies** | Select **All Succeeded**
# MAGIC | **Create task** | Click **Create task** |
# MAGIC
# MAGIC 7. Add Another task by select **add task**. Select **notebook** task from the drop down list.
# MAGIC
# MAGIC 8. Configure the task using the settings below:
# MAGIC
# MAGIC | Setting         | Instructions |
# MAGIC |-----------------|--------------|
# MAGIC | **Task name**   | Enter **Gold** |
# MAGIC | **Type**        | Select **Notebook** |
# MAGIC | **Source**      | Choose **Workspace** |
# MAGIC | **Path**        | Use the file navigator to locate and select **/Users/\<Your-User-ID>/3. LakeFlow Job - Medallion Architecture/Gold** |
# MAGIC | **Compute**     | Select a **Serverless Starter Warehouse** cluster from the dropdown menu.
# MAGIC | **Dependes On** | Select **Silver**
# MAGIC | **Run if dependencies** | Select **All Succeeded**
# MAGIC | **Create task** | Click **Create task** |
# MAGIC
# MAGIC
# MAGIC
# MAGIC

# COMMAND ----------

# MAGIC %md
# MAGIC ####After above steps the jobs UI should look like below.
# MAGIC
# MAGIC ![image_1773976107138.png](./image_1773976107138.png "image_1773976107138.png")

# COMMAND ----------

# MAGIC %md
# MAGIC Now we will run the job after copying below file

# COMMAND ----------

# DBTITLE 1,Copy 1 file
move_files(move_from='/Volumes/demo_catalog/demo_schema/demo_volume/datafiles/', move_to='/Volumes/demo_catalog/demo_schema/demo_volume/jobsfiles/', n=1 )

# COMMAND ----------

# MAGIC %md
# MAGIC Now run the job by selecting run now on the right top of the Jobs UI screen.
# MAGIC
# MAGIC ![image_1773976562036.png](./image_1773976562036.png "image_1773976562036.png")
# MAGIC
# MAGIC There will be new pop-up on the right top for the new run. Select the *view run* and it will take you to the job execution UI.

# COMMAND ----------

# MAGIC %md
# MAGIC ####Job Monitoring and Repairing Task.
# MAGIC
# MAGIC You can view the notebooks used in a task, including their output, as part of a job run. This helps diagnose errors. You can also re-run specific tasks in a failed job run.

# COMMAND ----------

# MAGIC %md
# MAGIC Let's break the job intentionally and run it again

# COMMAND ----------

# DBTITLE 1,Copy another file
move_files(move_from='/Volumes/demo_catalog/demo_schema/demo_volume/datafiles/', move_to='/Volumes/demo_catalog/demo_schema/demo_volume/jobsfiles/', n=1 )
