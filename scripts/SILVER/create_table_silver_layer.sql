/*

DDL Script: Create silver Tables

Script Purpose:
    This script creates tables in the 'silver' schema.
*/

CREATE TABLE silver.crm_cust_info(
    cust_id INT,
    cst_key VARCHAR(40),
    cst_firstname VARCHAR(40),
    cst_lastname VARCHAR(40),
    cst_marital_status VARCHAR(40),
    cst_gndr VARCHAR(40),
    cst_create_date DATE
);

CREATE TABLE silver.crm_prd_info(
    prd_id INT,
    cat_id VARCHAR(40),
    prd_key VARCHAR(40),
    prd_nm VARCHAR(40),
    prd_cost INT,
    prd_line VARCHAR(40),
    prd_start_dt DATE,
    prd_end_dt DATE
);

CREATE TABLE silver.crm_sales_details(
    sls_ord_num VARCHAR(70),
    sls_prd_key VARCHAR(70),
    sls_cust_id INT,
    sls_order_dt DATE,
    sls_ship_dt DATE,
    sls_due_dt DATE,
    sls_sales INT,
    sls_quantity INT,
    sls_price INT
);

CREATE TABLE silver.erp_CUST_AZ12 (
    CID VARCHAR(40),
    BDATE DATE,
    GEN VARCHAR(40)
);

CREATE TABLE silver.erp_LOC_A101 (
    CID VARCHAR(40),
    CNTRY VARCHAR(40)
);

CREATE TABLE silver.erp_PX_CAT_G1V2 (
    ID VARCHAR(40),
    CAT VARCHAR(40),
    SUBCAT VARCHAR(40),
    MAINTENANCE VARCHAR(40)
);



SELECT * FROM silver.crm_cust_info
SELECT * FROM silver.crm_prd_info
SELECT * FROM silver.crm_sales_details
SELECT * FROM silver.erp_cust_az12
SELECT * FROM silver.erp_loc_a101
SELECT * FROM silver.erp_px_cat_g1v2
