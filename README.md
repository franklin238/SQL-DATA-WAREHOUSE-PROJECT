# 🏗️ Data Warehouse Project (PostgreSQL + VS Code)

Building a modern data warehouse with **PostgreSQL**, covering **ETL processes**, **data modelling**, and **analytics** — from raw source data to analytics-ready tables.

---

## 📖 Project Overview

This project involves:

- **Data Architecture**: Designing a modern data warehouse using a layered approach (Bronze, Silver, and Gold layers).
- **ETL Pipelines**: Extracting, transforming, and loading data from source systems into the warehouse.
- **Data Modelling**: Building fact and dimension tables optimized for analytical queries.
- **Analytics**: Generating SQL-based reports and insights for actionable business intelligence.

---

## 🎯 Project Requirements

### Building the Data Warehouse (Data Engineering)

**Objective**
Develop a modern data warehouse using PostgreSQL to consolidate data, enabling analytical reporting and informed decision-making.

**Specifications**
- **Data Sources**: Import data from two source systems (e.g., ERP and CRM) provided as CSV files.
- **Data Quality**: Cleanse and resolve data quality issues prior to analysis.
- **Integration**: Combine both sources into a single, user-friendly data model designed for analytical queries.
- **Scope**: Focus on the latest dataset only; historization of data is not required.
- **Documentation**: Provide clear documentation of the data model to support both business stakeholders and analytics teams.

### BI: Analytics & Reporting (Data Analytics)

**Objective**
Develop SQL-based analytics to deliver detailed insights into:

- **Customer Behaviour**
- **Product Performance**
- **Sales Trends**

These insights empower stakeholders with key business metrics, enabling strategic decision-making.

---

## 🧰 Tools & Technologies

| Tool | Purpose |
|---|---|
| **PostgreSQL** | Core database engine for hosting the data warehouse |
| **VS Code** | SQL development, scripting, and project management |
| **pgAdmin / psql** | Database administration and querying |
| **CSV Datasets** | Raw source data (ERP and CRM extracts) |
| **Git & GitHub** | Version control and project documentation |
| **draw.io (optional)** | Data architecture and data flow diagrams |

---

## 🏛️ Data Architecture

The project follows the **Medallion Architecture** (Bronze, Silver, Gold):

1. **Bronze Layer**: Stores raw, unprocessed data as-is from the source systems (CSV files ingested into PostgreSQL).
2. **Silver Layer**: Includes data cleansing, standardization, and normalization to prepare data for analysis.
3. **Gold Layer**: Houses business-ready data modelled into a **star schema** (fact and dimension tables) for reporting and analytics.

---

## 📂 Repository Structure

```
data-warehouse-project/
│
├── datasets/                 # Raw source datasets (ERP and CRM CSV files)
│
├── scripts/                  # SQL scripts for ETL and transformations
│   ├── bronze/                # Scripts for loading raw data
│   ├── silver/                # Scripts for cleaning and transforming data
│   └── gold/                  # Scripts for building the final data model
│
├── tests/                    # Data quality checks and validation scripts
│
├── docs/                     # Project documentation and architecture diagrams
│   ├── data_architecture.png    # Overview of the project's architecture
│   ├── data_flow.png            # Data flow diagram
│   ├── data_models.png          # Star schema diagram
│   └── naming_conventions.md    # Naming guidelines for tables, columns, and files
│
├── README.md                 # Project overview and instructions
└── LICENSE                   # License information for the project
```

---

## 🚀 Getting Started

1. **Install PostgreSQL** and set up a local or cloud instance.
2. **Install VS Code** along with a PostgreSQL/SQL extension (e.g., PostgreSQL by Chris Kolkman, or SQLTools).
3. Clone this repository:
   ```bash
   git clone https://github.com/franklin238/SQL-DATA-WAREHOUSE-PROJECT.git
   ```
4. Load the raw datasets into the **Bronze** layer using the scripts in `scripts/bronze/`.
5. Run the **Silver** and **Gold** layer scripts in order to build the final analytical model.
6. Use the reporting queries in `scripts/gold/` (or a BI tool of your choice) to explore the analytics.

---

## 📜 License

This project is licensed under the **MIT License**. You are free to use, modify, and distribute this project with proper attribution. See the [LICENSE](LICENSE) file for full details.

---

## 👋 About Me

Hi, I'm **Chima** — an aspiring **analytics engineer** based in Nigeria, and this is my first end-to-end project. 

My long-term focus is **Web3**, and building a strong analytics engineering foundation is part of that path. Before going deeper into on-chain data work, I wanted to broaden my grasp of core **Web2** data engineering concepts — ETL, data modelling, and SQL-based analytics — since these fundamentals carry over directly into how blockchain and on-chain data is eventually queried, modelled, and analyzed.

This project is a stepping stone: as I grow, my focus will increasingly shift toward Web3 analytics, but the skills built here (PostgreSQL, ETL design, dimensional modelling) form the base everything else will sit on.

**Let's connect:**
- 🐦 X (Twitter): [@chima]
- 💻 GitHub: [https://github.com/franklin238]
