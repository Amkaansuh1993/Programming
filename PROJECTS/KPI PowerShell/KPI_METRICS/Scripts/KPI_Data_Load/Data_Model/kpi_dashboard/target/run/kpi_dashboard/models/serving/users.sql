  USE [master];
  if object_id ('"dbo"."users__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo"."users__dbt_tmp_temp_view"
      end
 
 
  
   
  USE [master];
  if object_id ('"dbo"."users__dbt_tmp"','U') is not null
      begin
      drop table "dbo"."users__dbt_tmp"
      end
 
 
   USE [master];
   EXEC('create view "dbo"."users__dbt_tmp_temp_view" as
    WITH
dedub_dimensions AS (
SELECT
    *
FROM
(SELECT
    updated_at,
    dimension,
    dimension_id,
    attribute_name,
    attribute_value,
    ROW_NUMBER ( )  OVER ( PARTITION BY dimension, dimension_id, attribute_name ORDER BY updated_at DESC) AS rn
FROM "master"."dbo"."DIMENSIONS"
WHERE dimension = ''user'' AND dimension_id != '''') AS T
WHERE rn = 1
),
transformed_dimensions AS (
SELECT
    updated_at,
    dimension,
    dimension_id,
    attribute_name,
    CASE WHEN attribute_name = ''licences'' AND attribute_value IS NOT NULL THEN ''1''
    ELSE attribute_value
    END AS attribute_value
FROM dedub_dimensions
),
users_table AS (
    SELECT
        dimension_id AS user_id,
        [system_id] AS system_id,
        [user_type] AS user_type,
        [company] AS company,
               CASE
                              WHEN dimension_id LIKE ''%-%'' THEN ''user_statistics''
                              ELSE ''api''
               END AS id_origin,
                   [licences] AS licences
    FROM transformed_dimensions
    PIVOT(
        MAX(attribute_value)
        FOR [attribute_name] IN ([system_id], [user_type], [company], [licences])
    ) AS p
)
SELECT *
FROM users_table
    ');
 
   SELECT * INTO "master"."dbo"."users__dbt_tmp" FROM
    "master"."dbo"."users__dbt_tmp_temp_view"
 
  
   
  USE [master];
 if object_id ('"dbo"."users__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo"."users__dbt_tmp_temp_view"
      end
 
 
   use [master];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_users__dbt_tmp_cci'
        AND object_id=object_id('dbo_users__dbt_tmp')
    )
  DROP index "dbo"."users__dbt_tmp".dbo_users__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_users__dbt_tmp_cci
    ON "dbo"."users__dbt_tmp"