
--DATA PREPARATION AND UNDERSTANDING 
Q1.
SELECT COUNT(*) ROW_COUNT FROM CUSTOMER 
UNION ALL
SELECT COUNT(*) FROM prod_cat_info
UNION ALL
SELECT COUNT(*) FROM Transactions

Q2.
SELECT Count(transaction_id) AS TOTAL_RECORDS FROM Transactions WHERE Qty < 0 

Q3.
SELECT TRAN_DATE,
CONVERT( DATE, Tran_date, 103 ) AS Tran_date1
FROM Transactions

alter table Transactions add new_date date
update Transactions set new_date = convert(date,tran_date,105)

Q4.
SELECT 
DATEDIFF(YEAR, MIN(CONVERT(DATE, TRAN_DATE,105)), MAX(CONVERT(DATE, TRAN_DATE,105))) AS YEAR,
DATEDIFF(MONTH, MIN(CONVERT(DATE, TRAN_DATE,105)), MAX(CONVERT(DATE, TRAN_DATE,105))) AS MONTH,
DATEDIFF(DAY, MIN(CONVERT(DATE, TRAN_DATE,105)), MAX(CONVERT(DATE, TRAN_DATE,105))) AS DAY
FROM Transactions

Q5.
SELECT PROD_CAT FROM prod_cat_info
WHERE prod_subcat = 'DIY'



--DATA ANALYSIS\

Q1.
select top 1 store_type,COUNT(store_type) as Count_of_channel
from Transactions
group by Store_type
order by 2 desc;

Q2.
SELECT GENDER, COUNT(GENDER) AS COUNT_OF_GENDER FROM Customer
WHERE GENDER IN ('f', 'M')
group by Gender


Q3.
SELECT TOP 1 city_code, COUNT(city_code) AS COUNT_OF_CUSTOMERS FROM Customer 
group by city_code
ORDER BY COUNT_OF_CUSTOMERS DESC

Q4.
SELECT prod_cat, count(prod_subcat) as [Count of Sub-cat]
FROM prod_cat_info
WHERE prod_cat = 'Books'
group by prod_cat


Q5.
SELECT MAX(QTY) AS	MAX_QUANITTY
FROM Transactions


Q6.
SELECT round((SUM(CAST (TOTAL_AMT AS float))),2) AS TOTAL_REVENUE
FROM Transactions AS T1
left JOIN prod_cat_info AS T2 ON T1.prod_cat_code = T2.prod_cat_code AND T1.prod_subcat_code = T2.prod_sub_cat_code
WHERE prod_cat IN ('ELECTRONICS', 'BOOKS')

Q7.
SELECT COUNT(CUST_ID) AS [TOTAL CUSTOMEERS]  FROM (
SELECT COUNT(CUST_ID) AS COUNT_OF_TRASATION, cust_id FROM Transactions 
WHERE CONVERT(float, total_amt) > 0
GROUP BY CUST_ID
HAVING COUNT(CUST_ID) > 10
) AS TBL1

Q8.
SELECT Store_type, 
SUM(CONVERT(FLOAT, TOTAL_AMT)) AS [TOTAL REVENUE]
FROM Transactions AS T1
left JOIN prod_cat_info AS T2 ON prod_sub_cat_code = prod_subcat_code AND T1.prod_cat_code = T2.prod_cat_code
WHERE prod_cat IN ('Electronics', 'Clothing') AND Store_type = 'Flagship store'
group by Store_type

Q9.
SELECT round(SUM(CONVERT(float, TOTAL_AMT)), 1) AS [TOTAL REVENUE], prod_subcat FROM Customer
INNER JOIN Transactions AS T1 ON cust_id = customer_Id
INNER JOIN prod_cat_info AS T2 ON prod_subcat_code = prod_sub_cat_code AND T1.prod_cat_code = T2.prod_cat_code
WHERE Gender = 'M' AND prod_cat = 'Electronics'
GROUP BY prod_subcat

Q10.
SELECT top 5 prod_subcat,
SUM(CASE WHEN CONVERT(FLOAT, TOTAL_AMT) > 0 THEN 1 ELSE 0 END ) AS 'SALES',
(SUM(CASE WHEN CONVERT(FLOAT, TOTAL_AMT) > 0 THEN 1.0 ELSE 0 END ))/ COUNT(*) *100 AS 'SALES_',
SUM(CASE WHEN CONVERT(FLOAT, TOTAL_AMT) < 0 THEN 1 ELSE 0 END ) AS RETURNS,
SUM(CASE WHEN CONVERT(FLOAT, TOTAL_AMT) > 0 THEN 1.0 ELSE 0 END )/COUNT(*) AS RETURN_
FROM Transactions
left join prod_cat_info on prod_cat_info.prod_cat_code = Transactions.prod_cat_code AND prod_sub_cat_code = prod_subcat_code
group by prod_subcat
order by SALES



11.
SELECT CUSTOMER_ID, DOB, AGE, LAST_30_DAYS, SUM(CONVERT(FLOAT,TOTAL_AMT)) AS REVENUE FROM (
SELECT *,  DATEDIFF(YEAR,CONVERT(date, DOB, 105),(select MAX(tran_date) from Transactions)) AS AGE, 
DATEDIFF(DAY,CONVERT(date, tran_date, 105), (select MAX(tran_date) from Transactions)) AS LAST_30_DAYS
FROM CUSTOMER
INNER JOIN Transactions ON cust_id = customer_Id
WHERE DATEDIFF(YEAR,CONVERT(date, DOB, 105),(select MAX(tran_date) from Transactions)) BETWEEN 25 AND 35
AND  DATEDIFF(DAY,CONVERT(date, tran_date, 105), (select MAX(tran_date) from Transactions)) BETWEEN 1 AND 30
) AS T1
GROUP BY CUSTOMER_ID, AGE, LAST_30_DAYS, DOB
ORDER BY AGE, LAST_30_DAYS


12.
Select TOP 1 PROD_CAT,SUM(CONVERT(float, TOTAL_AMT)) as MAX_RETURN,
DATEADD(MONTH,-3,MAX(CONVERT(DATE,TRAN_DATE,105))) AS LAST_3_MONTH
from Transactions AS T1 LEFT JOIN prod_cat_info AS P1 ON P1.prod_cat_code = T1.prod_cat_code AND prod_sub_cat_code = prod_subcat_code
WHERE Qty < 0  
GROUP BY  PROD_CAT, tran_date
HAVING CONVERT(DATE,TRAN_DATE,105) > = DATEADD(MONTH,-3,MAX(CONVERT(DATE,TRAN_DATE,105)))
ORDER BY  MAX_RETURN 



13.
SELECT TOP 1 * FROM (
SELECT SUM(CONVERT(float, total_amt)) AS [TOTAL SALES],sum(convert(float,QTY)) AS QTY, STORE_TYPE
FROM Transactions
where Qty > 0
GROUP BY STORE_TYPE 
) AS TBL1
ORDER BY [TOTAL SALES] DESC


14.
SELECT AVG(CONVERT(float,TOTAL_AMT)) AS REVENUE, prod_cat, Transactions.prod_cat_code FROM Transactions
INNER JOIN PROD_CAT_INFO ON Transactions.PROD_CAT_CODE = PROD_CAT_INFO.PROD_CAT_CODE AND prod_sub_cat_code = prod_subcat_code
GROUP BY prod_cat,Transactions.prod_cat_code
HAVING AVG(CONVERT(float,TOTAL_AMT)) > (SELECT AVG(CONVERT(FLOAT, TOTAL_AMT)) FROM Transactions)

15.
SELECT TOP 5 AVG (CONVERT(FLOAT,TOTAL_AMT)) AS AVERAGE_REVENUE, 
SUM(CONVERT(FLOAT, total_amt)) AS TOTAL_REVENUE, SUM(CONVERT(FLOAT,QTY)) AS QTY, prod_subcat
from Transactions AS T1 LEFT JOIN prod_cat_info AS P1 ON P1.prod_cat_code = T1.prod_cat_code AND prod_sub_cat_code = prod_subcat_code
GROUP BY prod_subcat
ORDER BY QTY DESC