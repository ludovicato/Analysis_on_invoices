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


--number of invoices per blacksmith in each region 
SELECT DISTINCT region, ROUND(SUM(invoice_amount)/COUNT(DISTINCT blacksmith_id)) AS invoices
FROM blacksmiths_in_westeros
GROUP BY region
ORDER BY invoices DESC;


--average invoice amount per blacksmith for each region
SELECT region, ROUND(AVG(invoice_amount)) AS avg_invoice_amount_per_blacksmith
FROM blacksmiths_in_westeros
GROUP BY region
ORDER BY avg_invoice_amount_per_blacksmith DESC;


--Check total number of invoices by city
SELECT city, count(*)
FROM blacksmiths_in_westeros
GROUP BY city
ORDER BY count DESC;


--Check total invoice amount by region
SELECT DISTINCT region, ROUND(SUM(invoice_amount)/1000000) || ' M' AS round_amount
FROM blacksmiths_in_westeros
GROUP BY region
ORDER BY round_amount DESC;


--average number of invoices by blacksmiths for each region
SELECT DISTINCT region, COUNT(*)/COUNT(DISTINCT blacksmith_id) AS invoices_by_blacksmith
FROM blacksmiths_in_westeros
GROUP BY region
ORDER BY invoices_by_blacksmith DESC;

--same as above, but with different method
SELECT DISTINCT region, ROUND(AVG(COUNT(invoice_id)) OVER (PARTITION BY region)) AS avg_invoices_by_blacksmith
FROM blacksmiths_in_westeros
GROUP BY blacksmith_id, region
ORDER BY avg_invoices_by_blacksmith DESC;


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


--Top 10 suppliers by total invoice and their corresponding number of distinct regions
WITH top_ten_suppliers AS (
	SELECT DISTINCT supplier, SUM(invoice_amount) AS total_invoice
	FROM blacksmiths_in_westeros
	GROUP BY supplier
	ORDER BY total_invoice DESC
	LIMIT 10
),
number_of_regions AS (
	SELECT supplier, COUNT(DISTINCT region) AS regions
	FROM blacksmiths_in_westeros
	GROUP BY supplier
)
SELECT DISTINCT t.supplier, n.regions
FROM blacksmiths_in_westeros AS b
JOIN top_ten_suppliers AS t 
ON b.supplier = t.supplier
JOIN number_of_regions AS n
ON b.supplier = n.supplier
ORDER BY n.regions DESC;


--average invoice amount for each supplier
SELECT supplier, ROUND(AVG(invoice_amount),2) as invoice_amount_medio
FROM blacksmiths_in_westeros
GROUP BY supplier
ORDER BY invoice_amount_medio DESC;


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


--Counting how many suppliers supply a set number of regions (in this case 1)
SELECT COUNT(supplier) AS suppliers
FROM
	(SELECT supplier, COUNT(DISTINCT region) as regions
	FROM blacksmiths_in_westeros
	GROUP BY supplier) AS reg
WHERE regions = 1
GROUP BY regions
ORDER BY regions DESC;


--Number of unique suppliers who supply each region in Westeros, but only for regions that are supplied by a single supplier.
WITH regions_per_supplier AS (
	SELECT supplier, COUNT(DISTINCT region) AS num_regions
	FROM blacksmiths_in_westeros
	GROUP BY supplier
)
SELECT region, COUNT(DISTINCT b.supplier) AS num_fornitori
FROM blacksmiths_in_westeros AS b
JOIN regions_per_supplier AS r 
ON b.supplier = r.supplier
WHERE num_regions = 1
GROUP BY region
ORDER BY num_fornitori DESC;


--Top 10 suppliers by number of invoices with details on total amount
SELECT supplier, ROUND(SUM(invoice_amount),2) as total, COUNT(invoice_id) AS number_invoices, COUNT(DISTINCT region) AS regions
FROM blacksmiths_in_westeros
GROUP BY supplier
ORDER BY number_invoices DESC
LIMIT 10;


--number of distinct regions that the top 10 suppliers work with
WITH amount_per_supplier AS (
	SELECT DISTINCT supplier, SUM(invoice_amount)
	FROM blacksmiths_in_westeros
	GROUP BY supplier
	ORDER BY SUM(invoice_amount) DESC
	LIMIT 10
)
SELECT DISTINCT a.supplier, COUNT(DISTINCT region)
FROM blacksmiths_in_westeros AS b
JOIN amount_per_supplier AS a 
ON b.supplier = a.supplier
GROUP BY a.supplier
ORDER BY count DESC; 


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


--Join with regions database to generate locations for regional number of invoices and regional total amount
SELECT DISTINCT b.region, COUNT(b.invoice_id) AS number_invoices, SUM(b.invoice_amount) as total_amount, r.latitude, r.longitude
FROM blacksmiths_in_westeros AS b
INNER JOIN regions AS r
ON b.region = r.region
GROUP BY b.region, latitude, longitude;


--Relationshiop between population and number of invoices in each region
SELECT b.region, COUNT(b.invoice_id::numeric) AS total_invoice_id, r.population, ROUND(COUNT(b.invoice_id::numeric) / (r.population::numeric),2) AS invoice_id_per_person
FROM blacksmiths_in_westeros AS b
INNER JOIN regions AS r
ON b.region = r.region
GROUP BY b.region, r.population
ORDER BY invoice_id_per_person DESC;


--Relationshiop between population and total amount in each region
SELECT DISTINCT b.region, ROUND(SUM(b.invoice_amount::numeric), 2) AS total_invoice_id, r.population, ROUND(SUM(b.invoice_amount::numeric) / (r.population::numeric),2) AS invoice_amount_per_person 
FROM blacksmiths_in_westeros AS b
INNER JOIN regions AS r
ON b.region = r.region
GROUP BY b.region, r.population
ORDER BY invoice_amount_per_person DESC;


--identify the top suppliers by total invoice value that have sold their products in 1 region, while also including their ranking by invoice amount
WITH ranked_data AS (
	SELECT 
		supplier, 
		ROUND(SUM(invoice_amount)) AS total_amount, 
		COUNT(DISTINCT region) AS regions,
		row_number() OVER (ORDER BY SUM(invoice_amount) DESC) AS ranking
	FROM blacksmiths_in_westeros
	GROUP BY supplier
)
SELECT supplier, total_amount, ranking
FROM ranked_data
WHERE regions = 1
ORDER BY ranking;

