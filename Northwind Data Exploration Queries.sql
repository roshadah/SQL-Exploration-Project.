
# Project Title

## SQL PROJECT

Data exploration using SQL on the Northwind Datasets.

Introduction

Skills used:  CTEs, Temp Tables, Joins, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types.

Questions to further explore the dataset.

Customer Segmentation: How can we segment customers based on their purchasing behavior, demographics, or geographic location?

Product Performance: Which products are the best-sellers, and are there any seasonal trends or patterns in their sales?

Supplier Evaluation: How reliable are our suppliers regarding delivery times, product quality, and pricing?

Employee Performance: Do employees consistently outperform others in sales or customer service?

Inventory Management: What is the turnover rate for our inventory, and are there any products that are overstocked or understocked?

Order Fulfillment: How efficient is our order fulfillment process, and are there any bottlenecks or delays?

Customer Retention: What is our customer retention rate, and are their any factors influencing customer churn?

Market Analysis: How does our sales performance compare to competitors in different geographic regions or industries?

Marketing Effectiveness: Which marketing channels drive the most sales, and how can we optimize our marketing efforts?

Profitability Analysis: What are our most profitable products, customers, and sales channels, and how can we maximize profitability?

### Customer Segmentation
    
    SELECT 
    CASE 
    WHEN Country = 'USA' THEN 'Domestic'
    ELSE 'International'
    END AS CustomerSegment,
    COUNT(CustomerID) AS CustomerCount
    FROM 
    Customers
    GROUP BY
    CustomerSegment;


### Product Performance:

    SELECT 
    ProductName, 
    SUM(Quantity) AS TotalQuantitySold,
    SUM(UnitPrice * Quantity) AS TotalRevenue
    FROM 
    Products
    JOIN 
    Order_Details ON Products.ProductID =         Order_Details.ProductID
    GROUP BY
    ProductName
    ORDER BY 
    TotalQuantitySold DESC
    LIMIT 10;

### Supplier Evaluation:

    SELECT 
    SupplierID, 
    AVG(UnitPrice) AS AvgUnitPrice,
    AVG(UnitsOnOrder) AS AvgUnitsOnOrder
    FROM 
    Products
    GROUP BY 
    SupplierID; 

### Employee Performance 

    SELECT 
    EmployeeID,COUNT(OrderID) AS TotalOrders,
    SUM(UnitPrice * Quantity) AS TotalSales
    FROM 
    Orders
    JOIN 
    Order_Details ON Orders.OrderID =           Order_Details.OrderID
    GROUP BY 
    EmployeeID
    ORDER BY 
    TotalSales DESC
    LIMIT 10;

    
### Employee Performance

    SELECT 
    EmployeeID, 
    COUNT(OrderID) AS TotalOrders,
    SUM(UnitPrice * Quantity) AS TotalSales
    FROM
    Orders
    JOIN 
    Order_Details ON Orders.OrderID =           Order_Details.OrderID
    GROUP BY 
    EmployeeID
    ORDER BY 
    TotalSales DESC
    LIMIT 10;

### Inventory Management

    SELECT 
    ProductID, 
    AVG((UnitPrice * QuantityPerUnit)::numeric) AS AvgRevenue,
    AVG(UnitsInStock::numeric) AS AvgStock
    FROM 
    Products
    GROUP BY
    ProductID;

### Order Fulfillment:
    SELECT 
    ShipperID, 
    AVG(EXTRACT(EPOCH FROM (ShippedDate -       OrderDate)) / 86400) AS AvgShippingTime

    FROM 
    Orders
    GROUP BY
    ShipperID;

### Customer Retention

    WITH CustomerCountByYear AS 
    (
    SELECT 
    EXTRACT(YEAR FROM OrderDate) AS OrderYear,
    COUNT(DISTINCT CustomerID) 
    AS UniqueCustomers
    FROM 
    Orders
    GROUP BY 
    OrderYear
    )
    SELECT 
    OrderYear,
    UniqueCustomers
    FROM 
    CustomerCountByYear;


### Market Analysis

    WITH RegionSales AS
    (
    SELECT
    c.Region, 
    SUM(o.UnitPrice * o.Quantity) AS TotalSales,
    RANK() OVER (ORDER BY SUM(o.UnitPrice * o.   Quantity) DESC) 
    AS SalesRank
    FROM 
    Orders o
    JOIN 
    Customers c ON o.CustomerID = c.CustomerID
    GROUP BY 
    c.Region)
    SELECT 
    Region, 
    TotalSales,
    SalesRank
    FROM 
    RegionSales;


### Market Effectiveness

    CREATE TEMPORARY TABLE IF NOT EXISTS 
    TempCountryOrders AS (
    SELECT 
    c.Country, 
    COUNT(o.OrderID) AS TotalOrders
    FROM 
    Orders o
    JOIN
    Customers c ON o.CustomerID = c.CustomerID
    GROUP BY
    c.Country);
    SELECT * FROM TempCountryOrders;

### Profitability Analysis
    
    SELECT 
    ProductID, 
    SUM(UnitPrice * Quantity) AS TotalRevenue
    FROM 
    Order_Details
    GROUP BY
    ProductID
    ORDER BY
    TotalRevenue DESC
    LIMIT 10;
