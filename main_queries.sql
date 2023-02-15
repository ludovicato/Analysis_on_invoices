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
SELECT blacksmith_id, blacksmith_name AS name, region, province
FROM blacksmiths_in_westeros
WHERE blacksmith_id IN(
	SELECT blacksmith_id
	FROM blacksmiths_in_westeros
	GROUP BY blacksmith_id
	HAVING COUNT(DISTINCT blacksmith_name) > 1)
GROUP BY name, region, province, blacksmith_id
ORDER BY blacksmith_id;
