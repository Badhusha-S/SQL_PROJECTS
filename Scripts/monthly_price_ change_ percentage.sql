
WITH first_last AS (
  SELECT 
    ticker,
    extract(MONTH FROM date) AS MONTH,
    EXTRACT(YEAR FROM date) AS YEAR,
    ROUND(FIRST_VALUE(CAST(close AS numeric) )OVER (
      PARTITION BY ticker,  extract(MONTH FROM date) ,
    EXTRACT(YEAR FROM date)
      ORDER BY date
    ), 2) AS first_close,
    ROUND(LAST_VALUE(CAST(CLOSE AS numeric) )OVER (
      PARTITION BY ticker,  extract(MONTH FROM date),
    EXTRACT(YEAR FROM date) 
      ORDER BY date
      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ), 2) AS last_close
  FROM stock_data
),
percentage_returns AS (
  SELECT 
    DISTINCT ticker,
    month,
    year,
    first_close,
    last_close,
    ROUND(((last_close - first_close) / first_close) * 100, 2) AS percentage_ret
  FROM first_last
)
SELECT *
FROM percentage_returns
ORDER BY YEAR,MONTH;


