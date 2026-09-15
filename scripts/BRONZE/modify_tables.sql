/*

Stored Procedure: Load Bronze Layer (Source -> Bronze)

Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `COPY` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.
*/


COPY bronze.crm_cust_info
FROM 'C:\Users\ProBook 430 G8\Desktop\DWH_PROJECT\datasets\source_crm\cust_info.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');


COPY bronze.crm_prd_info
FROM 'C:\Users\ProBook 430 G8\Desktop\DWH_PROJECT\datasets\source_crm\prd_info.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');


COPY bronze.crm_sales_details
FROM 'C:\Users\ProBook 430 G8\Desktop\DWH_PROJECT\datasets\source_crm\sales_details.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');


COPY bronze.erp_CUST_AZ12
FROM 'C:\Users\ProBook 430 G8\Desktop\DWH_PROJECT\datasets\source_erp\CUST_AZ12.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');


COPY bronze.erp_LOC_A101
FROM 'C:\Users\ProBook 430 G8\Desktop\DWH_PROJECT\datasets\source_erp\LOC_A101.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');


COPY bronze.erp_PX_CAT_G1V2
FROM 'C:\Users\ProBook 430 G8\Desktop\DWH_PROJECT\datasets\source_erp\PX_CAT_G1V2.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

SELECT 
    COUNT (*)
FROM bronze.crm_cust_info
--LIMIT 10
