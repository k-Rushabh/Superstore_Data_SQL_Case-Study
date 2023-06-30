USE Superstores;
/* A. Describe the data in hand in your own words. (Word Limit is 500)
	1. cust_dimen: Details of all the customers
		
        Customer_Name (TEXT): Name of the customer
        Province (TEXT): Province of the customer
        Region (TEXT): Region of the customer
        Customer_Segment (TEXT): Segment of the customer
        Cust_id (TEXT): Unique Customer ID
	
    2. market_fact: Details of every order item sold
		
        Ord_id (TEXT): Order ID
        Prod_id (TEXT): Prod ID
        Ship_id (TEXT): Shipment ID
        Cust_id (TEXT): Customer ID
        Sales (DOUBLE): Sales from the Item sold
        Discount (DOUBLE): Discount on the Item sold
        Order_Quantity (INT): Order Quantity of the Item sold
        Profit (DOUBLE): Profit from the Item sold
        Shipping_Cost (DOUBLE): Shipping Cost of the Item sold
        Product_Base_Margin (DOUBLE): Product Base Margin on the Item sold
        
    3. orders_dimen: Details of every order placed
		
        Order_ID (INT): Order ID
        Order_Date (TEXT): Order Date
        Order_Priority (TEXT): Priority of the Order
        Ord_id (TEXT): Unique Order ID
	
    4. prod_dimen: Details of product category and sub category
		
        Product_Category (TEXT): Product Category
        Product_Sub_Category (TEXT): Product Sub Category
        Prod_id (TEXT): Unique Product ID
	
    5. shipping_dimen: Details of shipping of orders
		
        Order_ID (INT): Order ID
        Ship_Mode (TEXT): Shipping Mode
        Ship_Date (TEXT): Shipping Date
        Ship_id (TEXT): Unique Shipment ID
        
	
B. Identify and list the Primary Keys and Foreign Keys for this dataset
	(Hint: If a table don’t have Primary Key or Foreign Key, then specifically mention it in your answer.)
	1. cust_dimen
		Primary Key: Cust_id
        Foreign Key: NA
	
    2. market_fact
		Primary Key: NA
        Foreign Key: Ord_id, Prod_id, Ship_id, Cust_id
	
    3. orders_dimen
		Primary Key: Ord_id
        Foreign Key: NA
	
    4. prod_dimen
		Primary Key: Prod_id, Product_Sub_Category
        Foreign Key: NA
	
    5. shipping_dimen
		Primary Key: Ship_id
        Foreign Key: NA
 */
 
/* 1. Write a query to display the Customer_Name and Customer Segment using alias
name “Customer Name", "Customer Segment" from table Cust_dimen. */

  select Customer_name "Customer name" , Customer_segment "Customer Segment"
  from cust_dimen;
  
/* 2. Write a query to find all the details of the customer from the table cust_dimen
order by desc */
select * from Cust_dimen order by customer_Name DESC ;

/* 3. Write a query to get the Order ID, Order date from table orders_dimen where
‘Order Priority’ is high. */
Select Order_ID ,Order_Date 
from orders_dimen 
where Order_Priority='HIGH' ;

/* 4. Find the total and the average sales (display total_sales and avg_sales) */
 SELECT 
    SUM(sales) AS total_sales, AVG(sales) AS avg_sales
	FROM market_fact ;
    
/* 5. Write a query to get the maximum and minimum sales from maket_fact table */
select max(sales) , min(sales)
from market_fact ;  

/* 6. Display the number of customers in each region in decreasing order of
no_of_customers. The result should contain columns Region, no_of_customers. */
 SELECT 
    region, COUNT(*) AS no_of_customers
	FROM cust_dimen
	GROUP BY region
    ORDER BY no_of_customers DESC ;
    
/* 7. Find the region having maximum customers (display the region name and
max(no_of_customers) */

    SELECT 
    region, COUNT(*) AS no_of_customers
	FROM cust_dimen
	GROUP BY region
	HAVING no_of_customers >= ALL
    (	SELECT COUNT(*) AS no_of_customers
	FROM cust_dimen GROUP BY region ) ;
	
/* 8. Find all the customers from Atlantic region who have ever purchased ‘TABLES’
and the number of tables purchased (display the customer name, no_of_tables
purchased)*/
SELECT 
    c.customer_name, COUNT(*) AS no_of_tables_purchased
	FROM
    market_fact m
	INNER JOIN
    cust_dimen c ON m.cust_id = c.cust_id
	WHERE
    c.region = 'atlantic'
	AND m.prod_id = ( SELECT prod_id FROM prod_dimen
	WHERE product_sub_category = 'tables'	)
	GROUP BY m.cust_id, c.customer_name ;
    
/* 9. Find all the customers from Ontario province who own Small Business. (display
the customer name, no of small business owners) */

select Customer_Name as Customer_Name ,count(Customer_Segment) as 'no of small business owners 'from cust_dimen
where Province='Ontario' and Customer_Segment='SMALL BUSINESS' 
group by Customer_Name;

/* 10. Find the number and id of products sold in decreasing order of products sold
(display product id, no_of_products sold) */
SELECT prod_id AS product_id, COUNT(*) AS no_of_products_sold
	FROM market_fact
	GROUP BY prod_id
	ORDER BY no_of_products_sold DESC ;
    
/* 11. Display product Id and product sub category whose produt category belongs to
Furniture and Technlogy. The result should contain columns product id, product
sub category */
select Prod_id,Product_Sub_Category from superstores.prod_dimen
where Product_Category='FURNITURE' or Product_Category='TECHNOLOGY'
group by Prod_id;

/*12. Display the product categories in descending order of profits (display the product
category wise profits i.e. product_category, profits)?*/
select Product_Category,Profit from superstores.market_fact s,superstores.prod_dimen p
where s.Prod_id = p.Prod_id
group by Product_Category order by Profit desc;

/*13. Display the product category, product sub-category and the profit within each
subcategory in three columns. */
select Product_Category,Product_Sub_Category,Profit from superstores.market_fact s,superstores.prod_dimen p
where s.Prod_id = p.Prod_id;

/*14. Display the order date, order quantity and the sales for the order */
select Order_Date,Order_Quantity,Sales from superstores.market_fact s, superstores.orders_dimen c
where s.Ord_id = c.Ord_id;

/*15. Display the names of the customers whose name contains the
 i) Second letter as ‘R’
 ii) Fourth letter as ‘D’*/
 select Customer_Name from superstores.cust_dimen 
where Customer_Name like '_R%' and Customer_Name like '___D%';

/* 16. Write a SQL query to to make a list with Cust_Id, Sales, Customer Name and
their region where sales are between 1000 and 5000. */
select 	c.Cust_id,s.Sales,c.Customer_Name,c.Region from superstores.market_fact s,superstores.cust_dimen c
where s.Cust_id = c.Cust_id and Sales between 1000 and 5000;

/* 17. Write a SQL query to find the 3rd highest sales. */
select min(Sales) as `3rd highest salary` 
FROM (select Sales from superstores.market_fact order by Sales desc limit 3) as a;

/* 18. Where is the least profitable product subcategory shipped the most? For the least
profitable product sub-category, display the region-wise no_of_shipments and the 
profit made in each region in decreasing order of profits (i.e. region,
no_of_shipments, profit_in_each_region)
 → Note: You can hardcode the name of the least profitable product subcategory */
 select Region,count(Ship_id) as no_of_shipment,sum(Profit) as profit_in_each_region from 
superstores.cust_dimen c,superstores.market_fact s,superstores.prod_dimen p
where c.Cust_id = s.Cust_id and s.Prod_id = p.Prod_id
group by Region
order by profit_in_each_region asc;




        