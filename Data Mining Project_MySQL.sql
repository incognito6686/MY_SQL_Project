SELECT * FROM project.`online retail`;

RENAME TABLE `project`.`online retail` TO `project`.`data`;

use data;


-- Q1) Define meta data
describe data;


-- Q2) What is the distribution of order values across all customers in the dataset?
SELECT CustomerID, SUM(Quantity * UnitPrice) AS OrderValue
FROM data
GROUP BY CustomerID
ORDER BY OrderValue DESC;



-- Q3) How many unique products has each customer purchased?
SELECT CustomerID, COUNT(DISTINCT StockCode) AS UniqueProducts
FROM data
GROUP BY CustomerID;


-- Q4) Which customers have only made a single purchase from the company?
SELECT CustomerID
FROM data
GROUP BY CustomerID
HAVING COUNT(DISTINCT InvoiceNo) = 1;


-- Q5) Which products are most commonly purchased together by customers in the dataset?
SELECT a.StockCode AS Product1, b.StockCode AS Product2, COUNT(*) AS PurchaseCount
FROM data a
JOIN data b ON a.InvoiceNo = b.InvoiceNo AND a.StockCode < b.StockCode
GROUP BY Product1, Product2
ORDER BY PurchaseCount DESC
LIMIT 10; 

-- Q6)  Group customers into segments based on their purchase frequency, such as high, medium, and low frequency customers. 
-- This can help you identify your most loyal customers and those who need more attention.
SELECT CustomerID,
    CASE
        WHEN COUNT(DISTINCT InvoiceDate) > 10 THEN 'High'
        WHEN COUNT(DISTINCT InvoiceDate) > 5 THEN 'Medium'
        ELSE 'Low'
    END AS PurchaseFrequency
FROM data
GROUP BY CustomerID;


-- Q7) Calculate the average order value for each country to identify where your most valuable customers are located.
SELECT Country, AVG(Quantity * UnitPrice) AS AvgOrderValue
FROM data
GROUP BY Country
ORDER BY AvgOrderValue DESC;


-- Q8) Identify customers who haven't made a purchase in a specific period (e.g., last 6 months) to assess churn.
SELECT CustomerID
FROM data
WHERE InvoiceDate < DATE_SUB(NOW(), INTERVAL 6 MONTH)
GROUP BY CustomerID;


-- Q9) Determine which products are often purchased together by calculating the correlation between product purchases
SELECT
    a.StockCode AS product1,
    b.StockCode AS product2,
    COUNT(*) AS purchase_count,
    COUNT(*) / (SELECT COUNT(DISTINCT InvoiceNo) FROM data) AS correlation
FROM data a
JOIN data b ON a.InvoiceNo = b.InvoiceNo AND a.StockCode < b.StockCode
GROUP BY product1, product2
HAVING purchase_count >= 10
ORDER BY correlation DESC, purchase_count DESC;


-- Q10)   Explore trends in customer behavior over time, such as monthly or quarterly sales patterns.
SELECT
    DATE_FORMAT(InvoiceDate, '%Y-%m') AS month,
    SUM(Quantity * UnitPrice) AS total_sales
FROM data
GROUP BY month
ORDER BY month;