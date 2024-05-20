create database if not exists salesdatawalmart;
-- creating table
create table if not exists sales( 
  invoice_id varchar(30) not null primary key,
  branch varchar(5) not null,
  city varchar(30) not null,
  customer_type varchar(30) not null,
  gender varchar(10) not null,
  product_line varchar(100) not null,
  unit_price decimal(10,2) not null,
  quantity int not null,
  vat float (6,4) not null,        -- tax : the amt of tax on the purchase
  total decimal(12,4) not null,
  date DATETIME not null,
  time TIME not null,
  payment_method varchar(15)  not null,
  cogs decimal(10,2) not null,
  gross_margin_pct float (11,9) not null, 
  gross_income decimal(12,4) not null,
  rating float(2,1) 
);
select * from sales;
select time from sales;
-- Feature Engineering----
-- creating a new column
select 
   time,
   (CASE
      when `time` between "00:00:00"  and "12:00:00" then "Morning" 
      when `time` between "12:01:00"  and "16:00:00" then "Afternoon" 
      else "Evening"
	end
   )as time_of_date  from sales;
select * from sales;
-- to add time_of_date column in to table 

alter table sales add column time_of_day varchar(20);
update sales
set time_of_day = (
   CASE
      when `time` between "00:00:00"  and "12:00:00" then "Morning" 
      when `time` between "12:01:00"  and "16:00:00" then "Afternoon" 
      else "Evening"
   end
);

-- day name column
select date,
dayname(date)  as day_name
 from sales;

alter table sales add column day_name varchar(20);

update sales
set day_name = DAYNAME(date);

-- month name
select date,
monthname(date)
from sales; 

alter table sales add column month_name varchar(10);

update sales
set month_name = monthname(date);


-- ------------------------------------------------------------------------------------------------------------------------------------
-- 1. how many uniques cities does the data have?
select distinct(city) from sales;

-- 2 . in which city each branch is?

select distinct branch from sales;

select distinct city,
branch
from sales;

-- 3.How many unique poduct lines does the data have.
select count(distinct product_line) from sales;

-- 4. what is the most common payment method?
select  payment_method , count(payment_method) as cnt from sales
group by payment_method  
order by cnt desc;

-- 5.what is the most selling product_line
select product_line from sales;
select  product_line, count(product_line)  as cnt from sales
group by product_line
order by cnt asc;

-- 6.what is the total revenue by month?
select month_name as month,
sum(total) as total_revenue
from sales
group by month_name
order by total_revenue desc;

-- 7.what month had the largest cogd?
select month_name as month,
sum(cogs) as cog
from sales
group by month_name
order by cog asc;

-- 8 . what product_line hass the largest revenue?
select product_line,
sum(total) as total_revenue
from sales
group by product_line
order by total_revenue desc
;

-- 9. what is the city with largest revenue?
select city,
sum(total) as total_revenue
from sales
group by city
order by total_revenue desc
;

-- 10. what product_line has largest vat.
select product_line,
avg(vat) as avg_tax
from sales
group by product_line
order by avg_tax desc ;

-- 11.fetch each product_line and add a column to  those product_line showing 'good','bad'. good if is greate than avg sales.


-- 12.which branch sold more products than avg product sold?
select branch,
sum(quantity) as qty
from sales
group by branch
having sum(quantity)>( select avg(quantity) from sales);

-- 13.what is the most product_line by gender
select gender, product_line,
count(gender) as cnt
from sales
group by gender,product_line
order by cnt desc;

-- 14. avg rating of each product_line
select product_line,
round(avg(rating),2) as avg_rating
from sales
group by product_line;
































