WITH highest_stock AS (SELECT
ticker,
To_Char(date,'Mon-yyyy') as highest_mth,
Max(open) as highest_open,
Row_Number() OVER(PARTITION BY ticker ORDER BY open DESC) as highest_rnk
FROM stock_prices
GROUP BY ticker, highest_mth,open),

lowest_stock AS (SELECT
ticker,
To_Char(date,'Mon-yyyy') as lowest_mth,
MIN(open) as lowest_open,
Row_Number() OVER(PARTITION BY ticker ORDER BY open ASC) as lowest_rnk
FROM stock_prices
GROUP BY ticker,lowest_mth,open
)

SELECT
high.ticker,
high.highest_mth,
high.highest_open,
low.lowest_mth,
low.lowest_open
FROM highest_stock as high
INNER JOIN lowest_stock as low
ON high.ticker = low.ticker 
AND high.highest_rnk = 1
AND low.lowest_rnk = 1
ORDER BY high.ticker;