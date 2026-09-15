/*

DDL Script: Truncate & INSERT INTO silver Tables

Script Purpose:
    This script truncates and insert clean data from the bronze layer into the silver table
*/





/* 
   We insert the table into the silver layer after 
   completion of your code
*/
-- Before loading the data in the new table we have to make sure that it has been truncated
TRUNCATE TABLE silver.crm_cust_info;
INSERT INTO silver.crm_cust_info (
    cust_id,
    cst_key,
    cst_firstname,
    cst_lastname,
    cst_marital_status,
    cst_gndr,
    cst_create_date
)


/* 
   After all yout correction codes, you then combine it into one full
   functioning code that will help clean the table
*/
SELECT 
    cust_id,
    cst_key,
    cst_firstname,
    cst_lastname,
    cst_marital_status,
    cst_gndr,
    cst_create_date
FROM 
    (
        SELECT
        cust_id,
        cst_key,
        TRIM(cst_firstname) AS cst_firstname,
        TRIM(cst_lastname) AS cst_lastname,
        CASE WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
         WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
         ELSE 'n/a'
         END AS cst_marital_status,

        CASE WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
         WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
         ELSE 'n/a'
         END AS cst_gndr,

        cst_create_date,
        ROW_NUMBER() OVER(PARTITION BY cust_id ORDER BY cst_create_date DESC) AS ranked_date
        FROM bronze.crm_cust_info
    )
WHERE ranked_date = 1



-------------------------------------------------------------------------------------------------------------------
/* 
   We insert the table into the silver layer prd_info after 
   completion of your code
*/
-- Before loading the data in the new table we have to make sure that it has been truncated
TRUNCATE TABLE silver.crm_prd_info;
INSERT INTO silver.crm_prd_info (
    prd_id,
    cat_id,
    prd_key,
    prd_nm,
    prd_cost,
    prd_line,
    prd_start_dt ,
    prd_end_dt 
)


/* 
   In the prd_key column, the category_id and the product_key is mixed
   together and we need to seperate it. So we use the SUBSTRING function
   which seperate particular strings from each other, and also the REPLACE
   function, which makes the string or ID the same as that of other tables.
   Also all the NULL values in the cust column is converted to 0 
*/
SELECT 
    prd_id,
    REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
    SUBSTRING(prd_key, 7, LENGTH(prd_key)) AS prd_key,
    TRIM(prd_nm) AS prd_nm,
    CASE WHEN prd_cost IS NULL THEN 0 ELSE prd_cost END AS prd_cost,
    CASE WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
         WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
         WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
         WHEN UPPER(TRIM(prd_line)) = 'T'THEN 'Touring'
         ELSE 'n/a'
         END AS prd_line,
    prd_start_dt,
    LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS prd_end_dt
FROM bronze.crm_prd_info



-------------------------------------------------------------------------------------------------------------------
/* 
   We insert the table into the silver layer sls_details after 
   completion of your code
*/
-- Before loading the data in the new table we have to make sure that it has been truncated
TRUNCATE TABLE silver.crm_sales_details;
INSERT INTO silver.crm_sales_details(
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    sls_sales,
    sls_quantity,
    sls_price
)


/* 
   This is the final code depicting the table in a cleaned state. We checked the first 3 columns 
   for unwanted spaces and did not find any, so its clean to go. Next was the sls_order_dt, sls_ship_dt,
   sls_due_dt which were all in INT data type instead of DATE data type, so we convert it to DATE data type.
   Finally we use the business formula Sales = Quantity * Price to clean up the sales, quantity and price columns.
*/
SELECT
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    CASE WHEN LENGTH(CAST(sls_order_dt AS VARCHAR)) != 8 THEN NULL
         ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
         END AS sls_order_dt,

    CASE WHEN LENGTH(CAST(sls_ship_dt AS VARCHAR)) != 8 THEN NULL
         ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
         END AS sls_ship_dt,
    
    CASE WHEN LENGTH(CAST(sls_due_dt AS VARCHAR)) != 8 THEN NULL
         ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
         END AS sls_due_dt,
    
    CASE WHEN sls_sales <= 0 OR sls_sales IS NULL OR sls_sales != sls_quantity * ABS(sls_price) 
         THEN sls_quantity * ABS(sls_price)
         ELSE sls_sales END AS sls_sales,

    sls_quantity,
    CASE WHEN sls_price <= 0 OR sls_price IS NULL THEN ABS(sls_sales) / sls_quantity
        ELSE sls_price END AS sls_price
FROM bronze.crm_sales_details



-------------------------------------------------------------------------------------------------------------------
/* 
   We insert the table into the silver layer erp_CUST_AZ12 after 
   completion of your code
*/
-- Before loading the data in the new table we have to make sure that it has been truncated
TRUNCATE TABLE silver.erp_CUST_AZ12;
INSERT INTO silver.erp_CUST_AZ12 (
    cid,
    bdate,
    gen
)


SELECT
    CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LENGTH(cid))
    ELSE cid
    END AS cid,
    CASE WHEN bdate > NOW() THEN NULL ELSE bdate END AS bdate,

    CASE WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
        WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
    ELSE 'n/a'
    END AS gen
FROM bronze.erp_CUST_AZ12


-------------------------------------------------------------------------------------------------------------------
-- We then insert our cleaned data into the table silver.erp_LOC_A101
-- Before loading the data in the new table we have to make sure that it has been truncated
TRUNCATE TABLE silver.erp_LOC_A101;
INSERT INTO silver.erp_LOC_A101 (
    cid,
    cntry
)


SELECT 
    REPLACE(cid, '-', '') AS cid,
    CASE WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
         WHEN UPPER(TRIM(cntry)) IN ('US', 'USA', 'UNITED STATES') THEN 'United States'
         WHEN UPPER(TRIM(cntry)) = 'DE' THEN 'Germany'
         ELSE TRIM(cntry)
         END AS cntry
FROM bronze.erp_LOC_A101


-------------------------------------------------------------------------------------------------------------------
-- Even though this table have a good data quality we still have to load it in silver.erp_PX_CAT_G1V2
-- Before loading the data in the new table we have to make sure that it has been truncated
TRUNCATE TABLE silver.erp_PX_CAT_G1V2;
INSERT INTO silver.erp_PX_CAT_G1V2(
    id,
    cat,
    subcat,
    maintenance
)


SELECT 
    id,
    TRIM(cat),
    TRIM(subcat),
    TRIM(maintenance)
FROM bronze.erp_PX_CAT_G1V2
