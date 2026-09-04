/*

DDL Script: Create Bronze Tables

Script Purpose:
    This script creates tables in the 'bronze' schema.
*/

CREATE TABLE bronze.crm_cust_info(
    cust_id INT,
    cst_key VARCHAR(40),
    cst_firstname VARCHAR(40),
    cst_lastname VARCHAR(40),
    cst_marital_status VARCHAR(40),
    cst_gndr VARCHAR(40),
    cst_create_date DATE
);

CREATE TABLE bronze.crm_prd_info(
    prd_id INT,
    prd_key VARCHAR(40),
    prd_nm VARCHAR(40),
    prd_cost INT,
    prd_line VARCHAR(40),
    prd_start_dt DATE,
    prd_end_dt DATE
);

CREATE TABLE bronze.crm_sales_details(
    sls_ord_num VARCHAR(70),
    sls_prd_key VARCHAR(70),
    sls_cust_id INT,
    sls_order_dt INT,
    sls_ship_dt INT,
    sls_due_dt INT,
    sls_sales INT,
    sls_quantity INT,
    sls_price INT
);

CREATE TABLE bronze.erp_CUST_AZ12 (
    CID VARCHAR(40),
    BDATE DATE,
    GEN VARCHAR(40)
);

CREATE TABLE bronze.erp_LOC_A101 (
    CID VARCHAR(40),
    CNTRY VARCHAR(40)
);

CREATE TABLE bronze.erp_PX_CAT_G1V2 (
    ID VARCHAR(40),
    CAT VARCHAR(40),
    SUBCAT VARCHAR(40),
    MAINTENANCE VARCHAR(40)
);
