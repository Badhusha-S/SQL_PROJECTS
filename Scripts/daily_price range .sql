SELECT ticker,date,high,low, 
round(CAST (high - low AS NUMERIC) , 2) AS price_range FROM stock_data
