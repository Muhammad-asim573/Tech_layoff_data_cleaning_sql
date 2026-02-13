                        --CREATING TABLE TO STORE THE DATA

CREATE TABLE Total_layoff(
company varchar(100),
location varchar(100),
industry varchar(100),
total_laid_off int,
percentage_laid_off decimal(5,4),
date date,
stage varchar(100),
country varchar(100),
funds_raised_millions numeric (10,2)
)
SELECT * FROM Total_layoff;

--PostgreSQL's default date style is usually ISO, MDY or ISO, YMD, so must explicitly tell it to 
--use Day-Month-Year (DMY) format temporarily.because we are importing the csv data in that date is DMY;

SET datestyle TO 'ISO, MDY';

                          --BULK INSERT METHOD FOR DATA IMPORT
COPY Total_layoff
FROM 'D:\layoffs.csv'
WITH (FORMAT CSV, HEADER, NULL 'NULL');

SELECT * FROM Total_layoff;

                                   --DATA CLEANING
                                 --1.REMOVING DUPLICATES.

WITH Duplicate_cte AS(
SELECT *,
ROW_NUMBER()OVER(PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,date,stage,
country,funds_raised_millions)as row_num
FROM Total_layoff)
SELECT * FROM Duplicate_cte
WHERE row_num >1;

--CREATING A NEW TABLE TO UNIQUELY IDENTIFY THE ROW IN THAT TABLE WE CAN PUT ABOVE STATEMENT LIKE ROW_NUMBER WITH ALL OTHER COLUMN
CREATE TABLE Total_layoff2(
company varchar(100),
location varchar(100),
industry varchar(100),
total_laid_off int,
percentage_laid_off decimal(5,4),
date date,
stage varchar(100),
country varchar(100),
funds_raised_millions numeric (10,2),
row_num int
);

SELECT * FROM Total_layoff2;

INSERT INTO Total_layoff2
SELECT *,
ROW_NUMBER()OVER(PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,date,stage,
country,funds_raised_millions)as row_num
FROM Total_layoff;

SELECT * FROM Total_layoff2;

SELECT * FROM Total_layoff2
WHERE row_num >1;

DELETE FROM Total_layoff2
WHERE row_num >1;

                             --2.STANDARDIZING THE DATA
							 
SELECT company,LENGTH(company),LENGTH(TRIM(company))
FROM Total_layoff2;

UPDATE Total_layoff2
SET company=TRIM(company);


SELECT DISTINCT industry
FROM Total_layoff2
ORDER BY 1;

UPDATE Total_layoff2
SET industry='Crypto'
WHERE industry LIKE 'Crypto%';

SELECT * FROM Total_layoff2
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT location
FROM Total_layoff2;

SELECT DISTINCT country
FROM Total_layoff2;

SELECT DISTINCT country,TRIM(TRAILING '.' FROM country)
FROM Total_layoff2;

UPDATE Total_layoff2
SET country=TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

SELECT * FROM Total_layoff2;

                         --3.NULL VALUES OR BLANK VALUES

SELECT *
FROM Total_layoff2
WHERE industry IS NULL
OR industry='';

SELECT * FROM Total_layoff2
WHERE company='Airbnb';

SELECT T1.industry,T2.industry FROM Total_layoff2 T1
JOIN Total_layoff2 T2
ON T1.company=T2.company
AND T1.location=T2.location
WHERE (T1.industry IS NULL OR T1.industry='')
AND (T2.industry IS NOT NULL OR T2.industry!='');


UPDATE Total_layoff2 T1
SET industry = T2.industry -- No alias on the left side of the equals sign
FROM Total_layoff2 T2
WHERE T1.company = T2.company
  AND T1.location = T2.location
  AND (T1.industry IS NULL OR T1.industry = '')
  AND (T2.industry IS NOT NULL AND T2.industry != '');

SELECT * FROM Total_layoff2;  
                             --4.REMOVE ANY COLUMN THAT IS NOT REQUIRED
SELECT *
FROM Total_layoff2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE FROM Total_layoff2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT * FROM Total_layoff2;

--at last we don't need the uniquely identified row_num column which i was created my self.
ALTER TABLE Total_layoff2
DROP COLUMN row_num;

SELECT * FROM Total_layoff2;





























