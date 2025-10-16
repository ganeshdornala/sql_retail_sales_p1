--SQL Retail Sales Analysis - P1
CREATE DATABASE sql_project_p2;

--Create TABLE
CREATE TABLE retail_sales(
	transactions_id INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(15),
	age INT,
	category VARCHAR(15),
	quantiy INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
)

--Select 1st 10 records from table 
SELECT * FROM retail_sales
LIMIT 10;

--Find number of records in table
SELECT COUNT(*) FROM retail_sales;

--Data Cleaning
--Select records in which transactions_id is null
SELECT * FROM retail_sales 
WHERE transactions_id IS NULL;

--Select records in which sale_date is null
SELECT * FROM retail_sales 
WHERE sale_date IS NULL;

--Select records in which sale_time is null
SELECT * FROM retail_sales 
WHERE sale_time IS NULL;

--Select records in which transactions_id or sale_date or sale_time or gender or category or quantiy or cogs or total_sale is null
SELECT * FROM retail_sales
WHERE
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR 
	sale_time IS NULL
	OR
	gender IS NULL 
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

--Delete records in which transactions_id or sale_date or sale_time or gender or category or quantiy or cogs or total_sale is null
DELETE FROM retail_sales
WHERE
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR 
	sale_time IS NULL
	OR
	gender IS NULL 
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

--Data Exploration
--How many sales we have?
SELECT COUNT(*) AS total_sale FROM retail_sales;

--How many unique customers we have?
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;

--How many unique categories we have?
SELECT COUNT(DISTINCT category) FROM retail_sales;
--List Them
SELECT DISTINCT category FROM retail_sales;


-- Data Analysis & Business Key Problems & Answers
--My Analysis and Findings

--1.Write a SQL Query to retrieve all records for sales made on '2022-11-05'
SELECT *
FROM retail_sales
WHERE sale_date='2022-11-05';

--2.Write a SQL Query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than or equal to 4 in the month of Nov-2022
SELECT *
FROM retail_sales
WHERE 
	category='Clothing'
	AND
	TO_CHAR(sale_date,'YYYY-MM')='2022-11'
	AND
	quantiy>=4
	GROUP BY 1;

--3.Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT 
	category,
	SUM(total_sale) AS net_sale,
	COUNT(*) AS total_orders
FROM retail_sales
GROUP BY 1;

--4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT ROUND(AVG(age),2) AS average_age
FROM retail_sales
WHERE category='Beauty';

--5.Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT *
FROM retail_sales
WHERE total_sale>1000;

--6.Write a SQL query to find the total number of transactions(transactions_id) made by each gender in each category.
SELECT category,gender,COUNT(*)
FROM retail_sales
GROUP BY category,gender
ORDER BY 1;

--7.Write a SQL query to calculate the average sale of each month.Find out best selling month in each year.
SELECT year, month,average_sale
FROM
(
SELECT 
	EXTRACT(YEAR FROM sale_date) AS year,
	EXTRACT(MONTH FROM sale_date) AS month,
	AVG(total_sale) as average_sale,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
FROM retail_sales
GROUP BY 1,2
) as t1
WHERE rank=1;

--8.Write a SQL query to find the top 5 customers based on the highest total sale
SELECT customer_id,SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

--9.Write a SQL query to find the number of unique customers who purchased items from each category
SELECT category,COUNT(DISTINCT customer_id) AS cnt_unique_cs
FROM retail_sales
GROUP BY 1;


--10.Write a SQL query to create each shift and number of orders(Example Morning<=12, Afternoon Between 12 & 17, Evening>17)
WITH hourly_sale
AS
(
SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time)<12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END AS shift
FROM retail_sales
) 
SELECT shift, COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift;

--End of Project