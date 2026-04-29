-- Step 1: Bronze Stage - Streaming table ingests raw COVID status data from volume
CREATE OR REFRESH STREAMING TABLE bronze.bronze_stream
  COMMENT 'Bronze stage: Raw COVID status data ingested from volume' AS
SELECT
  *,
  _metadata.file_name AS source_file,
  current_timestamp() AS processing_time
FROM
  STREAM read_files('/Volumes/demo_catalog/demo_schema/demo_volume/sdpfiles/', format => 'csv');

-- Step 2: Silver Stage - Streaming table processes data from bronze, adds processing_time and source_file, and replaces state with two-letter short form using reference.states lookup
CREATE OR REFRESH STREAMING TABLE silver.silver_stream 
(
  CONSTRAINT state_validation EXPECT (state is NOT NULL),
  CONSTRAINT covid_status_validation EXPECT (upper(covid_status) in ('P', 'N'))
  ON VIOLATION DROP ROW,
  CONSTRAINT age_validation EXPECT (CAST(age AS INT) >= 0 )
  ON VIOLATION FAIL UPDATE
)
  COMMENT 'Silver stage: Cleaned and enriched data from bronze, includes processing_time, source_file, and state short form' AS
SELECT
  b.* EXCEPT (state),
  r.state_abbr AS state
FROM
  STREAM bronze.bronze_stream b
    LEFT JOIN reference.states r
      ON b.state = r.state_name;

-- Step 3: Gold Stage - Materialized view aggregates data from silver, pivots total yes/no covid counts per state short form
CREATE OR REFRESH MATERIALIZED VIEW gold.gold_mv
  COMMENT 'Gold stage: Aggregated COVID yes/no counts per state short form' AS
SELECT
  state,
  Count(*) AS total_tests,
  SUM(
    CASE
      WHEN upper(Covid_Status) = 'P' THEN 1
      ELSE 0
    END
  ) AS total_positive,
  SUM(
    CASE
      WHEN upper(Covid_Status) = 'N' THEN 1
      ELSE 0
    END
  ) AS total_negative
FROM
  silver.silver_stream
GROUP BY
  state
Order by
  state;