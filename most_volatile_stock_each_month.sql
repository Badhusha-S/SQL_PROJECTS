
WITH monthly_volatility AS (
SELECT ticker,
extract( MONTH FROM date) AS MONTH,
EXTRACT ( YEAR FROM date ) AS YEAR,
round(stddev(CAST (CLOSE AS numeric)),2) AS volatility
FROM stock_data
GROUP BY ticker,MONTH,YEAR
)

SELECT ticker, MONTH , YEAR , volatility
FROM (
SELECT *,
rank() OVER ( PARTITION BY MONTH,YEAR ORDER BY volatility desc)
FROM monthly_volatility 
) AS rank_data
WHERE RANK = 1;
