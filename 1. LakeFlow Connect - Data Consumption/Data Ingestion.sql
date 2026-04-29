-- Databricks notebook source
-- MAGIC %md
-- MAGIC ###Databricks metastore structure
-- MAGIC
-- MAGIC The Databricks metastore is the top-level container for data governance and organization. Within a metastore, you can create multiple catalogs, which are logical groupings of schemas. Each catalog contains schemas (also known as databases), and each schema contains tables, views, and volumes. This hierarchy enables fine-grained access control and organization of data assets:
-- MAGIC
-- MAGIC - **Metastore**: The root container for all data objects.
-- MAGIC - **Catalog**: A collection of schemas; used to separate data for different teams or projects.
-- MAGIC - **Schema (Database)**: Contains tables, views, and volumes; used to organize data within a catalog.
-- MAGIC
-- MAGIC For example: `metastore.catalog.schema.table`

-- COMMAND ----------

-- DBTITLE 1,Environment setup
-- MAGIC %run ./Setup/Setup_001

-- COMMAND ----------

-- MAGIC %md
-- MAGIC
-- MAGIC ####Create Catalog Syntax
-- MAGIC ```sql
-- MAGIC CREATE CATALOG [ IF NOT EXISTS ] catalog_name
-- MAGIC     [ USING SHARE provider_name . share_name |
-- MAGIC       MANAGED LOCATION location_path |
-- MAGIC       COMMENT comment |
-- MAGIC       DEFAULT COLLATION default_collation_name |
-- MAGIC       OPTIONS ( { option_name = option_value } [ , ... ] ) ] [...]
-- MAGIC
-- MAGIC CREATE FOREIGN CATALOG [ IF NOT EXISTS ] catalog_name
-- MAGIC     USING CONNECTION connection_name
-- MAGIC     [ COMMENT comment ]
-- MAGIC     OPTIONS ( { option_name = option_value } [ , ... ] )
-- MAGIC

-- COMMAND ----------

-- DBTITLE 1,Create the Demo Catalog
CREATE CATALOG IF NOT EXISTS
DEMO_CATALOG
COMMENT "Creating New Demo Catalog"

-- COMMAND ----------

-- DBTITLE 1,Use Catalog
USE CATALOG DEMO_CATALOG

-- COMMAND ----------

-- DBTITLE 1,Create the Demo Schema
-- MAGIC %md
-- MAGIC ####Create Schema Syntax
-- MAGIC ``` sql
-- MAGIC CREATE SCHEMA [ IF NOT EXISTS ] schema_name
-- MAGIC     [ COMMENT schema_comment |
-- MAGIC       DEFAULT COLLATION default_collation_name |
-- MAGIC       { LOCATION schema_directory | MANAGED LOCATION location_path } |
-- MAGIC       WITH DBPROPERTIES ( { property_name = property_value } [ , ... ] ) ] [...]
-- MAGIC

-- COMMAND ----------

-- DBTITLE 1,Create the schema
CREATE SCHEMA IF NOT EXISTS
DEMO_SCHEMA
COMMENT "Schema for Demo training"

-- COMMAND ----------

-- DBTITLE 1,Use Schema
USE SCHEMA DEMO_SCHEMA

-- COMMAND ----------

-- DBTITLE 1,View current catalog and schema
SELECT current_catalog(), current_schema()

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ###Volumes
-- MAGIC
-- MAGIC Volumes are Unity Catalog objects that enable governance over non-tabular datasets. Volumes represent a logical volume of storage in a cloud object storage location. Volumes provide capabilities for accessing, storing, governing, and organizing files.
-- MAGIC
-- MAGIC Databricks recommends using volumes to govern access to all non-tabular data. Like tables, volumes can be managed or external.

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ####Create Volume Syntax
-- MAGIC
-- MAGIC CREATE [ EXTERNAL ] VOLUME [ IF NOT EXISTS ] 
-- MAGIC volume_name
-- MAGIC     [ LOCATION location_path ]
-- MAGIC     [ COMMENT comment ]

-- COMMAND ----------

-- DBTITLE 1,Create Volume
CREATE VOLUME 
IF NOT EXISTS
DEMO_VOLUME
COMMENT "Volume for Demo training"

-- COMMAND ----------

-- DBTITLE 1,Create volume directories and move files
-- MAGIC %run ./Setup/create_volume_directories

-- COMMAND ----------

-- DBTITLE 1,Move file for testing
-- MAGIC %python
-- MAGIC move_files(move_from='/Volumes/demo_catalog/demo_schema/demo_volume/datafiles/', move_to='/Volumes/demo_catalog/demo_schema/demo_volume/receivedfiles/', n=1 )

-- COMMAND ----------

-- DBTITLE 1,See list of incoming files
LIST '/Volumes/demo_catalog/demo_schema/demo_volume/receivedfiles'

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ####Read files
-- MAGIC The `read_files()` table-valued function (TVF) enables reading a variety of file formats and provides additional options for data ingestion.
-- MAGIC
-- MAGIC https://docs.databricks.com/aws/en/sql/language-manual/functions/read_files

-- COMMAND ----------

-- DBTITLE 1,Read CSV file
SELECT * 
FROM read_files(
  '/Volumes/demo_catalog/demo_schema/demo_volume/receivedfiles',
  format => 'csv'
)
LIMIT 10;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ####Metadata Column
-- MAGIC
-- MAGIC The **_metadata** column is a hidden column available for all supported file formats. To include it in the returned data, you must explicitly select it in the read query that specifies the source.
-- MAGIC
-- MAGIC Use the `_metadata` column to add metadata fields.

-- COMMAND ----------

SELECT
  *,
  _metadata.file_path,
  _metadata.file_modification_time
FROM
  read_files('/Volumes/demo_catalog/demo_schema/demo_volume/receivedfiles', format => 'csv')
LIMIT 10;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ####CTAS (CREATE TABLE AS)
-- MAGIC The `CREATE TABLE AS` (CTAS) statement is used to create and populate tables using the results of a query. This allows you to create a table and load it with data in a single step, streamlining data ingestion workflows.

-- COMMAND ----------

-- Drop the table if it exists for demonstration purposes
DROP TABLE IF EXISTS bronze_covid_data_ctas;


-- Create the Delta table
CREATE TABLE bronze_covid_data_ctas 
AS
SELECT *, _metadata.file_path, _metadata.file_modification_time 
FROM read_files(
        '/Volumes/demo_catalog/demo_schema/demo_volume/receivedfiles',
        format => 'csv'
      );


-- Preview the Delta table
SELECT * 
FROM bronze_covid_data_ctas 
LIMIT 10;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ####Get Table metadata
-- MAGIC Run the `DESCRIBE TABLE EXTENDED` statement to view column names, data types, and additional table metadata.

-- COMMAND ----------

DESCRIBE TABLE EXTENDED bronze_covid_data_ctas;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC #### Managed vs External Tables in Databricks
-- MAGIC
-- MAGIC ##### Managed Tables
-- MAGIC - Databricks **manages both the data and metadata**.
-- MAGIC - Data is stored **within Databricks’ managed storage**.
-- MAGIC - **Dropping the table also deletes the data**.
-- MAGIC - Recommended for creating new tables.
-- MAGIC
-- MAGIC ##### External Tables
-- MAGIC - Databricks **only manages the table metadata**.
-- MAGIC - **Dropping the table does not delete the data**.
-- MAGIC - Supports **multiple formats**, including Delta Lake.
-- MAGIC - Ideal for **sharing data across platforms** or using existing external data.
-- MAGIC

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ####Incremental Data Ingestion with `COPY INTO` (LEGACY)
-- MAGIC `COPY INTO` is a Databricks SQL command that allows you to load data from a file location into a Delta table. This operation is re-triable and idempotent, i.e. files in the source location that have already been loaded are skipped. This command is useful for when you need to load data into an existing Delta table. 

-- COMMAND ----------

-- DBTITLE 1,COPY INTO schema mismatch
--------------------------------------------
-- This cell returns an error
--------------------------------------------

-- Drop the table if it exists for demonstration purposes
DROP TABLE IF EXISTS bronze_covid_data_ci;


-- Create an empty table with the specified table schema (only 2 out of the 3 columns)
CREATE TABLE bronze_covid_data_ci (
  Name STRING,
  Age STRING,
  State STRING,
  Covid_Status STRING,
  Quarantine_Status STRING
);


-- Use COPY INTO to populate Delta table
COPY INTO bronze_covid_data_ci
  FROM '/Volumes/demo_catalog/demo_schema/demo_volume/receivedfiles'
  FILEFORMAT = csv
  FORMAT_OPTIONS ('header' = 'true');

-- COMMAND ----------

-- DBTITLE 1,Table count
select count(*)
from bronze_covid_data_ci

-- COMMAND ----------

-- DBTITLE 1,View data
select *
from bronze_covid_data_ci

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ####Common error
-- MAGIC
-- MAGIC The common error for consuming files could be schema mismatch error.
-- MAGIC
-- MAGIC

-- COMMAND ----------

-- DBTITLE 1,add new file
-- MAGIC %python
-- MAGIC move_files(move_from='/Volumes/demo_catalog/demo_schema/demo_volume/datafiles/', move_to='/Volumes/demo_catalog/demo_schema/demo_volume/receivedfiles/', n=1 )

-- COMMAND ----------

-- DBTITLE 1,The common error
COPY INTO bronze_covid_data_ci
  FROM '/Volumes/demo_catalog/demo_schema/demo_volume/receivedfiles'
  FILEFORMAT = csv
  FORMAT_OPTIONS ('header' = 'true');

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ####Schema Evoluation
-- MAGIC
-- MAGIC We can fix this error by adding `COPY_OPTIONS` with the `mergeSchema = 'true'` option. When set to `true`, this option allows the schema to evolve based on the incoming data.

-- COMMAND ----------

-- DBTITLE 1,COPY INTO with schema evolution
COPY INTO bronze_covid_data_ci
  FROM '/Volumes/demo_catalog/demo_schema/demo_volume/receivedfiles'
  FILEFORMAT = csv
  FORMAT_OPTIONS ('header' = 'true')
  COPY_OPTIONS ('mergeSchema' = 'true');     -- Merge the schema of each file

-- COMMAND ----------

-- DBTITLE 1,view data
select * from bronze_covid_data_ci

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ####Idempotency (Incremental Ingestion)
-- MAGIC
-- MAGIC `COPY INTO` tracks the files it has previously ingested. If the command is run again, no additional data is ingested because the files in the source directory haven't changed.

-- COMMAND ----------

-- DBTITLE 1,Count
select count(*)
from bronze_covid_data_ci
