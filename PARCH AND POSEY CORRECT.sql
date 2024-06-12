select *
from accounts
---Retrieve data from the accounts table and display the names,websites and sales reps of all our customers at parch and posey 
SELECT name,website,sales_rep_id
FROM accounts

----Retrieve the orderid and the quantity ordered of only standard paper
SELECT o.id,standard_qty
FROM orders o

----identify the top 10 total orders by quantity
SELECT total
FROM orders
ORDER BY total desc
LIMIT 10

----Identify large total orders that are greater than 2000 pieces
SELECT total
FROM orders
WHERE total >2000
ORDER BY total desc
LIMIT 70

-----Idetify the highest total single order by count, made by a company
SELECT total,COUNT (TOTAL)
FROM  orders
GROUP BY total
ORDER BY  count desc

----Identify the top 3 total single order by amount paid,made by company
SELECT total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC
LIMIT 3

---Retrieve the list of orders where the total ordered quantity is greater than 2000 and the total price is greater 50000,sorted by the orders id,in ascending order
SELECT orders.id 
FROM orders
WHERE total >2000 AND total_amt_usd >50000
GROUP BY orders.id
ORDER BY orders.id ASC

----Retrieve the top 10 orders of poster paper by amount spent and the respectives names of companies that placed the order.
SELECT name,poster_amt_usd
FROM accounts a
JOIN orders o
ON a.id = o.id
GROUP BY poster_amt_usd,name
ORDER BY poster_amt_usd desc
LIMIT 10

----Retrieve the account names for all customers, the names of theirs sales rep and the region names of their respective sales reps
SELECT a.name,s.name,r.name
FROM accounts a
JOIN sales_reps s
ON a.sales_rep_id = s.id
JOIN region r
ON s.region_id =r.id
GROUP BY a.name,s.name,r.name

----What type of paper has the highest order?
SELECT SUM(gloss_qty) as Gloss_Paper_Order ,
  SUM(poster_qty) as Poster_Paper_Order, 
  SUM(standard_qty) as Standard_Paper_Order
FROM orders

----when did the highest sales occur and why?
SELECT total_amt_usd,occurred_at
FROM orders
ORDER BY total_amt_usd DESC
LIMIT 1

----Via what channel did the most recent (latest) web_event occur, which account was associated with this web_event? 
SELECT occurred_at, channel, name AS account_name
FROM web_events
JOIN accounts
ON accounts.id = web_events.account_id
ORDER BY occurred_at DESC
LIMIT 1

----For each account, determine the average amount of each type of paper they purchased across their orders? 
SELECT accounts.name AS account_name, AVG(standard_qty) AS avg_standard_qty,AVG(gloss_qty) AS avg_gloss_qty,AVG(poster_qty) AS avg_poster_qty
FROM orders
JOIN accounts 
ON accounts.id = orders.account_id
GROUP BY accounts.id, accounts.name
ORDER BY account_name

---- What paper type generated the highest revenue?
SELECT total_amt_usd, poster_qty,standard_qty, gloss_qty
FROM orders
ORDER BY total_amt_usd DESC
LIMIT 1

SELECT SUM(poster_amt_usd) As poster_paper_revenue,
SUM(standard_amt_usd) AS standard_paper_revenue, 
SUM(gloss_amt_usd) AS gloss_paper_revenue
FROM orders

----Which company name had the highest order?
SELECT accounts.name AS Company_name, COUNT(total) AS total_orders
fROM accounts
JOIN orders
ON accounts.id = orders.account_id
GROUP BY accounts.name
ORDER BY total_orders desc
LIMIT 1

---- From what region was the highest sales generated from
SELECT  r.name AS region_name, SUM(o.total_amt_usd) AS total_sales
fROM region r
JOIN sales_reps sr ON r.id = sr.region_id
JOIN accounts a ON sr.id = a.sales_rep_id
JOIN orders o ON a.id = o.account_id
GROUP BY r.name
ORDER BY total_sales desc
LIMIT 1

---- Total number of accounts managed by each sales reps and use this to determine high flying sales reps based on total amount of orders handled?
SELECT sales_reps.id, sales_reps.name AS sales_reps_name, COUNT(*) number_of_accounts
FROM accounts
JOIN sales_reps ON sales_reps.id = accounts.sales_rep_id
GROUP BY 1,2
ORDER BY number_of_accounts


SELECT sales_reps.id, sales_reps.name AS sales_reps_name, COUNT(*) number_of_accounts, SUM(total) AS total_orders
FROM accounts
JOIN sales_reps ON sales_reps.id = accounts.sales_rep_id
JOIN orders ON accounts.id = orders.account_id
GROUP BY 1,2
ORDER BY  number_of_accounts

-----Which month and year did Parch and posey have the highest sales in terms of total orders?
SELECT DATE_PART('month',occurred_at) AS sales_month , COUNT(*) AS total_number_of_orders
FROM orders
GROUP BY 1
ORDER BY 2 DESC

SELECT DATE_PART('year',occurred_at) AS sales_year , COUNT(*) AS total_number_of_orders
FROM orders
GROUP BY 1
ORDER BY 2 DESC

---- Which of the parch and posey papers  had the highest sales in the Northeast region? 
SELECT r.name as region_name, sum (o.standard_amt_usd) as standard_total_sales, sum(o.gloss_amt_usd) as gloss_total_sales, sum(o.poster_amt_usd) as poster_total_sales
from region r
join sales_reps sr on r.id = sr.region_id
join accounts a on sr.id = a.sales_rep_id
join orders o on a.id = o.account_id
group by r.name
order by standard_total_sales desc
LIMIT 1

----What region did the gloss qty paper make the highest sales
SELECT r.name as region_name, SUM(o.gloss_amt_usd) as gloss_total_sales
from region r
join sales_reps sr on r.id = sr.region_id
join accounts a on sr.id = a.sales_rep_id
join orders o on a.id = o.account_id
group by r.name
order by gloss_total_sales desc
LIMIT 1

----List the name of the companies that bought over 7000 gloss paper qty
SELECT accounts.name AS account_name, SUM(gloss_qty) AS gloss_paper_qty
FROM accounts
JOIN orders ON accounts.id = orders.account_id
GROUP BY accounts.name
HAVING SUM(gloss_qty) > 7000
ORDER BY gloss_paper_qty

----WHO ARE THE TOP PERFORMING SALES REP BASED ON THE TOTAL SALES AMOUNT IN USD
SELECT sr.id ,
sr.name ,
SUM(o.total_amt_usd) AS total_sales_amountUSD
FROM sales_reps sr
JOIN accounts a
ON sr.id=a.sales_rep_id
JOIN orders o
ON a.id=o.account_id
GROUP BY sr.id,sr.name,o.total_amt_usd
ORDER BY o.total_amt_usd desc

----WHAT IS THE AVERAGE TOTAL SALES AMOUNT PER REGION
SELECT r.id AS regionid,r.name AS regionname,AVG(o.total_amt_usd)
FROM region r
JOIN sales_reps sr
ON r.id=sr.region_id
JOIN accounts a
ON sr.id=a.sales_rep_id
JOIN orders o
ON a.id=o.account_id
GROUP BY r.id,r.name,o.total_amt_usd
ORDER BY o.total_amt_usd DESC

----WHO IS THE PRIMARY POINT OF CONTACT FOR THE ACCOUNT WITH THE HIGEST SALES
SELECT
A.Id AS AID_HighestSales,
A.primary_poc AS POC_HighestSales,
MAX(O.total_amt_usd) AS HighestSalesAmountUSD
FROM
ACCOUNTS A
JOIN
ORDERS O
ON A.Id = O.account_id
WHERE
O.total_amt_usd = (SELECT MAX(total_amt_usd) FROM ORDERS)
GROUP BY
A.Id, A.primary_poc;

----IS THERE A RELATIONSHIP BETWEEN THE POC AND SALES REP
SELECT
A.primary_poc AS PrimaryPointOfContact,
COUNT(DISTINCT A.Id) AS TotalAccounts,
SUM(O.total_amt_usd) AS TotalSalesAmountUSD,
AVG(O.total_amt_usd) AS AverageSalesAmountUSD
FROM
ACCOUNTS A
JOIN
ORDERS O ON A.Id = O.account_id
GROUP BY
A.primary_poc
ORDER BY
TotalSalesAmountUSD DESC;

----- HOW DOES THE PERFORMANCE OF SALES REP VARY ACROSS REGION
SELECT
R.name,
SR.id,
SR.name,
COUNT(o.total_amt_usd) AS TotalSales,
SUM(o.total_amt_usd) AS TotalRevenue
FROM region r
JOIN sales_reps sr
ON r.id=sr.region_id
JOIN accounts a
ON sr.id=a.sales_rep_id
JOIN orders o
ON a.id=o.account_id
GROUP BY
r.name, sr.id, sr.name
ORDER BY
r.name, TotalRevenue DESC;

-----WHICH REGION CONTRIBUTED THE MOST TO THE OVERALL SALES
SELECT
r.name,
SUM(o.total_amt_usd) AS TotalSales
FROM region r
JOIN sales_reps sr
ON r.id=sr.region_id
JOIN accounts a
ON sr.id=a.sales_rep_id
JOIN orders o
ON a.id=o.account_id
GROUP BY
r.Name
ORDER BY
TotalSales DESC
LIMIT 1;

----WHAT IS THE AVERAGE SIZE OF ORDERS IN TERMS OF TOTAL QUANTITY AND TOTAL AMOUNT IN USD
SELECT
AVG(o.total) AS AvgTotalQuantity,
AVG(o.total_amt_usd) AS AvgTotalAmountUSD
FROM
orders o
GROUP BY
o.total,o.total_amt_usd
ORDER BY o.total DESC, o.total_amt_usd DESC

----LIST THE TOP 10 ACCOUNTS THAT CONTRIBUTE SIGNIFICANT TO THE TOTAL SALES
SELECT
a.id,
a.name,
SUM(o.total_amt_usd) AS TotalSales
FROM accounts a
JOIN orders o
ON a.id=o.account_id
GROUP BY
a.id, a.name
ORDER BY
TotalSales DESC
LIMIT 10;

----HOW ARE THE ACCOUNTS DISTRIBUTED GEOGRAPHICALLY BASED ON LAT AND LONG
SELECT
COUNT(a.id) AS NumberOfAccounts,
AVG(a.Lat) AS AvgLatitude,
AVG(a.Long) AS AvgLongitude
FROM
Accounts a;

-----LIST ALL THE ACCOUNTS WITH LOWERS SALES IN ALL REGION
SELECT
a.id,
a.name,
SUM(o.total_amt_usd) AS TotalSales
FROM region r
JOIN sales_reps sr
ON r.id=sr.region_id
JOIN accounts a
ON sr.id=a.sales_rep_id
JOIN orders o
ON a.id=o.account_id
GROUP BY
a.id, a.name,o.total_amt_usd
HAVING
o.total_amt_usd <12000
ORDER BY
TotalSales;