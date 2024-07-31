CREATE DATABASE IF NOT EXISTS salesdatawalmart;

CREATE TABLE IF NOT EXISTS sales (
    invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    quantity INT NOT NULL,
    VAT FLOAT NOT NULL,
    total DECIMAL(12, 4) NOT NULL,  -- Added comma here
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment_method VARCHAR(15) NOT NULL,
    cogs DECIMAL(10, 2) NOT NULL,
    gross_margin_pct FLOAT,
    gross_income DECIMAL(12, 4) NOT NULL,
    rating FLOAT
);


-- -----------------------------------------------------------
-- -----------Feature Engineering----------------------------

-- time_of_day

SELECT time,
	(CASE
		WHEN time >= '00:00:00' AND time <'12:00:00' THEN 'Morning'
        WHEN time >= '12:01:00' AND time < '16:00:00' THEN "Afternoon"
        ELSE 'Evening'
        END) AS time_of_date
FROM sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales
SET time_of_day = (CASE
        WHEN time >= '00:00:00' AND time < '12:00:00' THEN 'Morning'
        WHEN time >= '12:00:00' AND time < '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END);


-- day_name
SELECT date,
dayname(date) AS day_name
from sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name = DAYNAME(date);

-- month-name--
SELECT date,
monthname(date)
FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);
UPDATE sales
SET month_name = monthname(date);


-- ---------------------------------------------
-- ------------Generic------------------------
-- How many unique cities does the data have? 

select distinct city
from sales;

-- In which city is each branch? 

select distinct city,
branch 
from sales;

-- -------------------------------------------
-- ---------Product------------
-- ---How many unique product lines does the data have?

select count(distinct product_line)
from sales;

-- What is the most common payment method?
SELECT payment_method,
	count(payment_method) as cnt
FROM sales
GROUP BY payment_method
order by cnt desc;

-- What is the most selling product line?
select product_line,
count(product_line) as cnt
from sales
group by product_line
order by cnt desc;

-- What is the total revenue by month?
select
month_name as month,
sum(total) as total_revenue
from sales
group by month_name
order by total_revenue desc;

-- What month had the largest COGS?
select
month_name as month,
sum(cogs) as cogs
from sales
group by month_name
order by cogs desc;

-- What product line had the largest revenue?
select product_line,
	sum(total) as total_revenue
from sales
group by product_line
order by total_revenue desc;


-- What is the city with the largest revenue?
select branch, city,
	sum(total) as total_revenue
from sales
group by city, branch
order by total_revenue desc;

-- What product line had the largest VAT?
select product_line,
	avg(vat) as avg_tax
from sales
group by product_line
order by avg_tax desc;

-- Fetch each product line and add a column to those product 
-- line showing "Good", "Bad". Good if its greater than average sales

SELECT 
	AVG(quantity) AS avg_qnty
FROM sales;

SELECT
	product_line,
	CASE
		WHEN AVG(quantity) > 6 THEN "Good"
        ELSE "Bad"
    END AS remark
FROM sales
GROUP BY product_line;




















-- Which branch sold more products than average product sold?
select branch,
	sum(quantity) as qty
    from sales
    group by branch
    having sum(quantity) > (select avg(quantity) from sales)
    order by qty desc;
    
    -- What is the most common product line by gender?
   
   select gender, product_line,
   count(gender) as total_cnt
   from sales
   group by gender, product_line
   order by total_cnt desc;
   
   -- What is the average rating of each product line?
   select product_line,
   round(avg(rating), 1) as avg_rating
   from sales
   group by product_line
   order by avg_rating desc;
   
 -- -----------------------------------------
 -- -----sales----------
 
 -- Number of sales made in each time of the day per weekday
 
select time_of_day,
count(*) as total_sales
from sales
where day_name = 'monday' -- change day here
group by time_of_day
order by  total_sales desc;

   -- Which of the customer types brings the most revenue?  
   select customer_type,
   round(sum(total), 1) as total_rev
   from sales
GROUP BY customer_type
order by total_rev desc;


-- Which city has the largest tax percent/ VAT (Value Added Tax)?
Select city,
round(avg(vat), 2) as VAT	
from sales
group by city
order by vat desc;


-- Which customer type pays the most in VAT?
Select customer_type,
round(avg(vat), 2) as VAT	
from sales
group by customer_type
order by vat desc;

-- -----------------------------------------------
-- ------Customer-----------------
-- How many unique customer types does the data have?
select customer_type,
count(distinct customer_type) as cnt
from sales
Group by customer_type
order by cnt;


-- How many unique payment methods does the data have?
select payment_method,
count(distinct payment_method) as cnt
from sales
Group by payment_method
order by cnt;

-- What is the most common customer type and who buys the most?
select customer_type,
count(customer_type) as cnt
from sales
group by customer_type
order by cnt desc;

-- What is the gender of most of the customers
select gender,
count(gender) as cnt
from sales
group by gender
order by cnt desc;


-- What is the gender distribution per branch?
select gender,
count(gender) as cnt
from sales
where branch ='c' -- change branch letter here branch are A, B and C 
group by gender
order by cnt desc;

-- Which time of the day do customers give most ratings?

select time_of_day,
round(avg(rating), 1) as avg_rating
from sales
group by time_of_day
order by avg_rating desc;
 

-- Which time of the day do customers give most ratings per branch?
select time_of_day,
branch,
round(avg(rating), 1) as avg_rating
from sales
where branch ='c' -- change branch letter here branch are A, B and C 
group by time_of_day
order by avg_rating desc;

-- Which day fo the week has the best avg ratings?
select day_name,
avg(rating) as avg_rating
from sales
group by day_name
order by avg_rating desc;

-- Which day of the week has the best average ratings per branch?

select day_name,
avg(rating) as avg_rating
from sales
where branch = 'b' -- change branch letter here branch are A, B and C
group by day_name
order by avg_rating desc;





