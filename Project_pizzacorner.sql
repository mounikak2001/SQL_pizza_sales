-- 1. Retrive total no of orders placed
SELECT COUNT(*) as total_orders FROM orders ;


-- 2. Calculate total revenue generated from pizza sales
SELECT 
	ROUND(SUM(o.quantity * p.price),2) AS total_revenue
FROM order_details o 
INNER JOIN pizzas p USING (pizza_id);

-- 3. Identify the highest priced pizza (simplest way )
SELECT *
FROM pizzas
WHERE price = (SELECT MAX(price) FROM pizzas);  

-- or ----
-- 3. Identify the highest priced pizza (using Joins )
select pt.name,p.price
FROM pizza_types pt
INNER JOIN pizzas p USING (pizza_type_id)
ORDER BY p.price DESC LIMIT 1;

-- 4. Identify the most common pizza type ordered 
SELECT p.size,count(o.order_id) as order_count
FROM pizzas p
INNER JOIN order_details o USING (pizza_id)
GROUP BY p.size 
 order by order_count DESC ;
 
 -- 5.List top 5 most ordered pizza type along with their quantities
 SELECT pt.name,
		SUM(o.quantity) as total_count 
FROM pizza_types pt INNER JOIN pizzas p USING (pizza_type_id)
INNER JOIN order_details o USING (pizza_id)
GROUP BY pt.name
ORDER BY total_count DESC LIMIT 5;
        
 ----------------------------------------------------------------------------------------------------------------       
 -- 1.Join the necessary tables to find the total quantity of each pizza category ordered    
  SELECT pt.category,
		SUM(o.quantity) as quantity 
FROM pizza_types pt INNER JOIN pizzas p USING (pizza_type_id)
INNER JOIN order_details o USING (pizza_id)
GROUP BY pt.category
ORDER BY quantity DESC ;

-- 2.Determine the distribution of orders by hour of the day
SELECT hour(order_time) as hour,
		COUNT(order_id) as countoforders
FROM orders
GROUP BY hour;
        
-- 3.Join relevant tables to find the category wise distribution of pizzas
SELECT category,COUNT(name) as Noofpizzas
FROM pizza_types
GROUP BY category
ORDER BY Noofpizzas DESC;
        
-- 4.Group the orders by date and calculate the average number of pizzas ordered per day.

WITH CTE1 as (SELECT o.order_date,
			SUM(od.quantity) as Quantity
		FROM orders o 
		INNER JOIN order_details od USING (order_id)
		GROUP BY order_date
		ORDER BY Quantity DESC)
SELECT ROUND(AVG(Quantity),0) AS avgorderperday FROM CTE1 ;

-- 5.Determine the top 3 most ordered pizza types based on revenue
 SELECT pt.name,
	SUM(o.quantity * p.price) as total_revenue
FROM pizza_types pt 
JOIN pizzas p using (pizza_type_id)
JOIN order_details o using (pizza_id)
GROUP BY pt.name
ORDER BY total_revenue DESC LIMIT 3;
        
----------------------------------------------------------------------------------------------------------------        
 
 -- 1.Calculate the percentage contribution of each pizza type to total revenue
  SELECT pt.category,
	ROUND(SUM(o.quantity * p.price) / (SELECT 
	ROUND(SUM(o.quantity * p.price),2) AS total_revenue
	FROM order_details o 
INNER JOIN pizzas p USING (pizza_id))* 100,2 ) as revenue
FROM pizza_types pt 
JOIN pizzas p using (pizza_type_id)
JOIN order_details o using (pizza_id)
GROUP BY pt.category
ORDER BY revenue DESC LIMIT 3;   

-- 2.Determine the top 3 most ordered pizza types based on revenue for each pizza category.    
  WITH CTE2 as( SELECT pt.category,pt.name,
	sum(o.quantity * p.price) as revenue
    from pizza_types pt JOIN pizzas p using(pizza_type_id)
    join order_details o using (pizza_id)
    GROUP BY pt.category,pt.name),
    
    CTE3 as( select *,rank() OVER(partition by category order by revenue) as rn FROM CTE2)
	SELECT * FROM CTE3 where rn <=3
        
        
        
        
        
        
        
        
        
 
