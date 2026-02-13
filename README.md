
**Tech Layoffs Data Cleaning (PostgreSQL)**

**Project Overview**
This project involves a comprehensive data cleaning process of a raw layoffs dataset using PostgreSQL. The goal was to transform messy, raw data into a structured format ready for Exploratory Data Analysis (EDA).

**🛠️ Skills & Tools Demonstrated**

**SQL Functions:** TRIM(), TRAILING, LENGTH(), TO_CHAR()

**DDL & DML:** CREATE TABLE, INSERT INTO, UPDATE, DELETE, ALTER TABLE

**Advanced Techniques:** Common Table Expressions (CTEs), Window Functions (ROW_NUMBER), Self-Joins for Data Imputation.

**Data Loading:** Handling CSV imports with COPY and managing datestyle formats.

**🧽 Data Cleaning Steps**

**1. Database Setup & Data Loading**

Defined the schema for Total_layoff.

Handled date formatting issues by setting datestyle TO 'ISO, MDY' to ensure the CSV imported correctly.

Utilized the COPY command for high-speed bulk insertion.

**2. Removing Duplicates**

Used a CTE and ROW_NUMBER() partitioned across all columns to identify identical rows.

Created a staging table Total_layoff2 to safely delete duplicate records while preserving the original raw data.

**3. Standardizing Data**

**Company Names:** Removed leading/trailing whitespace using TRIM().

**Industry:** Consolidated variations of industry names (e.g., merging all "Crypto..." variations into a single "Crypto" category).

<img width="735" height="392" alt="Before_Cleaning_Industry" src="https://github.com/user-attachments/assets/69bfb989-233c-4b24-b512-67bb482ec99b" />

<img width="722" height="328" alt="After_Cleaning_Industry" src="https://github.com/user-attachments/assets/1d01ba39-0e69-428b-9544-88d5021b36f0" />



**Country:** Cleaned trailing punctuation (periods) from country names to ensure grouping accuracy (e.g., "United States." → "United States").

**4. Handling Null & Blank Values**

**Self-Join Imputation:** Populated missing industry values by joining the table to itself on company and location. If a company had an industry listed in one row but not another,

the blank was filled with the known value.

**Record Removal:** Deleted rows where both total_laid_off and percentage_laid_off were NULL, as these rows lacked sufficient data for meaningful analysis.

**5. Final Schema Optimization**

Dropped the helper column row_num used during the deduplication process to keep the final dataset lean and professional.

**🚀 How to Use**

Ensure you have PostgreSQL installed.

Run the CREATE TABLE scripts provided in the .sql file.

Update the COPY path to point to your local layoffs.csv.
