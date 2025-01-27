DROP TABLE users, remoteControllers, wallBrackets, televisionWallBracket;
DROP TABLE televisions CASCADE;
DROP TABLE products CASCADE;
DROP TABLE ciModules CASCADE;

-- create tables

CREATE TABLE users (
    username VARCHAR(50) PRIMARY KEY,
    password VARCHAR(255) NOT NULL,
    address VARCHAR(200),
    role VARCHAR(50) NOT NULL,
    payScale INT,
    vacationDays INT
);

CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    brand VARCHAR(50) NOT NULL,
    price REAL NOT NULL,
    currentStock INT DEFAULT 0,
    sold INT DEFAULT 0,
    dateSold DATE,
    productType VARCHAR(100)
);

CREATE TABLE televisions (
    productID INT PRIMARY KEY,
    height REAL,
    width REAL,
    screenQuality VARCHAR(100),
    screenType VARCHAR(100),
    wifi BOOLEAN,
    smartTV BOOLEAN,
    voiceControl BOOLEAN,
    HDR BOOLEAN,
    FOREIGN KEY (productID) REFERENCES products(id) ON DELETE CASCADE
);

CREATE TABLE remoteControllers (
    productID INT PRIMARY KEY,
    smart BOOLEAN,
	batteryType VARCHAR(100),
	televisionId INT UNIQUE,
    FOREIGN KEY (productID) REFERENCES products(id) ON DELETE CASCADE,
	FOREIGN KEY (televisionID) REFERENCES televisions (productID) ON DELETE CASCADE
);

CREATE TABLE ciModules (
    productID INT PRIMARY KEY,
    provider VARCHAR(100),
	encodingType VARCHAR(100),
	televisionID INT,
    FOREIGN KEY (productID) REFERENCES products(id) ON DELETE CASCADE,
	FOREIGN KEY (televisionID) REFERENCES televisions (productID) ON DELETE CASCADE
);

CREATE TABLE wallBrackets (
    productID INT PRIMARY KEY,
    adjustable BOOLEAN,
	attachmentMethod VARCHAR(100),
	height REAL,
	width REAL,
    FOREIGN KEY (productID) REFERENCES products(id) ON DELETE CASCADE
);

-- junction table for wallBrackets to televisions (many-to-many)

CREATE TABLE televisionWallBracket (
    televisionID INT,
    wallbracketID INT,
    PRIMARY KEY (televisionID, wallbracketID),
    FOREIGN KEY (televisionID) REFERENCES televisions (productID) ON DELETE CASCADE,
    FOREIGN KEY (wallBracketID) REFERENCES wallBrackets (productID) ON DELETE CASCADE
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

INSERT INTO televisions (productID, height, width, screenQuality, screenType, wifi, smartTV, voiceControl, HDR)
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

INSERT INTO wallBrackets (productID, adjustable, attachmentMethod, height, width)
VALUES 
    (9, TRUE, 'schrews', 50.0, 30.0),
    (10, FALSE, 'sticky', 40.0, 20.0),
    (11, TRUE, 'magnetic', 60.0, 35.0);

INSERT INTO televisionWallBracket (televisionID, wallBracketID)
VALUES 
    (1, 9),
	(5, 9),
	(6, 9),
	(8, 11);

-- fancy select statement

SELECT 
    tv.name AS televisionName,
    tv.brand AS televisionBrand,
    tv.price AS televisionPrice,
	p.name AS wallbracketName,
    p.brand AS wallbracketBrand,
    p.price AS wallbracketPrice
FROM 
    wallBrackets wb
JOIN 
    televisionWallBracket twb ON wb.productID = twb.wallBracketID
JOIN 
    products p ON wb.productID = p.id
JOIN
    products tv ON tv.id = twb.televisionID
WHERE 
    p.productType = 'wallBracket' AND tv.productType = 'television';



