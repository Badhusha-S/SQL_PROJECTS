WITH first_last as(
SELECT ticker,
round(first_value( CAST (OPEN AS NUMERIC )) over(PARTITION BY ticker ORDER BY date ),2)AS first_open,
round(LAST_value(CAST (CLOSE AS numeric)) over(PARTITION BY ticker 
ORDER BY date 
 ROWS BETWEEN UNBOUNDED  PRECEDING AND UNBOUNDED FOLLOWING  
), 2) AS last_close FROM stock_data)

SELECT ticker, first_open,last_CLOSE,
round(((last_close - first_open) / first_open) * 100, 2) AS percent_ret
FROM first_last 
GROUP BY ticker,first_open ,last_close 
ORDER BY percent_ret DESC
LIMIT 1;
