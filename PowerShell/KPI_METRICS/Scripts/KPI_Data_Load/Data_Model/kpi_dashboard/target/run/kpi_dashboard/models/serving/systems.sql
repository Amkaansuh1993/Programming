  USE [master];
  if object_id ('"dbo"."systems__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo"."systems__dbt_tmp_temp_view"
      end
 
 
  
   
  USE [master];
  if object_id ('"dbo"."systems__dbt_tmp"','U') is not null
      begin
      drop table "dbo"."systems__dbt_tmp"
      end
 
 
   USE [master];
   EXEC('create view "dbo"."systems__dbt_tmp_temp_view" as
    WITH system_measurements_sap AS (
    SELECT DISTINCT system_id
    FROM fact_table
    WHERE system_id IS NOT NULL AND platform = ''SAP_Platform''
),
system_dimension_sap AS (
    SELECT
        updated_at,
        dimension_id,
        attribute_name,
        attribute_value
    FROM "master"."dbo"."sap_dimensions_test"
    WHERE dimension = ''system_id''
),
sap_dimensions AS (
SELECT
    system_measurements_sap.system_id AS system_id,
    UPPER(system_dimension_sap.dimension_id) AS name,
    ''sap'' AS system_type,
    NULL AS version,
    NULL AS technologies,
    CASE(attribute_name)
     WHEN ''environment'' THEN attribute_value
     ELSE NULL
     END AS environment,
    SUBSTRING(system_dimension_sap.dimension_id, 2, 2) AS system_landscape,
    NULL AS provisioning_type,
    NULL AS charge_size,
    NULL AS company,
    NULL AS service_provider,
    NULL AS system_priority
FROM system_measurements_sap
LEFT JOIN system_dimension_sap
    ON (system_measurements_sap.system_id = system_dimension_sap.dimension_id)
),
dedub_dimensions AS (
SELECT
    *
FROM
(SELECT
    dimension,
    dimension_id,
    attribute_name,
    attribute_value,
    ROW_NUMBER ( )  OVER ( PARTITION BY dimension, dimension_id, attribute_name ORDER BY updated_at DESC) AS rn
FROM [master].[dbo].[DIMENSIONS]
WHERE dimension = ''system'' AND dimension_id != '''' AND attribute_value != '''') AS T
WHERE rn = 1
),
all_dimensions AS (
  SELECT
      dimension_id AS system_id,
      dimension_id AS name,
      [system_type] AS system_type,
      [version] AS version,
      [technologies] AS technologies,
      [environment] AS environment,
      [system_landscape] AS system_landscape,
      [provisioning_type] AS provisioning_type,
      [charge_size] AS charge_size,
      [company] AS company,
      [service_provider] AS service_provider,
      [system_priority] AS system_priority,
      [high_availability] AS high_availability
  FROM dedub_dimensions
  PIVOT (
  MAX(attribute_value)
  FOR [attribute_name] IN ([system_type], [version], [technologies], [environment], [system_landscape],
      [provisioning_type], [charge_size], [company], [service_provider], [system_priority], [high_availability])
      ) AS p
)
SELECT *
FROM all_dimensions
    ');
 
   SELECT * INTO "master"."dbo"."systems__dbt_tmp" FROM
    "master"."dbo"."systems__dbt_tmp_temp_view"
 
  
   
  USE [master];
  if object_id ('"dbo"."systems__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo"."systems__dbt_tmp_temp_view"
      end
 
 
   use [master];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_systems__dbt_tmp_cci'
        AND object_id=object_id('dbo_systems__dbt_tmp')
    )
  DROP index "dbo"."systems__dbt_tmp".dbo_systems__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_systems__dbt_tmp_cci
    ON "dbo"."systems__dbt_tmp"