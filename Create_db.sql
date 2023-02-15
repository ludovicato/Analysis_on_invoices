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
