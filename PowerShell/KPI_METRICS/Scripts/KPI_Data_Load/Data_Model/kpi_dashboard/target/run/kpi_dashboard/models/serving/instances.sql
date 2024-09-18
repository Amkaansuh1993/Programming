  USE [master];
  if object_id ('"dbo"."instances__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo"."instances__dbt_tmp_temp_view"
      end
 
 
  
   
  USE [master];
  if object_id ('"dbo"."instances__dbt_tmp"','U') is not null
      begin
      drop table "dbo"."instances__dbt_tmp"
      end
 
 
   USE [master];
   EXEC('create view "dbo"."instances__dbt_tmp_temp_view" as
    WITH instance_measurements_sap AS (
    SELECT
        DISTINCT instance_id,
        system_id
    FROM fact_table
    WHERE instance_id IS NOT NULL AND platform = ''SAP_Platform''
),
instance_measurements_wm AS (
    SELECT DISTINCT instance_id,
    system_id,
    metric
    FROM fact_table
    WHERE instance_id IS NOT NULL AND platform = ''web_messaging''
),
instances_sap AS(
SELECT
    instance_id,
    UPPER(instance_id) AS name,
    ''Interface'' AS instance_type,
    UPPER(SUBSTRING(instance_id, PATINDEX(''%.%'', instance_id) +1, LEN(instance_id))) AS instance_subtype,
    system_id,
    NULL AS version,
    NULL AS licence,
    NULL AS host
FROM instance_measurements_sap),
instances_wm AS (
SELECT
    instance_id,
    instance_id AS name,
    CASE
        WHEN metric = ''exchange_mailboxes'' THEN ''Mailbox''
        WHEN metric = ''web_instances'' THEN SUBSTRING(instance_id, 1, CHARINDEX(''.'', instance_id)-1)
        WHEN metric = ''message_security''
            THEN SUBSTRING(instance_id,  CHARINDEX(''.'', instance_id) +1, CHARINDEX(''.'', instance_id, CHARINDEX(''.'', instance_id) + 1) - (CHARINDEX(''.'', instance_id) +1))
        END AS instance_type,
    CASE
        WHEN metric = ''exchange_mailboxes''
        THEN SUBSTRING(instance_id, CHARINDEX(''.'', instance_id, CHARINDEX(''.'', instance_id) + 1) +1 ,LEN(instance_id))
        WHEN metric = ''web_instances''
        THEN SUBSTRING(instance_id, CHARINDEX(''.'', instance_id)+1, LEN(instance_id))
        WHEN metric = ''message_security''
        THEN SUBSTRING( instance_id, CHARINDEX(''.'', instance_id, CHARINDEX(''.'', instance_id) + 1) +1, LEN(instance_id))
        END AS instance_subtype,
    system_id,
    NULL AS version,
    NULL AS licence,
    NULL AS host,
    NULL AS business_domain
FROM instance_measurements_wm
),
typo_fixed_dimensions AS (
SELECT
    updated_at,
    dimension,
    CASE
        WHEN dimension_id LIKE ''.%'' AND dimension = ''instance'' THEN SUBSTRING(dimension_id, 2, LEN(dimension_id))
        ELSE dimension_id
    END AS dimension_id,
    CASE
        WHEN attribute_name = ''sytem_id'' THEN ''system_id''
        ELSE attribute_name
    END AS attribute_name,
    --CASE
    --    WHEN attribute_value NOT LIKE ''.%'' AND attribute_name = ''host'' THEN SUBSTRING(dimension_id, 1, CHARINDEX(''.'', dimension_id)) + attribute_value
    --    ELSE attribute_value
    --END AS attribute_value
    attribute_value
FROM "master"."dbo"."DIMENSIONS"
),
adjusted_host AS (
SELECT
    updated_at,
    dimension,
    dimension_id,
    attribute_name,
    CASE
        WHEN attribute_value LIKE ''.%'' AND attribute_name = ''host'' THEN SUBSTRING(attribute_value, 2, LEN(attribute_value))
        ELSE attribute_value
    END AS attribute_value
FROM typo_fixed_dimensions
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
FROM adjusted_host
WHERE dimension = ''instance'' AND dimension_id != '''') AS T
WHERE rn = 1
),
instances_collaboration AS (
  SELECT
      dimension_id AS instance_id,
      CASE WHEN [name] IS NOT NULL OR [name] != '''' THEN [name]
      ELSE dimension_id
      END AS instance_name,
      [instance_type] AS instance_type,
      [instance_subtype] AS instance_subtype,
      [system_id] AS system_id,
      [version] AS version,
      [licence] AS licence,
      [host] AS host,
      [business_domain] AS business_domain
  FROM dedub_dimensions
  PIVOT (
  MAX(attribute_value)
  FOR [attribute_name] IN ([instance_type], [instance_subtype], [system_id], [licence], [version], [name], [host], [business_domain])
      ) AS p
),
combined_table AS (
SELECT *
FROM instances_wm
UNION ALL
SELECT *
FROM instances_collaboration
)
 
SELECT *
FROM combined_table
    ');
 
   SELECT * INTO "master"."dbo"."instances__dbt_tmp" FROM
    "master"."dbo"."instances__dbt_tmp_temp_view"
 
  
   
  USE [master];
  if object_id ('"dbo"."instances__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo"."instances__dbt_tmp_temp_view"
      end
 
 
   use [master];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_instances__dbt_tmp_cci'
        AND object_id=object_id('dbo_instances__dbt_tmp')
    )
  DROP index "dbo"."instances__dbt_tmp".dbo_instances__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_instances__dbt_tmp_cci
    ON "dbo"."instances__dbt_tmp"