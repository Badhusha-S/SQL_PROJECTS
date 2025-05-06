WITH stock_with_date_parts AS (
  SELECT 
    ticker,
    date,
    EXTRACT(MONTH FROM date) AS month,
    EXTRACT(YEAR FROM date) AS year,
    CAST(open AS NUMERIC) AS open_price,
    CAST(close AS NUMERIC) AS close_price
  FROM stock_data
),
first_last AS (
  SELECT 
    ticker,
    month,
    year,
    ROUND(FIRST_VALUE(open_price) OVER (
      PARTITION BY ticker, year, month
      ORDER BY date
    ), 2) AS first_open,
    ROUND(LAST_VALUE(close_price) OVER (
      PARTITION BY ticker, year, month
      ORDER BY date
      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ), 2) AS last_close
  FROM stock_with_date_parts
),
monthly_returns AS (
  SELECT 
    DISTINCT ticker,
    month,
    year,
    first_open,
    last_close,
    ROUND(((last_close - first_open) / first_open) * 100, 2) AS monthly_ret,
    RANK() OVER (
      PARTITION BY year, month 
      ORDER BY ((last_close - first_open) / first_open) DESC
    ) AS rank_data
  FROM first_last
)
SELECT *
FROM monthly_returns
WHERE rank_data = 1
ORDER BY year, month;


