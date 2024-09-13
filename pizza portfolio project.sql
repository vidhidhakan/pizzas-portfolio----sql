create database pizzahut

use pizzahut

select * from pizzas

select * from pizza_types

select * from orders

select * from order_details

--- Basic:
--Retrieve the total number of orders placed.

select * from orders

select count(order_id) as totalorder from orders 


-- Calculate the total revenue generated from pizza sales.

select * from pizzas

select * from order_details

select sum(price*quantity) as totalsales
from pizzas as p
join order_details as o 
on p.pizza_id = o.pizza_id



--Identify the highest-priced pizza.


select * from pizzas

select * from order_details

select pizza_types.name, pizzas.price
from pizza_types 
join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
order by pizzas.price desc





-- Identify the most common pizza size ordered.


select *from pizzas

select * from order_details

select pizzas.size, count(order_details.order_details_id)
from pizzas
join order_details
on pizzas.pizza_id = order_details.pizza_id
group by pizzas.size

---------------------------------------------------------------------

--List the top 5 most ordered pizza types 

---along with their quantities.

select * from pizzas

select * from pizza_types

select * from order_details


select pizza_types.name,sum( order_details.quantity) as totalquantity
from pizzas 
join pizza_types 
on pizzas.pizza_type_id = pizza_types.pizza_type_id
join order_details
on pizzas.pizza_id = order_details.pizza_id
group by pizza_types.name 
order by totalquantity desc 



--------------------------------------------------------------------------- INTERMEDIATE LEVEL ----------------------------

 
--Join the necessary tables to find 
--the total quantity of each pizza category ordered.

select * from order_details
select * from pizzas
select * from pizza_types

select pizza_types.category,sum( order_details.quantity) as totalquantity
from pizza_types
join pizzas 
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on pizzas.pizza_id = order_details.pizza_id
group by pizza_types.category
order by totalquantity desc


---- Determine the distribution of orders by hour of the day.

SELECT * 
FROM orders;

-- Extract the hour from order_time
SELECT DATEPART(HOUR, time) as totalhr, count(order_id ) as orderid
FROM orders
group by DATEPART(HOUR, time)
order by orderid;


----Join relevant tables to find the category-wise distribution of pizzas.

select * from pizza_types
select * from pizzas

select category, count(name) as totalname
from pizza_types
group by category


----Group the orders by date and 
--calculate the average number of pizzas ordered per day.

select * from orders

select * from order_details

WITH cte AS (
    SELECT 
        orders.date,                     -- Assuming the date column is 'order_date'
        SUM(order_details.quantity) AS total_quantity
    FROM orders
    JOIN order_details 
    ON orders.order_id = order_details.order_id
    GROUP BY orders.date
)
SELECT AVG(total_quantity) AS avg_pizzas_per_day
FROM cte;



---Determine the top 3 most ordered pizza types based on revenue.

select * from pizza_types
select * from pizzas
select * from order_details


select pizza_types.name, sum(pizzas.price * order_details.quantity) as totalsales
from pizza_types
join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on pizzas.pizza_id = order_details.pizza_id
group by pizza_types.name
order by totalsales desc ;



----------------------------------------------------------------------- advance level 


--Determine the top 3 most ordered pizza types 
--based on revenue for each pizza category.


select * from pizza_types
select * from pizzas
select * from order_details

WITH cte AS (
  SELECT 
    pizza_types.category, 
    pizza_types.name, 
    SUM(pizzas.price * order_details.quantity) AS revenue
  FROM 
    pizza_types 
  JOIN pizzas
    ON pizza_types.pizza_type_id = pizzas.pizza_type_id
  JOIN order_details
    ON pizzas.pizza_id = order_details.pizza_id
  GROUP BY 
    pizza_types.category, 
    pizza_types.name
)
SELECT 
  category, 
  name, 
  revenue,
  Rank() over (partition by category order by revenue desc) as rank
FROM cte


