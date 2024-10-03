BEGIN TRANSACTION
delete from [dbo].[collaboration_dimensions];
delete from [dbo].[DIMENSIONS];
delete from [dbo].[fact_table];
delete from [dbo].[fact_table__dbt_tmp];
delete from [dbo].[instances];
delete from [dbo].[instances__dbt_tmp];
delete from [dbo].[MEASUREMENTS];
delete from [dbo].[metrics];
delete from [dbo].[sap_dimensions_test];
delete from [dbo].[sap_measurements_test];
delete from [dbo].[sap_measurements_test_update];
delete from [dbo].[sap_transformed_test];
delete from [dbo].[systems];
delete from [dbo].[systems__dbt_tmp];
delete from [dbo].[users];
delete from [dbo].[users__dbt_tmp];
delete from [dbo].[w_m_measurements_test];
COMMIT TRANSACTION