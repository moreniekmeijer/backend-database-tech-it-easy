DROP TABLE users, remotecontrollers, wallbrackets, television_wallbracket;
DROP TABLE televisions CASCADE;
DROP TABLE products CASCADE;
DROP TABLE cimodules CASCADE;

-- create tables

CREATE TABLE users (
    username VARCHAR(50) PRIMARY KEY NOT NULL,
    password VARCHAR(255),
    address VARCHAR(200),
    role VARCHAR(50),
    payScale INT,
    vacationDays INT
);

CREATE TABLE products (
    id SERIAL PRIMARY KEY NOT NULL,
    name VARCHAR(100),
    brand VARCHAR(50),
    price REAL,
    currentStock INT,
    sold INT,
    dateSold DATE,
    productType VARCHAR(100)
);

CREATE TABLE televisions (
    product_id INT PRIMARY KEY,
    height REAL,
    width REAL,
    screenQuality VARCHAR(100),
    screenType VARCHAR(100),
    wifi BOOLEAN,
    smartTV BOOLEAN,
    voiceControl BOOLEAN,
    HDR BOOLEAN,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

CREATE TABLE remoteControllers (
    product_id INT PRIMARY KEY,
    smart BOOLEAN,
	batteryType VARCHAR(100),
	television_id INT UNIQUE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
	FOREIGN KEY (television_id) REFERENCES televisions (product_id) ON DELETE CASCADE
);

CREATE TABLE ciModules (
    product_id INT PRIMARY KEY,
    provider VARCHAR(100),
	encodingType VARCHAR(100),
	television_id INT,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
	FOREIGN KEY (television_id) REFERENCES televisions (product_id) ON DELETE CASCADE
);

CREATE TABLE wallBrackets (
    product_id INT PRIMARY KEY,
    adjustable BOOLEAN,
	attachmentMethod VARCHAR(100),
	height REAL,
	width REAL,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- junction table for wallBrackets to televisions (many-to-many)

CREATE TABLE television_wallBracket (
    television_id INT,
    wallbracket_id INT,
    PRIMARY KEY (television_id, wallbracket_id),
    FOREIGN KEY (television_id) REFERENCES televisions (product_id) ON DELETE CASCADE,
    FOREIGN KEY (wallbracket_id) REFERENCES wallBrackets (product_id) ON DELETE CASCADE
);

-- add televisions (used from frontend tech-it-easy inventory)

INSERT INTO products (name, brand, price, productType)
VALUES 
	('4K TV', 'Philips', 379, 'television'),
	('HD smart TV', 'Nikkei', 159, 'television'),
	('4K QLED TV', 'Samsung', 709, 'television'),
	('Ultra HD SMART TV', 'Hitachi', 349, 'television'),
	('The One 4K TV', 'Philips', 479, 'television'),
	('4K LED TV', 'Philips', 689, 'television'),
	('LED TV', 'Brandt', 109, 'television'),
	('HD TV', 'Toshiba', 161, 'television');

INSERT INTO televisions (product_id, height, width, screenQuality, screenType, wifi, smartTV, voiceControl, HDR)
VALUES
	(1, NULL, NULL, 'Ultra HD/4K', 'LED', TRUE, TRUE, FALSE, TRUE),
	(2, NULL, NULL, 'HD ready', 'LED', TRUE, TRUE, FALSE, FALSE),
	(3, NULL, NULL, 'Ultra HD/4K', 'QLED', TRUE, TRUE, TRUE, TRUE),
	(4, NULL, NULL, 'Ultra HD/4K', 'LCD', TRUE, TRUE, TRUE, TRUE),
	(5, NULL, NULL, 'Ultra HD/4K', 'LED', TRUE, TRUE, TRUE, TRUE),
	(6, NULL, NULL, 'Ultra HD/4K', 'LED', TRUE, TRUE, FALSE, TRUE),
	(7, NULL, NULL, 'Full HD', 'LED', FALSE, FALSE, FALSE, FALSE),
	(8, NULL, NULL, 'Full HD', 'LED', FALSE, FALSE, FALSE, TRUE);

-- add some other products (made-up wallbrackets)

INSERT INTO products (name, brand, price, productType)
VALUES 
	('Wall-i', 'Philips', 20, 'wallBracket'),
	('Wall of Mount', 'TV Mountains', 50, 'wallBracket'),
	('Toshibase', 'Toshiba', 30, 'wallBracket');

INSERT INTO wallBrackets (product_id, adjustable, attachmentMethod, height, width)
VALUES 
    (9, TRUE, 'schrews', 50.0, 30.0),
    (10, FALSE, 'sticky', 40.0, 20.0),
    (11, TRUE, 'magnetic', 60.0, 35.0);

INSERT INTO television_wallbracket (television_id, wallbracket_id)
VALUES 
    (1, 9),
	(5, 9),
	(6, 9),
	(8, 11);

-- fancy select statement

SELECT 
    tv.name AS television_name,
    tv.brand AS television_brand,
    tv.price AS television_price,
	p.name AS wallbracket_name,
    p.brand AS wallbracket_brand,
    p.price AS wallbracket_price
FROM 
    wallBrackets wb
JOIN 
    television_wallbracket twb ON wb.product_id = twb.wallbracket_id
JOIN 
    products p ON wb.product_id = p.id
JOIN
    products tv ON tv.id = twb.television_id
WHERE 
    p.productType = 'wallBracket' AND tv.productType = 'television';



