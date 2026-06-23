--Retail Sales Analysis--
create database Retail_Sales;

drop table if exists r1;
create table r1(
    transactions_id int primary key,
                  sale_date DATE,
				  sale_time	TIME,
				  customer_id int,
				  gender varchar(6),
				  age int,
				  category varchar(11),
				  quantiy int,
				  price_per_unit float,
				  cogs float,
				  total_sale int);

select * from r1 ;

select * from r1 where transactions_id is null or
                  sale_date is null or
				  sale_time	is null or
				  customer_id is null or
				  gender is null or
				  age is null or
				  category is null or
				  quantiy is null or
				  price_per_unit is null or
				  cogs is null or
				  total_sale is null;

delete from r1 where transactions_id is null or
                  sale_date is null or
				  sale_time	is null or
				  customer_id is null or
				  gender is null or
				  age is null or
				  category is null or
				  quantiy is null or
				  price_per_unit is null or
				  cogs is null or
				  total_sale is null;

--Data Exploration
select count(*) as total_sales from r1;

--How many distinct customers do we have?
select count(distinct customer_id) from r1;

--How many category do we have?
select count(distinct category) from r1;

--What are the category do we have?
select distinct category from r1;

--Data analysis and business key problem and answers
select * from r1 where sale_date='2022-11-05';

select * from r1 where category='Clothing' and quantiy>=2 and to_char(sale_date,'YYYY-MM')='2022-11';

select sum(total_sale) as total_sales,category from r1 group by category;

select round(avg(age)) as avg_age_customers from r1 where category='Beauty';


select * from r1 where total_sale>1000;

select count(*),gender,category as total_transaction from r1 group by gender, category order by gender desc;

select year,month,  avg_sales from
(
select extract( year from sale_date) as year,
extract(month from sale_date) as month,
round(avg(total_sale)) as avg_sales,
rank() over(partition by extract( year from sale_date)  order by avg(total_sale) desc) as best_selling
from r1 group by year,month
)t1
where best_selling=1;

select sum(total_sale),customer_id as highest_total_sale from r1 group by customer_id order by customer_id desc limit 5;

select category,count(distinct customer_id) from r1 group by category;

with hourly_sales as
(
select *, case when extract(hour from sale_time)<12 then 'Morning'
when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
else 'Evening'
end as shift from r1
)
select shift,count(*) from hourly_sales group by shift order by shift desc;