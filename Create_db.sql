--Create the blacksmiths database
CREATE TABLE blacksmiths_in_westeros (
	blacksmith_id INT,
	blacksmith_name VARCHAR,
	vat_number VARCHAR,
	tax_id_number VARCHAR,
	region VARCHAR,
	province VARCHAR,
	city VARCHAR,
	invoice_id INT,
	invoice_number VARCHAR,
	invoice_date DATE,
	invoice_amount NUMERIC,
	supplier VARCHAR,
	supplier_tax_id VARCHAR
);

--Insert 3 rows of random data in the blacksmiths database
INSERT INTO blacksmiths_in_westeros (blacksmith_id, blacksmith_name, vat_number, tax_id_number, region, province, city, invoice_id, invoice_number, invoice_date, invoice_amount, supplier, supplier_tax_id)
VALUES 
	(1, 'Gendry Baratheon', 'VAT123456', 'TAX123456', 'The Stormlands', 'Mistwood', 'Flea Bottom', 1001, 'INV1001', '2022-01-01', 500.00, 'Lannister', 'TAX789012'),
	(2, 'Donal Noye', 'VAT654321', 'TAX654321', 'The North', 'Winterfell', 'Castle Black', 1002, 'INV1002', '2022-01-02', 750.00, 'Stark', 'TAX345678'),
	(3, 'Tobho Mott', 'VAT987654', 'TAX987654', 'The Crownlands', 'Dragonstone', 'Flea Bottom', 1003, 'INV1003', '2022-01-03', 1000.00, 'Tully', 'TAX901234');


--Create the database
CREATE TABLE regions (
	region VARCHAR,
	latitude NUMERIC,
	longitude NUMERIC
);

--Insert 3 rows of random data in the regions database
INSERT INTO regions (region, latitude, longitude)
VALUES 
	('The North', 48.864716, 2.349014),
	('The Crownlands', 40.712776, -74.005974),
	('The Riverlands', 51.507351, -0.127758);






--Check the number of different blacksmiths ID and blacksmiths name to see if there could be homonyms
SELECT COUNT(DISTINCT(blacksmith_id)) AS num_blacksmith_ids, COUNT(DISTINCT(blacksmith_name)) AS num_blacksmith_names
FROM fat;


--8 FIXED! Numero di farmacia_id con più di una denominazione
SELECT blacksmith_id, COUNT(DISTINCT blacksmith_name) as num_blacksmith_names
FROM fat
GROUP BY farmacia_id
HAVING COUNT(DISTINCT blacksmith_name) > 1;


--9 FIXED! Verifica di tutte le denominazioni connesse ad uno stesso id
SELECT farmacia_id, denominazione AS name, regione, provincia
FROM fat
WHERE farmacia_id IN(
	SELECT farmacia_id
	FROM fat
	GROUP BY farmacia_id
	HAVING COUNT(DISTINCT denominazione) > 1)
GROUP BY name, regione, provincia, farmacia_id
ORDER BY farmacia_id;


--CONTARE LE FATTURE


--Amount of invoices by region
SELECT DISTINCT regione, COUNT(*)
FROM fat
GROUP BY regione
ORDER BY count DESC;


--Amount of invoices by provinces in one single region
SELECT DISTINCT regione, provincia, COUNT(*)
FROM fat
WHERE regione = 'CAMPANIA'
GROUP BY regione, provincia
ORDER BY regione, provincia DESC;


--15 Quantità di fatture divise per provincia tutte le altre regioni
SELECT DISTINCT regione, provincia, COUNT(*)
FROM fat
WHERE regione NOT IN ('CAMPANIA', 'SICILIA', 'LOMBARDIA', 'LAZIO')
GROUP BY regione, provincia
ORDER BY regione, provincia DESC;


--16 Le 10 farmacie con la spesa annua maggiore
SELECT DISTINCT farmacia_id, regione, provincia, ROUND(SUM(importo), 2) AS sum
FROM fat
GROUP BY farmacia_id, regione, provincia
ORDER BY sum DESC
LIMIT 10;


--17 Le 10 farmacie che hanno speso di più in un mese
SELECT DISTINCT(EXTRACT(MONTH FROM data_documento)) AS month, SUM(importo), farmacia_id, regione
FROM fat
GROUP BY farmacia_id, regione, month
ORDER BY sum DESC
LIMIT 10;


--18 Spesa mensile divisa per regione
SELECT DISTINCT(EXTRACT(MONTH FROM data_documento)) AS month, ROUND(SUM(importo), 2) AS sum, regione
FROM fat
GROUP BY month, regione
ORDER BY regione;


--19 Numero di fatture mensili, senza distinzione di regione
SELECT DISTINCT(EXTRACT(MONTH FROM data_documento)) AS months, COUNT(*) as activity
FROM fat
GROUP BY months;


--20 Numero di diverse farmacie per regione
SELECT COUNT(DISTINCT farmacia_id) AS num, regione
FROM fat
GROUP BY regione
ORDER BY num DESC;


--21 Numero di diverse farmacie per provincia
SELECT COUNT(DISTINCT farmacia_id) AS farm_id, regione, provincia
FROM fat
GROUP BY regione, provincia
ORDER BY farm_id DESC;


--22 Lista Farmacie omonime con diversi ID 
SELECT farmacia_id, denominazione AS name, regione, provincia, comune
FROM fat
WHERE denominazione IN(
	SELECT denominazione
	FROM fat
	GROUP BY denominazione
	HAVING COUNT(DISTINCT farmacia_id) > 1)
GROUP BY farmacia_id, name, regione, provincia, comune
ORDER BY name;


--23 Totale Fatture by Comune
SELECT comune, count(comune)
FROM fat
GROUP BY comune
ORDER BY count DESC;


--ANALISI DEI FORNITORI

--24 Totale fornitori
SELECT COUNT(DISTINCT(fornitore)) AS fornitori
FROM fat;


--25 Top 10 fornitori per totale spesa
SELECT fornitore, total_spending || ' millions' AS tot
FROM
	(SELECT fornitore, ROUND(SUM(importo)/1000000, 2) as total_spending
	FROM fat
	GROUP BY fornitore
	ORDER BY total_spending DESC) AS test
LIMIT 10;


--26 Numero di farmacie che ogni fornitore gestisce
SELECT fornitore, COUNT(DISTINCT farmacia_id) as num_farmacie
FROM fat
GROUP BY fornitore
ORDER BY num_farmacie DESC;


--27 Numero di fornitori da cui ogni farmacia si serve
SELECT farmacia_id, COUNT(DISTINCT fornitore) as num_fornitori
FROM fat
GROUP BY farmacia_id
ORDER BY num_fornitori DESC;


--28 Numero di regioni che ogni fornitore gestisce
SELECT fornitore, COUNT(DISTINCT regione) as regioni
FROM fat
GROUP BY fornitore
ORDER BY regioni DESC;


--29 Quanti fornitori forniscono quante regioni
SELECT DISTINCT(regioni) AS num_regioni_fornite, COUNT(fornitore) AS forn
FROM
	(SELECT fornitore, COUNT(DISTINCT regione) as regioni
	FROM fat
	GROUP BY fornitore) AS reg
GROUP BY num_regioni_fornite
ORDER BY num_regioni_fornite DESC;


--30 Totale degli importi fatturati e il fornitore che ha emesso il maggior numero di fatture
SELECT fornitore, ROUND(SUM(importo),2) as totale_importi, COUNT(fattura_id) AS numero_fatture, COUNT(DISTINCT regione) AS regioni
FROM fat
GROUP BY fornitore
ORDER BY numero_fatture DESC
LIMIT 10;

--31 Numero di farmacie per regione
SELECT regione, COUNT(farmacia_id) as numero_farmacie
FROM fat
GROUP BY regione
ORDER BY numero_farmacie DESC;

--32  trend degli importi fatturati nel tempo
SELECT data_documento, ROUND(AVG(importo),2) as importo_medio
FROM fat
GROUP BY data_documento
ORDER BY data_documento ASC;

--33 trend fatture per fornitore
SELECT fornitore, data_documento, COUNT(fattura_id) as numero_fatture, ROUND(AVG(importo),2) as importo_medio
FROM fat
GROUP BY fornitore, data_documento
ORDER BY fornitore, data_documento ASC;

--34 numero fatture per regione
SELECT regione, COUNT(fattura_id) as numero_fatture
FROM fat
GROUP BY regione;

--35 relazione tra il fornitore e l'importo delle fatture
SELECT fornitore, ROUND(AVG(importo),2) as importo_medio
FROM fat
GROUP BY fornitore
ORDER BY importo_medio DESC;

--36 fornitori più frequenti
SELECT fornitore, COUNT(fattura_id) as numero_fatture
FROM fat
GROUP BY fornitore
ORDER BY numero_fatture DESC
LIMIT 5;

--37 Analisi dei totali per regione
SELECT regione, SUM(importo) as totale_importi
FROM fat
GROUP BY regione
ORDER BY totale_importi DESC;

--38 Analisi dei fornitori più costosi per regione
SELECT regione, fornitore, SUM(importo) as totale_importi
FROM fat
GROUP BY regione, fornitore
ORDER BY totale_importi DESC
LIMIT 5;

--39 Analisi della distribuzione delle fatture nel tempo
SELECT date_trunc('month', data_documento) as mese, COUNT(fattura_id) as numero_fatture
FROM fat
GROUP BY mese
ORDER BY mese;

--40 Totale fatture e totale importi per regione con coordinate
SELECT DISTINCT fat.provincia, COUNT(*) AS num_fatture, SUM(importo) as totale_importi, latitudine, longitudine
FROM fat
INNER JOIN geo
ON fat.provincia = geo.provincia
GROUP BY fat.provincia, latitudine, longitudine;

--41 comune, num fatture, sum importo, location and population
SELECT DISTINCT fat.comune, COUNT(fattura_id) AS num_fatture, ROUND(SUM(importo),2) AS importo, lat, lng, population
FROM fat
LEFT JOIN it
ON fat.comune = it.city
WHERE city IS NOT NULL
GROUP BY fat.comune, lat, lng, population, population_proper
ORDER BY num_fatture DESC;

--42 relazione tra popolazione e numero fatture
SELECT it.city, COUNT(fat.fattura_id::numeric) AS total_fattura_id, it.population, ROUND(COUNT(fat.fattura_id::numeric) / (it.population::numeric),2) AS fattura_id_per_person, lat, lng
FROM fat
JOIN it ON fat.comune = it.city
GROUP BY it.city, it.population, lat, lng
ORDER BY fattura_id_per_person DESC;

--43 relazione tra popolazione e importo
SELECT DISTINCT fat.regione, ROUND(SUM(fat.importo::numeric), 2) AS total_fattura_id, it.population, ROUND(SUM(fat.importo::numeric) / (it.population::numeric),2) AS importo_per_person
FROM fat
JOIN it ON fat.comune = it.city
GROUP BY fat.regione, it.population
ORDER BY importo_per_person DESC;

--44 spesa totale annua delle farmacie per regione
SELECT DISTINCT regione, ROUND(SUM(importo)/1000000) || ' M' AS round
FROM fat
GROUP BY regione
ORDER BY round DESC;

--45 average number of fatture by pharmacy for each region
SELECT DISTINCT fat.regione, COUNT(*)/COUNT(DISTINCT farmacia_id) AS num_fatture
FROM fat
GROUP BY fat.regione
ORDER BY num_fatture DESC;

SELECT DISTINCT fat.regione, AVG(COUNT(fat.fattura_id)) OVER (PARTITION BY fat.regione) AS avg_fatture_per_pharmacy
FROM fat
GROUP BY fat.farmacia_id, fat.regione
ORDER BY avg_fatture_per_pharmacy DESC;

--46
SELECT DISTINCT fat.regione, ROUND(SUM(Importo)/COUNT(DISTINCT farmacia_id)) AS num_fatture
FROM fat
GROUP BY fat.regione
ORDER BY num_fatture DESC;

SELECT DISTINCT fat.regione, ROUND(AVG(SUM(fat.importo)) OVER (PARTITION BY fat.regione)) AS avg_importo_per_pharmacy
FROM fat
GROUP BY fat.regione
ORDER BY avg_importo_per_pharmacy DESC;

SELECT ROUND(SUM(importo))
FROM fat;



--
SELECT DISTINCT(regioni) AS num_regioni_fornite, COUNT(fornitore) AS forn
FROM
	(SELECT fornitore, COUNT(DISTINCT regione) as regioni
	FROM fat
	GROUP BY fornitore) AS reg
WHERE num_regioni_fornite = '1'
GROUP BY num_regioni_fornite
ORDER BY num_regioni_fornite DESC;


SELECT DISTINCT regioni AS num_regioni_fornite, COUNT(fornitore) AS forn
FROM
	(SELECT fornitore, COUNT(DISTINCT regione) as regioni
	FROM fat
	GROUP BY fornitore) AS reg
WHERE regioni = 1
GROUP BY regioni
ORDER BY regioni DESC;

SELECT regione, COUNT(DISTINCT fornitore) AS num_fornitori
FROM fat
GROUP BY regione
ORDER BY num_fornitori DESC;


WITH reg AS (
	SELECT fornitore, COUNT(DISTINCT regione) AS num_regioni
	FROM fat
	GROUP BY fornitore
)
SELECT regione, COUNT(DISTINCT fat.fornitore) AS num_fornitori
FROM fat
JOIN reg ON fat.fornitore = reg.fornitore
WHERE num_regioni = 19
GROUP BY regione
ORDER BY num_fornitori DESC;



WITH test AS (
	SELECT DISTINCT fornitore, SUM(importo)
	FROM fat
	GROUP BY fornitore
	ORDER BY SUM(importo) DESC
	LIMIT 10
)
SELECT DISTINCT test.fornitore, COUNT(DISTINCT regione)
FROM fat
JOIN test ON fat.fornitore = test.fornitore
GROUP BY test.fornitore
ORDER BY count DESC; 








WITH reg AS (
	SELECT fornitore, COUNT(DISTINCT regione) AS num_regioni
	FROM fat
	GROUP BY fornitore
)
SELECT COUNT(DISTINCT fat.fornitore) AS num_fornitori
FROM fat
JOIN reg 
ON fat.fornitore = reg.fornitore
WHERE num_regioni = 19
ORDER BY num_fornitori DESC;





WITH test AS (
	SELECT DISTINCT fornitore, SUM(importo)
	FROM fat
	GROUP BY fornitore
	ORDER BY SUM(importo) DESC
	LIMIT 10
)
WITH reg AS (
	SELECT fornitore, COUNT(DISTINCT regione) AS num_regioni
	FROM fat
	GROUP BY fornitore
)
SELECT DISTINCT test.fornitore, COUNT(DISTINCT regione)
FROM fat
JOIN test 
ON fat.fornitore = test.fornitore
JOIN reg 
ON fat.fornitore = reg.fornitore
GROUP BY test.fornitore
ORDER BY count DESC; 


WITH reg AS (
	SELECT fornitore, COUNT(DISTINCT regione) AS num_regioni
	FROM fat
	GROUP BY fornitore
)
SELECT DISTINCT fornitore, SUM(importo), num_regioni
	FROM fat
	WHERE num_regioni = 19
	GROUP BY fornitore
	ORDER BY SUM(importo) DESC
	


WITH reg AS (
	SELECT fornitore, COUNT(DISTINCT regione) AS num_regioni
	FROM fat
	GROUP BY fornitore
)
SELECT DISTINCT fat.fornitore, ROUND(SUM(fat.importo)) AS money, reg.num_regioni
FROM fat
JOIN reg
ON fat.fornitore = reg.fornitore
WHERE reg.num_regioni = 19
GROUP BY fat.fornitore, reg.num_regioni
ORDER BY money DESC;



WITH ranked_data AS (
	SELECT 
		fornitore, 
		ROUND(SUM(importo)) AS totale_importi, 
		COUNT(fattura_id) AS numero_fatture, 
		COUNT(DISTINCT regione) AS regioni,
		row_number() OVER (ORDER BY SUM(importo) DESC) AS ranking
	FROM fat
	GROUP BY fornitore
)
SELECT fornitore, totale_importi, ranking
FROM ranked_data
WHERE regioni = 19
ORDER BY ranking;

