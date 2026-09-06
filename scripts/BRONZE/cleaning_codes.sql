-- THIS IS THE DATA CLEANING CODES FOR THE TABLE bronze.crm_cust_info.
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




-- THIS IS THE DATA CLEANING CODES FOR THE TABLE bronze.crm_prd_info. (THE SECOND TABLE).
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
   We insert the table into the silver layer after 
   completion of your code
*/
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
   Also all the NULL values in the cost column is converted to 0 
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

