BEGIN TRANSACTION
select count(*) from [dbo].[collaboration_dimensions];
select count(*) from [dbo].[DIMENSIONS];
select count(*) from [dbo].[fact_table];
select count(*) from [dbo].[fact_table__dbt_tmp];
select count(*) from [dbo].[instances];
select count(*) from [dbo].[instances__dbt_tmp];
select count(*) from [dbo].[MEASUREMENTS];
select count(*) from [dbo].[metrics];
select count(*) from [dbo].[sap_dimensions_test];
select count(*) from [dbo].[sap_measurements_test];
select count(*) from [dbo].[sap_measurements_test_update];
select count(*) from [dbo].[sap_transformed_test];
select count(*) from [dbo].[systems];
select count(*) from [dbo].[systems__dbt_tmp];
select count(*) from [dbo].[users];
select count(*) from [dbo].[users__dbt_tmp];
select count(*) from [dbo].[w_m_measurements_test];
COMMIT TRANSACTION