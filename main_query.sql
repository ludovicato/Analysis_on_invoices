--ANALISI CONOSCITIVA

--Check if number of ID and number of names matches
SELECT COUNT(DISTINCT(blacksmith_id)) AS num_blacksmith_ids, COUNT(DISTINCT(blacksmith_name)) AS num_blacksmith_names
FROM blacksmiths_in_westeros;

--Follow up -> It doesn't because some blacksmiths share the same name but are in different locations and therefore have different id
--Check on one specific blacksmith's name with two different id
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









--18 Spesa mensile divisa per region
SELECT DISTINCT(EXTRACT(MONTH FROM invoice_date)) AS month, ROUND(SUM(invoice_amount), 2) AS sum, region
FROM blacksmiths_in_westeros
GROUP BY month, region
ORDER BY region;


--19 Numero di fatture mensili, senza distinzione di region
SELECT DISTINCT(EXTRACT(MONTH FROM invoice_date)) AS months, COUNT(*) as activity
FROM blacksmiths_in_westeros
GROUP BY months;


--20 Numero di diverse farmacie per region
SELECT COUNT(DISTINCT blacksmith_id) AS num, region
FROM blacksmiths_in_westeros
GROUP BY region
ORDER BY num DESC;


--21 Numero di diverse farmacie per province
SELECT COUNT(DISTINCT blacksmith_id) AS farm_id, region, province
FROM blacksmiths_in_westeros
GROUP BY region, province
ORDER BY farm_id DESC;


--22 Lista Farmacie omonime con diversi ID 
SELECT blacksmith_id, blacksmith_name AS name, region, province, city
FROM blacksmiths_in_westeros
WHERE blacksmith_name IN(
	SELECT blacksmith_name
	FROM blacksmiths_in_westeros
	GROUP BY blacksmith_name
	HAVING COUNT(DISTINCT blacksmith_id) > 1)
GROUP BY blacksmith_id, name, region, province, city
ORDER BY name;


--23 Totale Fatture by city
SELECT city, count(city)
FROM blacksmiths_in_westeros
GROUP BY city
ORDER BY count DESC;


--ANALISI DEI FORNITORI

--24 Totale fornitori
SELECT COUNT(DISTINCT(supplier)) AS fornitori
FROM blacksmiths_in_westeros;


--25 Top 10 fornitori per totale spesa
SELECT supplier, total_spending || ' millions' AS tot
FROM
	(SELECT supplier, ROUND(SUM(invoice_amount)/1000000, 2) as total_spending
	FROM blacksmiths_in_westeros
	GROUP BY supplier
	ORDER BY total_spending DESC) AS test
LIMIT 10;


--26 Numero di farmacie che ogni supplier gestisce
SELECT supplier, COUNT(DISTINCT blacksmith_id) as num_farmacie
FROM blacksmiths_in_westeros
GROUP BY supplier
ORDER BY num_farmacie DESC;


--27 Numero di fornitori da cui ogni farmacia si serve
SELECT blacksmith_id, COUNT(DISTINCT supplier) as num_fornitori
FROM blacksmiths_in_westeros
GROUP BY blacksmith_id
ORDER BY num_fornitori DESC;


--28 Numero di regioni che ogni supplier gestisce
SELECT supplier, COUNT(DISTINCT region) as regioni
FROM blacksmiths_in_westeros
GROUP BY supplier
ORDER BY regioni DESC;


--29 Quanti fornitori forniscono quante regioni
SELECT DISTINCT(regioni) AS num_regioni_fornite, COUNT(supplier) AS forn
FROM
	(SELECT supplier, COUNT(DISTINCT region) as regioni
	FROM blacksmiths_in_westeros
	GROUP BY supplier) AS reg
GROUP BY num_regioni_fornite
ORDER BY num_regioni_fornite DESC;


--30 Totale degli importi fatturati e il supplier che ha emesso il maggior numero di fatture
SELECT supplier, ROUND(SUM(invoice_amount),2) as totale_importi, COUNT(invoice_id) AS numero_fatture, COUNT(DISTINCT region) AS regioni
FROM blacksmiths_in_westeros
GROUP BY supplier
ORDER BY numero_fatture DESC
LIMIT 10;

--31 Numero di farmacie per region
SELECT region, COUNT(blacksmith_id) as numero_farmacie
FROM blacksmiths_in_westeros
GROUP BY region
ORDER BY numero_farmacie DESC;

--32  trend degli importi fatturati nel tempo
SELECT invoice_date, ROUND(AVG(invoice_amount),2) as invoice_amount_medio
FROM blacksmiths_in_westeros
GROUP BY invoice_date
ORDER BY invoice_date ASC;

--33 trend fatture per supplier
SELECT supplier, invoice_date, COUNT(invoice_id) as numero_fatture, ROUND(AVG(invoice_amount),2) as invoice_amount_medio
FROM blacksmiths_in_westeros
GROUP BY supplier, invoice_date
ORDER BY supplier, invoice_date ASC;

--34 numero fatture per region
SELECT region, COUNT(invoice_id) as numero_fatture
FROM blacksmiths_in_westeros
GROUP BY region;

--35 relazione tra il supplier e l'invoice_amount delle fatture
SELECT supplier, ROUND(AVG(invoice_amount),2) as invoice_amount_medio
FROM blacksmiths_in_westeros
GROUP BY supplier
ORDER BY invoice_amount_medio DESC;

--36 fornitori più frequenti
SELECT supplier, COUNT(invoice_id) as numero_fatture
FROM blacksmiths_in_westeros
GROUP BY supplier
ORDER BY numero_fatture DESC
LIMIT 5;

--37 Analisi dei totali per region
SELECT region, SUM(invoice_amount) as totale_importi
FROM blacksmiths_in_westeros
GROUP BY region
ORDER BY totale_importi DESC;

--38 Analisi dei fornitori più costosi per region
SELECT region, supplier, SUM(invoice_amount) as totale_importi
FROM blacksmiths_in_westeros
GROUP BY region, supplier
ORDER BY totale_importi DESC
LIMIT 5;

--39 Analisi della distribuzione delle fatture nel tempo
SELECT date_trunc('month', invoice_date) as mese, COUNT(invoice_id) as numero_fatture
FROM blacksmiths_in_westeros
GROUP BY mese
ORDER BY mese;

--40 Totale fatture e totale importi per region con coordinate
SELECT DISTINCT fat.province, COUNT(*) AS num_fatture, SUM(invoice_amount) as totale_importi, latitudine, longitudine
FROM blacksmiths_in_westeros
INNER JOIN geo
ON fat.province = geo.province
GROUP BY fat.province, latitudine, longitudine;

--41 city, num fatture, sum invoice_amount, location and population
SELECT DISTINCT fat.city, COUNT(invoice_id) AS num_fatture, ROUND(SUM(invoice_amount),2) AS invoice_amount, lat, lng, population
FROM blacksmiths_in_westeros
LEFT JOIN it
ON fat.city = it.city
WHERE city IS NOT NULL
GROUP BY fat.city, lat, lng, population, population_proper
ORDER BY num_fatture DESC;

--42 relazione tra popolazione e numero fatture
SELECT it.city, COUNT(fat.invoice_id::numeric) AS total_invoice_id, it.population, ROUND(COUNT(fat.invoice_id::numeric) / (it.population::numeric),2) AS invoice_id_per_person, lat, lng
FROM blacksmiths_in_westeros
JOIN it ON fat.city = it.city
GROUP BY it.city, it.population, lat, lng
ORDER BY invoice_id_per_person DESC;

--43 relazione tra popolazione e invoice_amount
SELECT DISTINCT fat.region, ROUND(SUM(fat.invoice_amount::numeric), 2) AS total_invoice_id, it.population, ROUND(SUM(fat.invoice_amount::numeric) / (it.population::numeric),2) AS invoice_amount_per_person
FROM blacksmiths_in_westeros
JOIN it ON fat.city = it.city
GROUP BY fat.region, it.population
ORDER BY invoice_amount_per_person DESC;

--44 spesa totale annua delle farmacie per region
SELECT DISTINCT region, ROUND(SUM(invoice_amount)/1000000) || ' M' AS round
FROM blacksmiths_in_westeros
GROUP BY region
ORDER BY round DESC;

--45 average number of fatture by pharmacy for each region
SELECT DISTINCT fat.region, COUNT(*)/COUNT(DISTINCT blacksmith_id) AS num_fatture
FROM blacksmiths_in_westeros
GROUP BY fat.region
ORDER BY num_fatture DESC;

SELECT DISTINCT fat.region, AVG(COUNT(fat.invoice_id)) OVER (PARTITION BY fat.region) AS avg_fatture_per_pharmacy
FROM blacksmiths_in_westeros
GROUP BY fat.blacksmith_id, fat.region
ORDER BY avg_fatture_per_pharmacy DESC;

--46
SELECT DISTINCT fat.region, ROUND(SUM(invoice_amount)/COUNT(DISTINCT blacksmith_id)) AS num_fatture
FROM blacksmiths_in_westeros
GROUP BY fat.region
ORDER BY num_fatture DESC;

SELECT DISTINCT fat.region, ROUND(AVG(SUM(fat.invoice_amount)) OVER (PARTITION BY fat.region)) AS avg_invoice_amount_per_pharmacy
FROM blacksmiths_in_westeros
GROUP BY fat.region
ORDER BY avg_invoice_amount_per_pharmacy DESC;

SELECT ROUND(SUM(invoice_amount))
FROM blacksmiths_in_westeros;



--
SELECT DISTINCT(regioni) AS num_regioni_fornite, COUNT(supplier) AS forn
FROM
	(SELECT supplier, COUNT(DISTINCT region) as regioni
	FROM blacksmiths_in_westeros
	GROUP BY supplier) AS reg
WHERE num_regioni_fornite = '1'
GROUP BY num_regioni_fornite
ORDER BY num_regioni_fornite DESC;


SELECT DISTINCT regioni AS num_regioni_fornite, COUNT(supplier) AS forn
FROM
	(SELECT supplier, COUNT(DISTINCT region) as regioni
	FROM blacksmiths_in_westeros
	GROUP BY supplier) AS reg
WHERE regioni = 1
GROUP BY regioni
ORDER BY regioni DESC;

SELECT region, COUNT(DISTINCT supplier) AS num_fornitori
FROM blacksmiths_in_westeros
GROUP BY region
ORDER BY num_fornitori DESC;


WITH reg AS (
	SELECT supplier, COUNT(DISTINCT region) AS num_regioni
	FROM blacksmiths_in_westeros
	GROUP BY supplier
)
SELECT region, COUNT(DISTINCT fat.supplier) AS num_fornitori
FROM blacksmiths_in_westeros
JOIN reg ON fat.supplier = reg.supplier
WHERE num_regioni = 19
GROUP BY region
ORDER BY num_fornitori DESC;



WITH test AS (
	SELECT DISTINCT supplier, SUM(invoice_amount)
	FROM blacksmiths_in_westeros
	GROUP BY supplier
	ORDER BY SUM(invoice_amount) DESC
	LIMIT 10
)
SELECT DISTINCT test.supplier, COUNT(DISTINCT region)
FROM blacksmiths_in_westeros
JOIN test ON fat.supplier = test.supplier
GROUP BY test.supplier
ORDER BY count DESC; 








WITH reg AS (
	SELECT supplier, COUNT(DISTINCT region) AS num_regioni
	FROM blacksmiths_in_westeros
	GROUP BY supplier
)
SELECT COUNT(DISTINCT fat.supplier) AS num_fornitori
FROM blacksmiths_in_westeros
JOIN reg 
ON fat.supplier = reg.supplier
WHERE num_regioni = 19
ORDER BY num_fornitori DESC;





WITH test AS (
	SELECT DISTINCT supplier, SUM(invoice_amount)
	FROM blacksmiths_in_westeros
	GROUP BY supplier
	ORDER BY SUM(invoice_amount) DESC
	LIMIT 10
)
WITH reg AS (
	SELECT supplier, COUNT(DISTINCT region) AS num_regioni
	FROM blacksmiths_in_westeros
	GROUP BY supplier
)
SELECT DISTINCT test.supplier, COUNT(DISTINCT region)
FROM blacksmiths_in_westeros
JOIN test 
ON fat.supplier = test.supplier
JOIN reg 
ON fat.supplier = reg.supplier
GROUP BY test.supplier
ORDER BY count DESC; 


WITH reg AS (
	SELECT supplier, COUNT(DISTINCT region) AS num_regioni
	FROM blacksmiths_in_westeros
	GROUP BY supplier
)
SELECT DISTINCT supplier, SUM(invoice_amount), num_regioni
	FROM blacksmiths_in_westeros
	WHERE num_regioni = 19
	GROUP BY supplier
	ORDER BY SUM(invoice_amount) DESC
	


WITH reg AS (
	SELECT supplier, COUNT(DISTINCT region) AS num_regioni
	FROM blacksmiths_in_westeros
	GROUP BY supplier
)
SELECT DISTINCT fat.supplier, ROUND(SUM(fat.invoice_amount)) AS money, reg.num_regioni
FROM blacksmiths_in_westeros
JOIN reg
ON fat.supplier = reg.supplier
WHERE reg.num_regioni = 19
GROUP BY fat.supplier, reg.num_regioni
ORDER BY money DESC;



WITH ranked_data AS (
	SELECT 
		supplier, 
		ROUND(SUM(invoice_amount)) AS totale_importi, 
		COUNT(invoice_id) AS numero_fatture, 
		COUNT(DISTINCT region) AS regioni,
		row_number() OVER (ORDER BY SUM(invoice_amount) DESC) AS ranking
	FROM blacksmiths_in_westeros
	GROUP BY supplier
)
SELECT supplier, totale_importi, ranking
FROM ranked_data
WHERE regioni = 19
ORDER BY ranking;

