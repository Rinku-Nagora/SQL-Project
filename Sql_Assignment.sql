# project on monday coffee cafe

CREATE SCHEMA Monday_Coffee;

USE Monday_Coffee;

CREATE TABLE City(
City_ID INT PRIMARY KEY,
City_Name VARCHAR(100),
Population INT,
Estimated_Rent INT,
City_Rank INT
);

CREATE TABLE Customers(
Customers_ID INT PRIMARY KEY,
Customer_Name VARCHAR(50),
City_ID INT,
FOREIGN KEY (City_ID) REFERENCES City(City_ID)
);

CREATE TABLE Products(
Product_ID INT PRIMARY KEY,
Product_Name VARCHAR(100),
Price INT
);

CREATE TABLE Sales(
Sale_ID INT PRIMARY KEY,
Sale_Date char(50),
Product_ID INT,
Quantity INT,
Customers_ID INT,
Total_Amount INT,
Rating INT,
FOREIGN KEY (Product_ID) REFERENCES Products(Product_ID),
FOREIGN KEY (Customers_ID) REFERENCES Customers(Customers_ID)
);

Select str_to_date(Sale_Date, "%YYYY %MM %DD") AS Formated_Date
From Sales;
Update Sales
SET Sale_Date = str_to_date(sale_date, '%m/%d/%Y');

-----IDentifying the null_Values in the datasets----

SELECT *
FROM City
WHERE City_ID IS NULL
OR City_Name IS NULL 
OR Population IS NULL
OR Estimated_Rent IS NULL
OR City_Rank IS NULL;

DELETE FROM City
WHERE  City_ID IS NULL
OR City_Name IS NULL 
OR Population IS NULL
OR Estimated_Rent IS NULL
OR City_Rank IS NULL;

---Identify the Duplicates----

Select Customers_ID, Customer_Name, City_ID, Count(*) as Count
from Customers
Group by Customers_ID, Customer_Name, City_ID
Having Count(*)> 1
;

-----How to find the mismatch between total amount and price * Quantity----

select sale_id, total_amount, (products.price * sales.quantity) calculated_total 
from sales 
join products on sales.product_id=products.product_id
where sales.total_amount != (products.price* sales.quantity);

-----Actitvity 3 -- ---

Select
s.Sale_ID,
s.Sale_Date,
s.Quantity,
c.Customer_Name,
p.Product_Name,
p.Price,
(p.Price * s.Quantity) As Total_Amount
From Sales s
Join Customers c on c.Customers_ID = s.Customers_ID
Join Products p on p. Product_ID = s.Product_ID
Order by s.Sale_Date Desc
;

-----------Activity 4 -------
1----Total Sales per city-----

Select  Ci.City_ID, Ci.City_Name, sum(P.price * S.Quantity) as Total_Sales
From Sales s
join Products p on S.product_ID = s.product_ID
Join customers c on s.customers_ID = c.Customers_ID
Join City ci on C.City_ID = Ci.City_ID
Group by Ci.City_ID;

2-----how many total transactions occurred per city?-------

SELECT ci.city_name, Sum(s.Quantity * P.price) as Total_Transactions
FROM sales s
JOIN customers c ON s.customers_id = c.customers_id
JOIN city ci ON c.city_id = ci.city_id
JOIN products p on p.product_ID = s.Product_ID
GROUP BY ci. city_Name
ORDER BY Total_Transactions Desc
;
use monday_coffee;
------- How many unique customers are there in each city?------

SELECT ci.city_name, COUNT(DISTINCT c.customers_id) AS unique_customers
FROM customers c
JOIN city ci ON c.city_id = ci.city_id
GROUP BY ci.city_name
;

----What is the average order value per city------

Select ci.City_Name, Avg(P.Price * S.Quantity) as Avg_Order_Value
From Sales s
Join Products p on s.product_ID = p.Product_ID
Join Customers c on C.Customers_ID = s.Customers_Id
Join City ci on C.City_ID = Ci.City_ID
Group by ci.City_Name;


----What is the demand for each product in different cities-----

Select 
City_Name,
Product_Name,
Sum(s.Quantity) as Total_Demand
From Sales s
JOIN 
    products p ON s.product_id = p.product_id
JOIN 
    customers c ON s.customers_id = c.customers_id
JOIN 
    city ci ON c.city_id = ci.city_id
GROUP BY 
    ci.city_name, p.product_name
ORDER BY 
    ci.city_name, total_demand DESC
    ;
    
-------What is the monthly sales trend-----

SELECT 
YEAR(s.sale_date) AS year,
MONTH(s.sale_date) AS month,
SUM(s.quantity * p.price) AS total_sales
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY YEAR(s.sale_date), MONTH(s.sale_date)
ORDER BY year, month
;

-----What is the average product rating per city based on customer purchases?-----

Select 
City_name, 
Avg(Rating) as Average_Rating
from Sales s
JOIN  products p ON s.product_id = p.product_id
JOIN customers c ON s.customers_id = c.customers_id
JOIN city ci ON c.city_id = ci.city_id
GROUP BY ci.city_name
ORDER BY average_rating DESC
;

--------Activity 5-------

SELECT 
    ci.city_name,
    SUM(s.quantity * p.price) AS total_sales,
    COUNT(DISTINCT s.customers_id) AS unique_customers,
    COUNT(s.sale_id) AS order_count
FROM 
    sales s
    JOIN Products p on P.Product_ID = s.PRoduct_ID
JOIN 
    customers c ON s.customers_id = c.customers_id
JOIN 
    city ci ON c.city_id = ci.city_id
GROUP BY 
    ci.city_name
ORDER BY 
    total_sales DESC,
    unique_customers DESC,
    order_count DESC
LIMIT 3;

##Based on sales the top three citites to expand monday coffee are pune, chennai and bangalore.

