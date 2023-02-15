-- Check the amount of invoices for each region
SELECT DISTINCT region, COUNT(*)
FROM blacksmiths_in_westeros
GROUP BY region
ORDER BY count DESC;


--Check the amount of invoices for each province limited in a single region
SELECT DISTINCT region, province, COUNT(*)
FROM blacksmiths_in_westeros
WHERE region = 'The North'
GROUP BY region, province
ORDER BY region, province DESC;


--TOP 10 blacksmiths with largest expences through the entire year
SELECT DISTINCT blacksmith_id, region, province, ROUND(SUM(invoice_amount), 2) AS sum
FROM blacksmiths_in_westeros
GROUP BY blacksmith_id, region, province
ORDER BY sum DESC
LIMIT 10;


--Top 10 blacksmiths with the largest expences in one month
SELECT DISTINCT(EXTRACT(MONTH FROM invoice_date)) AS month, SUM(invoice_amount) AS monthly_amount, blacksmith_id, region
FROM blacksmiths_in_westeros
GROUP BY blacksmith_id, region, month
ORDER BY monthly_amount DESC
LIMIT 10;


--Check monthy invoice amount by region
SELECT DISTINCT(EXTRACT(MONTH FROM invoice_date)) AS month, ROUND(SUM(invoice_amount), 2) AS monthly_amount, region
FROM blacksmiths_in_westeros
GROUP BY month, region
ORDER BY region;


--Check total number of invoices by month 
SELECT DISTINCT(EXTRACT(MONTH FROM invoice_date)) AS months, COUNT(*) as activity
FROM blacksmiths_in_westeros
GROUP BY months;


--Check total number of invoices by region
SELECT region, COUNT(invoice_id) as number_invoices
FROM blacksmiths_in_westeros
GROUP BY region;


--Check total number of invoices by city
SELECT city, count(*)
FROM blacksmiths_in_westeros
GROUP BY city
ORDER BY count DESC;


--Check total invoice amount by region
SELECT region, SUM(invoice_amount) as total_amount
FROM blacksmiths_in_westeros
GROUP BY region
ORDER BY total_amount DESC;


--Check total number of blacksmiths in each region
SELECT COUNT(DISTINCT blacksmith_id) AS num, region
FROM blacksmiths_in_westeros
GROUP BY region
ORDER BY num DESC;


--Check total number of blacksmiths in each province
SELECT COUNT(DISTINCT blacksmith_id) AS blacksmith_id, region, province
FROM blacksmiths_in_westeros
GROUP BY region, province
ORDER BY blacksmith_id DESC;

--Check if number of ID and number of names matches
SELECT COUNT(DISTINCT(blacksmith_id)) AS num_blacksmith_ids, COUNT(DISTINCT(blacksmith_name)) AS num_blacksmith_names
FROM blacksmiths_in_westeros;


--Check out the homonyms 
SELECT blacksmith_id, blacksmith_name AS name, region, province, city
FROM blacksmiths_in_westeros
WHERE blacksmith_name IN(
	SELECT blacksmith_name
	FROM blacksmiths_in_westeros
	GROUP BY blacksmith_name
	HAVING COUNT(DISTINCT blacksmith_id) > 1)
GROUP BY blacksmith_id, name, region, province, city
ORDER BY name;


--Check if there can be more names associated with one id
SELECT blacksmith_id, blacksmith_name AS name, region, province, city
FROM blacksmiths_in_westeros
WHERE blacksmith_name IN(
	SELECT blacksmith_name
	FROM blacksmiths_in_westeros
	GROUP BY blacksmith_name
	HAVING COUNT(DISTINCT blacksmith_id) > 1)
GROUP BY blacksmith_id, name, region, province, city
ORDER BY name;


--Check number of suppliers
SELECT COUNT(DISTINCT(supplier)) AS suppliers
FROM blacksmiths_in_westeros;


--Top 10 suppliers by total invoice amount
SELECT supplier, total_spending || ' millions' AS tot
FROM
	(SELECT supplier, ROUND(SUM(invoice_amount)/1000000, 2) as total_spending
	FROM blacksmiths_in_westeros
	GROUP BY supplier
	ORDER BY total_spending DESC) AS test
LIMIT 10;


--Number of blacksmiths provided by each supplier
SELECT supplier, COUNT(DISTINCT blacksmith_id) as number_blacksmiths
FROM blacksmiths_in_westeros
GROUP BY supplier
ORDER BY number_blacksmiths DESC;


--Number of suppliers each blacksmiths has
SELECT blacksmith_id, COUNT(DISTINCT supplier) as number_suppliers
FROM blacksmiths_in_westeros
GROUP BY blacksmith_id
ORDER BY number_suppliers DESC;


--Number of regions each supplier works in
SELECT supplier, COUNT(DISTINCT region) as regions
FROM blacksmiths_in_westeros
GROUP BY supplier
ORDER BY regions DESC;


--Distribution of suppliers across different regions of operation
SELECT DISTINCT(regioni) AS number_regions, COUNT(supplier) AS number_suppliers
FROM
	(SELECT supplier, COUNT(DISTINCT region) as regions
	FROM blacksmiths_in_westeros
	GROUP BY supplier) AS reg
GROUP BY number_regions
ORDER BY number_regions DESC;


--Top 10 suppliers by number of invoices with details on total amount
SELECT supplier, ROUND(SUM(invoice_amount),2) as total, COUNT(invoice_id) AS number_invoices, COUNT(DISTINCT region) AS regions
FROM blacksmiths_in_westeros
GROUP BY supplier
ORDER BY number_invoices DESC
LIMIT 10;


--Distribution of total imports through time
SELECT invoice_date, ROUND(AVG(invoice_amount),2) as avg_invoice_amount
FROM blacksmiths_in_westeros
GROUP BY invoice_date
ORDER BY invoice_date ASC;


--Distribution of the number of invoices through time
SELECT date_trunc('month', invoice_date) as month, COUNT(invoice_id) as number_invoices
FROM blacksmiths_in_westeros
GROUP BY month
ORDER BY month;


--Average invoice amount by supplier through time
SELECT supplier, invoice_date, COUNT(invoice_id) as number_invoices, ROUND(AVG(invoice_amount),2) as avg_invoice_amount
FROM blacksmiths_in_westeros
GROUP BY supplier, invoice_date
ORDER BY supplier, invoice_date ASC;

