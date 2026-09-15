-- THESE ARE THE CODES THAT IS USED TO CLEAN THE BRONZE LAYER TABLES AND LOAD THEM INTO THE SILVER LAYER

-- THIS IS THE DATA CLEANING CODES FOR THE TABLE bronze.crm_cust_info. (THE FIRST CRM TABLE)
/* 
    Before sending our data to the silver layer we have to
    ensure that the id located in each tables are unique starting
    from the bronze.crm_cust_info. this removes the duplicates located
    in the table.
*/
SELECT 
    cust_id,
    COUNT(*)
FROM bronze.crm_cust_info
GROUP BY 1
HAVING COUNT(*) > 1

/* 
    We find out that the duplicated ids are being updated as days passes,
    that is the latest date has the latest updated id, so we need to use the 
    id with the latest date, thats where the ROW_NUMBER function is used.
*/
WITH not_uniqueid AS (
    SELECT 
    cust_id,
    ROW_NUMBER() OVER(PARTITION BY cust_id ORDER BY cst_create_date DESC) AS ranked_date
FROM bronze.crm_cust_info
)
SELECT *
FROM not_uniqueid
WHERE ranked_date != 1


--This is the code to bring out the unique ids located in the bronze.crm_cust_info table
WITH uniqueid AS (
    SELECT 
    cust_id,
    ROW_NUMBER() OVER(PARTITION BY cust_id ORDER BY cst_create_date DESC) AS ranked_date
FROM bronze.crm_cust_info
)
SELECT *
FROM uniqueid
WHERE ranked_date = 1


/* 
    Strings can be located in the table bronze.crm_cust_info, and 
    we have to ensure that the spacing is done well and there is no 
    unwanted spacing, that is thereis no spaces in the beginning of 
    any string, and for that we use the TRIM() function.
*/
-- Same code is used to chect the cst_lastname
SELECT cst_firstname
FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)


/* 
    Next is the genders, abbreviations are being used, M representing
    Male and F representing Female, we need to write a code that will 
    replace the M and F abbreviations with Male and Female. We add UPPER
    and TRIM just in case of the appearance of lowercase and wrong spacing.
*/

SELECT 
    cst_gndr,
    CASE WHEN UPPER(TRIM (cst_gndr)) = 'M' THEN 'Male'
         WHEN UPPER(TRIM (cst_gndr)) = 'F' THEN 'Female'
         ELSE 'n/a'
         END AS cst_gender
FROM bronze.crm_cust_info
LIMIT 100


-- We do the samething above for the cst_marital_status column
SELECT 
    cst_marital_status,
    CASE WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
         WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
         ELSE 'n/a'
         END AS cst_marital_status
FROM bronze.crm_cust_info
LIMIT 100



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



SELECT COUNT(*)
FROM silver.crm_cust_info

------------------------------------------------------------------------------------------------------
-- THIS IS THE DATA CLEANING CODES FOR THE TABLE bronze.crm_prd_info. (THE SECOND CRM TABLE).
/* 
   After writing the code below we find out that there is no prd_id that
   was duplicated. So the step of removing duplicated ids have been done.
*/
SELECT 
    prd_id,
    COUNT(*)
FROM bronze.crm_prd_info
GROUP BY 1
HAVING COUNT(*) > 1


-- This is to check for unwanted spaces
SELECT prd_nm
FROM bronze.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)


-- This is where we give teh full name to abbreviations for better understanding
SELECT 
    prd_line,
    CASE WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
         WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
         WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
         WHEN UPPER(TRIM(prd_line)) = 'T'THEN 'Touring'
         ELSE 'n/a'
         END
FROM bronze.crm_prd_info


-- This is for checking if the start date occcurs before the end date
SELECT *
FROM bronze.crm_prd_info
WHERE prd_start_dt > prd_end_dt


/* 
   We find out that the end date occurs eaarlier than the start date and 
   swapping their dates does not solve the problem because the cost of the 
   product overlap each other, so we use the LEAD function sol solve the
   problem by picking the next start date and subtracting it by 1
*/
SELECT 
    prd_id,
    prd_key,
    prd_nm,
    prd_start_dt,
    prd_end_dt,
    LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS date_test
FROM bronze.crm_prd_info
WHERE prd_start_dt > prd_end_dt AND prd_key IN ('AC-HE-HL-U509-R', 'CO-MF-FR-M94B-38')


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



SELECT COUNT(*)
FROM silver.crm_prd_info

------------------------------------------------------------------------------------------------------
-- THIS IS THE DATA CLEANING CODES FOR THE TABLE bronze.crm_sales_details. (THE THIRD CRM TABLE).
/* 
   For the first table we check and make sure that there is no unwanted
   spaces in each rows. And the TRIM it.
*/
SELECT 
    sls_ord_num
FROM bronze.crm_sales_details
WHERE sls_ord_num != TRIM(sls_ord_num)


-- We also check the sls_prd_key column for unwanted spaces.
SELECT 
    sls_prd_key
FROM bronze.crm_sales_details
WHERE sls_prd_key != TRIM(sls_prd_key)


-- This is to check if the cust_id have a NULL value
SELECT 
    sls_cust_id
FROM bronze.crm_sales_details
WHERE sls_cust_id IS NULL


/* 
   Check if the sls_prd_key in the sls_sales_details table is similar
   or corresponding with that of the prd_key in other tablesn, so that
   joining or connecting them will be easy.
*/
SELECT *
FROM bronze.crm_sales_details
WHERE sls_prd_key NOT IN (SELECT prd_key FROM silver.crm_prd_info)


-- We also check if the sls_cust_id corresponds with that of the cust_id in the silver.crm_cust_info table
SELECT *
FROM bronze.crm_sales_details
WHERE sls_cust_id NOT IN (SELECT cust_id FROM silver.crm_cust_info)


/* 
   The date is in an integer format and we need to check if it length is that of a complete date.
   if not replace the 0 with NULL. we use this same code for the sls_ship_date and the sls_due_date
   bacause their data type is the DATE data type but they are represented by an INT data type. the code 
   used to convert INT data type to DATE data type is CAST(CAST(sls_order_dt AS VARCHAR) AS DATE).
*/
SELECT 
    sls_order_dt,
    CASE WHEN LENGTH(CAST(sls_order_dt AS VARCHAR)) != 8 THEN NULL
         ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
         END AS sls_order_dt_clean
FROM bronze.crm_sales_details
WHERE LENGTH(CAST(sls_order_dt AS VARCHAR)) != 8


/* 
   There is a business rule which says that Sales = Quantity * Price. Also all columns should not have
   negative numbers, Zeros and NULLS in it. Other rules may include
   - If sales is negative, zero or NULL, derive it using quantity and price (quantity * price)
   - If price is zero or NULL, calculate it using sales and quantity (sales / quantity)
   - If price is negative, convert it to a positive value(you can use the function ABS())
*/
SELECT DISTINCT
    sls_sales AS ols_sls_sales,
    sls_quantity,
    sls_price AS old_sls_price,
    CASE WHEN sls_sales <= 0 OR sls_sales IS NULL OR sls_sales != sls_quantity * ABS(sls_price) 
         THEN sls_quantity * ABS(sls_price)
         ELSE sls_sales END AS sls_sales,

        CASE WHEN sls_price <= 0 OR sls_price IS NULL THEN ABS(sls_sales) / sls_quantity
        ELSE sls_price END AS sls_price
FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price OR sls_price IS NULL
      OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_quantity <= 0
      OR sls_price <= 0 OR sls_sales <= 0
ORDER BY sls_sales, sls_quantity, sls_price 


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


-- Code to check if the table is properly cleaned, It should return NO DATA
SELECT *
FROM silver.crm_sales_details
WHERE sls_ord_num != TRIM(sls_ord_num) OR sls_prd_key != TRIM(sls_prd_key)
      OR sls_cust_id IS NULL OR sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt
      OR sls_sales != sls_quantity * sls_price OR sls_sales IS NULL OR sls_sales <= 0
      OR sls_quantity <= 0 OR sls_quantity IS NULL


-- Code to look at the cleaned table
SELECT COUNT(*)
FROM silver.crm_sales_details


------------------------------------------------------------------------------------------------------
-- THIS IS THE DATA CLEANING CODES FOR THE TABLE bronze.erp_CUST_AZ12. (THE FIRST erp TABLE).
/* 
   Sometimes the id of a table may have a different start from that of another
   table. And in order to clean it up we have to find a way to remove what makes
   them different. Thats where this code comes in.
*/
SELECT
    cid,
    CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LENGTH(cid))
    ELSE cid
    END AS cid_new
FROM bronze.erp_CUST_AZ12


/* 
    We also check if the cid(customer key) corresponds with that of the cst_key in the silver.crm_cust_info
    table, so that joining the two tables will be easy without errors.
*/
SELECT *
FROM ( 
    SELECT
    cid,
    CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LENGTH(cid))
    ELSE cid
    END AS cid_new
FROM bronze.erp_CUST_AZ12
)
WHERE cid_new NOT IN (SELECT cst_key FROM silver.crm_cust_info)


-- As for the customers birthdate we correct the birthdate that have passed the current date, that is todays date
SELECT
    bdate,
    CASE WHEN bdate > NOW() THEN NULL ELSE bdate END
FROM bronze.erp_CUST_AZ12
WHERE bdate > NOW()


-- We clean the abbreviations located in the gen column by giving them their full name
SELECT DISTINCT gen,
    CASE WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
        WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
    ELSE 'n/a'
    END
FROM bronze.erp_CUST_AZ12


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


SELECT COUNT(*)
FROM silver.erp_CUST_AZ12

------------------------------------------------------------------------------------------------------
-- THIS IS THE DATA CLEANING CODES FOR THE TABLE bronze.erp_LOC_A101. (THE SECOND erp TABLE).
-- View of table before cleaning is performed
SELECT *
FROM bronze.erp_LOC_A101


/* 
    There is a difference with this table cid and other table cid and cst_key, and what is different
    is the presence of '-'. So to make joining with other tables possible we have to remove it, to do 
    that we use the function REPLACE()
*/
SELECT *
FROM (   
    SELECT 
    cid,
    REPLACE(cid, '-', '') AS cid_new,
    cntry
FROM bronze.erp_LOC_A101)
WHERE cid_new NOT IN (SELECT cst_key FROM bronze.crm_cust_info)


-- We look for abbreviations to give then their full meaning and give NULL values 'n/a' 
SELECT 
    DISTINCT cntry,
    CASE WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
         WHEN UPPER(TRIM(cntry)) IN ('US', 'USA', 'UNITED STATES') THEN 'United States'
         WHEN UPPER(TRIM(cntry)) = 'DE' THEN 'Germany'
         ELSE cntry
         END AS cntry_new
FROM bronze.erp_LOC_A101
ORDER BY cntry


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


SELECT COUNT(*)
FROM silver.erp_LOC_A101



------------------------------------------------------------------------------------------------------
-- THIS IS THE DATA CLEANING CODES FOR THE TABLE bronze.erp_PX_CAT_G1V2. (THE THIRD erp TABLE).
-- Check if the id matches the cat_id located in the silver.crm_prd_info table.
SELECT *
FROM bronze.erp_PX_CAT_G1V2
WHERE id NOT IN (SELECT cat_id FROM silver.crm_prd_info)

-- Category distinct rows
SELECT DISTINCT cat
FROM bronze.erp_PX_CAT_G1V2

-- Sub_category distinct rows
SELECT DISTINCT subcat
FROM bronze.erp_PX_CAT_G1V2

-- Maintenance distinct rows
SELECT DISTINCT maintenance
FROM bronze.erp_PX_CAT_G1V2

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


SELECT COUNT(*)
FROM silver.erp_PX_CAT_G1V2
