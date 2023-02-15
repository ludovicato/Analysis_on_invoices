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
SELECT DISTINCT(EXTRACT(MONTH FROM invoice_date)) AS month, SUM(invoice_amount), blacksmith_id, region
FROM blacksmiths_in_westeros
GROUP BY blacksmith_id, region, month
ORDER BY sum DESC
LIMIT 10;


--Check monthy invoice amount by region
SELECT DISTINCT(EXTRACT(MONTH FROM invoice_date)) AS month, ROUND(SUM(invoice_amount), 2) AS sum, region
FROM blacksmiths_in_westeros
GROUP BY month, region
ORDER BY region;


--Check total number of invoices by month 
SELECT DISTINCT(EXTRACT(MONTH FROM invoice_date)) AS months, COUNT(*) as activity
FROM blacksmiths_in_westeros
GROUP BY months;


--Check total number of invoices by city
SELECT city, count(*)
FROM blacksmiths_in_westeros
GROUP BY city
ORDER BY count DESC;


--Check total number of blacksmiths in each region
SELECT COUNT(DISTINCT blacksmith_id) AS num, region
FROM blacksmiths_in_westeros
GROUP BY region
ORDER BY num DESC;


--Check total number of blacksmiths in each province
SELECT COUNT(DISTINCT blacksmith_id) AS farm_id, region, province
FROM blacksmiths_in_westeros
GROUP BY region, province
ORDER BY farm_id DESC;

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
SELECT COUNT(DISTINCT(supplier)) AS fornitori
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
SELECT supplier, COUNT(DISTINCT blacksmith_id) as num_farmacie
FROM blacksmiths_in_westeros
GROUP BY supplier
ORDER BY num_farmacie DESC;


--Number of suppliers each blacksmiths has
SELECT blacksmith_id, COUNT(DISTINCT supplier) as num_fornitori
FROM blacksmiths_in_westeros
GROUP BY blacksmith_id
ORDER BY num_fornitori DESC;


--Number of regions each supplier works in
SELECT supplier, COUNT(DISTINCT region) as regioni
FROM blacksmiths_in_westeros
GROUP BY supplier
ORDER BY regioni DESC;


--Distribution of suppliers across different regions of operation
SELECT DISTINCT(regioni) AS num_regioni_fornite, COUNT(supplier) AS forn
FROM
	(SELECT supplier, COUNT(DISTINCT region) as regioni
	FROM blacksmiths_in_westeros
	GROUP BY supplier) AS reg
GROUP BY num_regioni_fornite
ORDER BY num_regioni_fornite DESC;


--Top 10 suppliers by number of invoices with details on total amount
SELECT supplier, ROUND(SUM(invoice_amount),2) as totale_importi, COUNT(invoice_id) AS numero_fatture, COUNT(DISTINCT region) AS regioni
FROM blacksmiths_in_westeros
GROUP BY supplier
ORDER BY numero_fatture DESC
LIMIT 10;




