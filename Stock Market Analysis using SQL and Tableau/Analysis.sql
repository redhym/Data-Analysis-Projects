-- Download historical data from Yahoo Finance of your selected stocks - I picked Apple, Google, Microsoft & Tesla stocks 5 Years data for this project.
-- Create a database and import the CSV files

-- Next, I have added symbol to each table to identify the stock

-- Apple 

ALTER TABLE `Stock Analysis`.aapl
ADD COLUMN symbol VARCHAR(255) FIRST;

UPDATE `Stock Analysis`.aapl 
SET symbol = 'AAPL';

-- Google

ALTER TABLE `Stock Analysis`.goog
ADD COLUMN Symbol VARCHAR(255) FIRST;

UPDATE `Stock Analysis`.goog 
SET symbol = 'GOOG';

-- Microsoft

ALTER TABLE `Stock Analysis`.msft
ADD COLUMN Symbol VARCHAR(255) FIRST;

UPDATE `Stock Analysis`.msft 
SET symbol = 'MSFT';

-- Tesla

ALTER TABLE `Stock Analysis`.tsla
ADD COLUMN Symbol VARCHAR(255) FIRST;

UPDATE `Stock Analysis`.tsla 
SET symbol = 'TSLA';


-- Changing the Date column data type to Date as it was imported as text

UPDATE `Stock Analysis`.aapl SET Date = str_to_date(Date, '%Y-%m-%d');
UPDATE `Stock Analysis`.goog SET Date = str_to_date(Date, '%Y-%m-%d');
UPDATE `Stock Analysis`.msft SET Date = str_to_date(Date, '%Y-%m-%d');
UPDATE `Stock Analysis`.tsla SET Date = str_to_date(Date, '%Y-%m-%d');

-- Let's calculate 10-day and 30- day moving averages for each stock. This is calculated based on the base stock price data. 
-- Moving averages are a common technical analysis tool for analyzing stock trends.

-- Apple

SELECT symbol, Date, close,		
		CASE
			when row_number() over(order by date) > 9
				then SUM(Close) OVER (ORDER BY Date ROWS BETWEEN 9 PRECEDING AND CURRENT ROW)
                END as M10, 
		CASE when row_number() over(order by date) > 29
				then SUM(Close) OVER (ORDER BY Date ROWS BETWEEN 29 PRECEDING AND CURRENT ROW)
                END as M30
 FROM `Stock Analysis`.aapl;
	
-- Google

SELECT symbol, Date, close,		
		CASE
			when row_number() over(order by date) > 9
				then SUM(Close) OVER (ORDER BY Date ROWS BETWEEN 9 PRECEDING AND CURRENT ROW)
                END as M10, 
		CASE when row_number() over(order by date) > 29
				then SUM(Close) OVER (ORDER BY Date ROWS BETWEEN 29 PRECEDING AND CURRENT ROW)
                END as M30
 FROM `Stock Analysis`.goog;      
       	
-- Microsoft

SELECT symbol, Date, close,		
		CASE
			when row_number() over(order by date) > 9
				then SUM(Close) OVER (ORDER BY Date ROWS BETWEEN 9 PRECEDING AND CURRENT ROW)
                END as M10, 
		CASE when row_number() over(order by date) > 29
				then SUM(Close) OVER (ORDER BY Date ROWS BETWEEN 29 PRECEDING AND CURRENT ROW)
                END as M30
 FROM `Stock Analysis`.msft;

-- Tesla

 SELECT symbol, Date, close,		
		CASE
			when row_number() over(order by date) > 9
				then SUM(Close) OVER (ORDER BY Date ROWS BETWEEN 9 PRECEDING AND CURRENT ROW)
                END as M10, 
		CASE when row_number() over(order by date) > 29
				then SUM(Close) OVER (ORDER BY Date ROWS BETWEEN 29 PRECEDING AND CURRENT ROW)
                END as M30
  FROM `Stock Analysis`.tsla;

-- Comparing the average monthly price with a percentage change between months for Apple stock.

WITH temp AS (
SELECT 
      year1, month1, avg_month_price,
      ROUND(LAG(avg_month_price, 1) OVER (ORDER BY year1, month1), 2) pre_avg_month_price
FROM
 ( 
   SELECT YEAR(Date) as year1, MONTH(Date) as month1,
   ROUND(AVG(`Adj Close`), 2) as avg_month_price
   FROM `Stock Analysis`.aapl
   GROUP BY YEAR(Date), MONTH(Date)) t
)
SELECT 
       year1, month1, avg_month_price, pre_avg_month_price,
       CONCAT(ROUND(((avg_month_price - pre_avg_month_price) / pre_avg_month_price * 100), 2), '%') as percentage_change
FROM temp;















