
WITH daily_returns AS (
SELECT ticker,
EXTRACT(MONTH FROM date) AS MONTH,
EXTRACT (YEAR FROM date) AS YEAR,
( CAST(CLOSE AS numeric)- cast(OPEN AS numeric)/ cast(OPEN AS numeric)) AS daily_return
FROM stock_data
), 
monthly_volitility AS (
SELECT ticker,MONTH,YEAR,
round(stddev(daily_return),2) AS volatility
FROM daily_returns 
GROUP BY MONTH,YEAR,ticker)

SELECT * FROM monthly_volitility 
ORDER BY MONTH,YEAR,ticker