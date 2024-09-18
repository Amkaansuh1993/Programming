USE [master];
  if object_id ('"dbo"."fact_table__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo"."fact_table__dbt_tmp_temp_view"
      end
 
 
  
   
  USE [master];
  if object_id ('"dbo"."fact_table__dbt_tmp"','U') is not null
      begin
      drop table "dbo"."fact_table__dbt_tmp"
      end
 
 
   USE [master];
   EXEC('create view "dbo"."fact_table__dbt_tmp_temp_view" as
    WITH
complete_system_measurements AS (
    SELECT
        time_id AS tid,
        CASE
            WHEN platform = ''SAP_Platform'' AND metric IN (''concurrent_users'', ''sql_statements'', ''interface_steps'') THEN SUBSTRING(dimension_id, 1, 3)
            ELSE dimension_id
        END AS system_id,
        CASE
            WHEN platform = ''SAP_Platform'' AND metric = ''interface_steps'' THEN dimension_id
            ELSE null
        END AS instance_id,
        NULL AS user_id,
        null AS country_id,
        metric,
        "value",
        platform
    FROM "master"."dbo"."MEASUREMENTS"
    WHERE dimension = ''system'' AND (
               (platform = ''SAP_Platform'' AND
                              (dimension_id LIKE ''%.day%'' AND metric IN (''concurrent_users'', ''sql_statements'') AND dimension_id != ''.day'' )
                              OR metric NOT IN  (''concurrent_users'', ''sql_statements''))
        OR platform != ''SAP_Platform'')
),
complete_instances_measurements AS (
    SELECT
        time_id AS tid,
        CASE
            WHEN platform = ''SAP_Platform'' THEN SUBSTRING(dimension_id, 1, PATINDEX(''%.%'', dimension_id) -1)
            WHEN platform = ''Web_Messaging'' AND metric IN (''exchange_mailboxes'')
                THEN SUBSTRING(dimension_id,  CHARINDEX(''.'', dimension_id) +1, CHARINDEX(''.'', dimension_id, CHARINDEX(''.'', dimension_id) + 1) - (CHARINDEX(''.'', dimension_id) +1))
            WHEN  platform = ''Web_Messaging'' AND metric IN (''message_security'') THEN ''hornet security''
            WHEN platform = ''Collaboration'' THEN ''M365''
            ELSE NULL
        END AS system_id,
        CASE
            WHEN dimension_id LIKE ''.%'' AND platform = ''Data_Archiving'' AND metric = ''is_application'' THEN SUBSTRING(dimension_id, 2, LEN(dimension_id))
            ELSE dimension_id
        END AS instance_id,
        NULL AS user_id,
        CASE
            WHEN platform = ''Web_Messaging'' AND metric IN (''exchange_mailboxes'', ''message_security'')
                THEN SUBSTRING(dimension_id, 1, CHARINDEX(''.'', dimension_id) -1)
            ELSE NULL
        END country_id,
        metric,
        "value",
        platform
    FROM "master"."dbo"."MEASUREMENTS"
    WHERE dimension = ''instance''
),
complete_user_measurements AS (
    SELECT
        time_id AS tid,
        CASE
            WHEN platform = ''Collaboration'' THEN ''M365''
            ELSE NULL
        END AS system_id,
        NULL AS instance_id,
        dimension_id AS user_id,
        NULL AS country_id,
        metric,
        "value",
        platform
    FROM "master"."dbo"."MEASUREMENTS"
    WHERE dimension = ''user'' AND metric IN (''audio_duration'', ''video_duration'', ''call_count'', ''team_chat_message_count'', ''private_chat_message_count'')
),
dedub_users_measurements AS (
    SELECT
        tid,
        system_id,
        instance_id,
        user_id,
        country_id,
        metric,
                   MAX("value") AS "value",
        platform
    FROM complete_user_measurements
    GROUP BY tid, system_id, instance_id, user_id, country_id, metric, platform
),
aggregated_users_measurements AS (
    SELECT
        tid,
        system_id,
        instance_id,
        NULL AS user_id,
        country_id,
        metric,
        SUM("value") AS "value",
        platform
    FROM dedub_users_measurements
    GROUP BY tid, system_id, instance_id, country_id, metric, platform
),
measurements_from_dimensions AS (
SELECT
    *
FROM "master"."dbo"."DIMENSIONS"
WHERE attribute_name IN (''licences'') AND attribute_value IS NOT NULL
),
measurements_from_dimensions_number_starter AS (
SELECT
    updated_at,
    dimension_id,
    PARSE(value AS DATE) AS tid,
    attribute_name
FROM "master"."dbo"."DIMENSIONS"
CROSS APPLY STRING_SPLIT(attribute_value, '';'')
WHERE attribute_name = ''assigned_plans_date'' AND attribute_value IS NOT NULL AND attribute_value != ''''
),
aggregated_measurements_from_dimensions_user AS (
SELECT
    MIN(tid) AS tid,
    ''M365'' AS system_id,
    NULL AS instance_id,
    dimension_id AS user_id,
    NULL AS country_id,
    ''is_starter'' AS metric,
    1 AS "value",
    ''Collaboration'' AS platform
FROM measurements_from_dimensions_number_starter
GROUP BY dimension_id
),
dudub_measurements_from_dimensions AS (
SELECT
    updated_at,
    dimension,
    dimension_id,
    attribute_name,
    MAX(attribute_value) AS attribute_value
FROM measurements_from_dimensions
GROUP BY updated_at, dimension, dimension_id, attribute_name
),
flat_measurements_from_dimensions AS (
SELECT
    updated_at AS tid,
    value AS instance_id,
    attribute_name AS metric
FROM dudub_measurements_from_dimensions
    CROSS APPLY STRING_SPLIT(attribute_value, '';'')
),
aggregated_measurements_from_dimensions AS (
SELECT
    tid,
    ''M365'' AS system_id,
    instance_id,
    NULL AS user_id,
    NULL AS country_id,
    metric,
    COUNT(*) AS "value",
    ''Collaboration'' AS platform
FROM flat_measurements_from_dimensions
GROUP BY tid, instance_id, metric
),
combined_table AS (
SELECT *
FROM complete_system_measurements
UNION ALL
SELECT *
FROM complete_instances_measurements
UNION ALL
SELECT *
FROM aggregated_users_measurements
UNION ALL
SELECT *
FROM aggregated_measurements_from_dimensions
UNION ALL
SELECT *
FROM aggregated_measurements_from_dimensions_user
),
measurements_table AS (
    SELECT
                   CAST(tid AS DATE) AS tid,
                   system_id,
        instance_id,
        user_id,
        country_id,
        combined_table.metric,
        "value",
        "master"."dbo"."metrics".unit,
        combined_table.platform,
        resampling_method
    FROM combined_table
    LEFT JOIN "master"."dbo"."metrics"
    ON combined_table.platform = "master"."dbo"."metrics".platform
        AND combined_table.metric = "master"."dbo"."metrics".metric
),
 
deduplicate_table AS (
    SELECT
        tid,
        system_id,
        instance_id,
        user_id,
        country_id,
        metric,
                   MAX("value") AS "value",
        unit,
        platform
    FROM measurements_table
    GROUP BY tid, system_id, instance_id, user_id, country_id, metric, unit, platform
 
),
delta_table AS (
    SELECT
        tid,
        system_id,
        instance_id,
        user_id,
        country_id,
        metric,
        CASE
            WHEN metric = ''released_transports''
            THEN value - LAG(value, 1) OVER (PARTITION BY system_id, instance_id,user_id, country_id, platform, metric ORDER BY tid)
            ELSE value
        END AS value,
        unit,
        platform
    FROM deduplicate_table
),
typo_fixed_dimensions AS (
SELECT
    updated_at,
    dimension,
    dimension_id,
    CASE
        WHEN attribute_name = ''sytem_id'' THEN ''system_id''
        ELSE attribute_name
    END AS attribute_name,
    attribute_value
FROM "master"."dbo"."DIMENSIONS"
),
mapping_instance_id_system_id AS (
SELECT
               dimension_id AS instance_id,
               attribute_value AS system_id
FROM (
SELECT
    updated_at,
    dimension,
    dimension_id,
    attribute_name,
    attribute_value,
    ROW_NUMBER ( )  OVER ( PARTITION BY dimension, dimension_id, attribute_name ORDER BY updated_at DESC) AS rn
FROM typo_fixed_dimensions
WHERE dimension = ''instance'' AND attribute_name = ''system_id'' AND dimension_id IS NOT NULL AND dimension_id != ''''
) AS t
WHERE rn = 1
),
result_table AS (
SELECT
    tid,
    CASE
        WHEN t.system_id IS NULL OR t.system_id = '''' THEN m.system_id
        ELSE t.system_id
    END AS system_id,
    t.instance_id,
    user_id,
    country_id,
    metric,
    value,
    unit,
    platform
FROM delta_table AS t
LEFT JOIN mapping_instance_id_system_id AS m
ON (t.instance_id = m.instance_id)
)
SELECT
    *
FROM result_table
    ');
 
   SELECT * INTO "master"."dbo"."fact_table__dbt_tmp" FROM
    "master"."dbo"."fact_table__dbt_tmp_temp_view"
 
  
   
  USE [master];
  if object_id ('"dbo"."fact_table__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo"."fact_table__dbt_tmp_temp_view"
      end
 
 
   use [master];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_fact_table__dbt_tmp_cci'
        AND object_id=object_id('dbo_fact_table__dbt_tmp')
    )
  DROP index "dbo"."fact_table__dbt_tmp".dbo_fact_table__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_fact_table__dbt_tmp_cci
    ON "dbo"."fact_table__dbt_tmp"