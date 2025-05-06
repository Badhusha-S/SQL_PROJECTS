sELECT 
ticker, 
date_trunc('month' ,date) AS MONTH,
round(avg( CAST ( CLOSE AS NUMERIC )),2)AS avg_closing_price_per_month
FROM stock_data
GROUP BY ticker, MONTH
ORDER BY  MONTH,ticker;