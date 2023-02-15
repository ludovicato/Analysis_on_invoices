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
	(4, 'Mikken', 'VAT135790', 'TAX246801', 'The North', 'Winterfell', 'Winter Town', 1004, 'INV1004', '2022-01-04', 200.00, 'Stark', 'TAX345678'),
	(5, 'Salloreon', 'VAT246801', 'TAX135790', 'The Reach', 'Oldtown', 'Oldtown', 1005, 'INV1005', '2022-01-05', 1500.00, 'Tyrell', 'TAX567890'),
	(6, 'Qhorin Halfhand', 'VAT456789', 'TAX567890', 'The Crownlands', 'Hardhome', 'Castle Black', 1006, 'INV1006', '2022-01-06', 300.00, 'Tully', 'TAX123456'),
	(7, 'Harys Swyft', 'VAT678901', 'TAX789012', 'The Westerlands', 'Lannisport', 'Lannisport', 1007, 'INV1007', '2022-01-07', 1200.00, 'Lannister', 'TAX789012'),
	(8, 'Torrhen Karstark', 'VAT123789', 'TAX456012', 'The North', 'Karhold', 'Karhold', 1008, 'INV1008', '2022-01-08', 400.00, 'Stark', 'TAX345678'),
	(9, 'Eddard Blackfyre', 'VAT567123', 'TAX901456', 'The Crownlands', 'Kings Landing', 'Kings Landing', 1009, 'INV1009', '2022-01-09', 600.00, 'Targaryen', 'TAX234567'),
	(10, 'Illyrio Mopatis', 'VAT890456', 'TAX123789', 'The Vale', 'Pentos', 'Pentos', 1010, 'INV1010', '2022-01-10', 900.00, 'Targaryen', 'TAX234567'),
	(11, 'Gendry Waters', 'VAT901234', 'TAX345678', 'The Crownlands', 'Dragonstone', 'Flea Bottom', 1011, 'INV1011', '2022-01-11', 250.00, 'Baratheon', 'TAX789123'),
	(12, 'Mance Rayder', 'VAT234567', 'TAX890123', 'The North', 'Frostfangs', 'Castle Black', 1012, 'INV1012', '2022-01-12', 100.00, 'Arryn', 'TAX890123'),
	(13, 'Hal Mollen', 'VAT789012', 'TAX456789', 'The Riverlands', 'Riverrun', 'Riverrun', 1013, 'INV1013', '2022-01-13', 800.00, 'Martell', 'TAX901465'),
	(14, 'Vayon Poole', 'VAT345678', 'TAX901234', 'The North', 'Winterfell', 'Winterfell', 1014, 'INV1014', '2022-01-14', 150.00, 'Stark', 'TAX345678'),
	(15, 'Harys Swyft', 'VAT456012', 'TAX789123', 'The Iron Islands', 'Pyke', 'Pyke', 1015, 'INV1015', '2022-02-15', 450.00, 'Greyjoy', 'TAX012345');


--Create the database
CREATE TABLE regions (
	region VARCHAR,
	population INT,
	latitude NUMERIC,
	longitude NUMERIC
);

--Insert 3 rows of random data in the regions database
INSERT INTO regions (region, latitude, longitude)
VALUES 
	('The North', 3200000, 48.864716, 2.349014),
	('The Crownlands', 1700000, 40.712776, -74.005974),
	('The Riverlands', 2200000, 51.507351, -0.127758);
