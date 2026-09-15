/* 
Create Dimension: gold.customer_dim
Purpose: Builds the customer dimension table for the gold layer by combining
customer master data (CRM) with demographic and location details
from ERP sources. Applies business logic for gender resolution and
generates a surrogate key.
*/

CREATE VIEW gold.customer_dim AS 
SELECT 
    ROW_NUMBER() OVER(ORDER BY cust_id) AS customer_key, -- surrogate key created for easy joining of tables
    ci.cust_id AS customer_id,
    ci.cst_key AS customer_number,
    ci.cst_firstname AS first_name,
    ci.cst_lastname AS last_name,
    cntry AS country,
    ci.cst_marital_status AS marital_status,
    CASE WHEN cst_gndr != 'n/a' THEN cst_gndr -- CRM gender column is the main gender column
         ELSE COALESCE(gen, 'n/a') 
         END AS gender, 

    bdate AS birthdate,
    ci.cst_create_date AS create_date
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_CUST_AZ12 ca
     ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 lo
     ON ci.cst_key = lo.cid


-- Making sure that the customer_dim was loaded to the database in the gold schema
SELECT *
FROM gold.customer_dim
