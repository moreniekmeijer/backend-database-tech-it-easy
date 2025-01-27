DROP TABLE IF EXISTS Users, Lessons, Styles, Material, Favorites, LessonStyle;

-- users

CREATE TABLE Users (
    userId SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL,
    email VARCHAR(100)
);

-- lessons (optional parent of styles, many-to-many relation)

CREATE TABLE Lessons (
    lessonId SERIAL PRIMARY KEY,
    scheduledDate DATE NOT NULL
);

-- styles (direct parent of material, one-to-many relation)

CREATE TABLE Styles (
    styleId SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
	origin VARCHAR(50),
    description TEXT
);

-- material (lowest child with the most information)

CREATE TABLE Material (
    materialId SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    materialType VARCHAR(20) NOT NULL,
    filePath VARCHAR(255),
    link VARCHAR(255),
    uploadedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	instrument VARCHAR(50),
    category VARCHAR(50),
	styleId INT,
	FOREIGN KEY (styleId) REFERENCES Styles(styleId),
	uploadedBy INT NOT NULL,
    FOREIGN KEY (uploadedBy) REFERENCES Users(userId)
);

-- table for many-to-many relation between material and users

CREATE TABLE Favorites (
    favoriteId SERIAL PRIMARY KEY,
    userId INT NOT NULL,
    materialId INT NOT NULL,
    FOREIGN KEY (userId) REFERENCES Users(userId),
    FOREIGN KEY (materialId) REFERENCES Material(materialId)
);

-- Table for many-to-many relation between styles and lessons

CREATE TABLE LessonStyle (
    lessonStyleId SERIAL PRIMARY KEY,
    lessonId INT NOT NULL,
    styleId INT NOT NULL,
    FOREIGN KEY (lessonId) REFERENCES Lessons(lessonId),
    FOREIGN KEY (styleId) REFERENCES Styles(styleId)
);



-- Some inserts (thank you chatGPT...)

INSERT INTO Users (username, password, role, email)
VALUES
    ('JohnDoe', 'securepassword', 'Docent', 'johndoe@example.com');

INSERT INTO Styles (name, origin, description)
VALUES
    ('Maracatu', 'Brazil', 'A Brazilian percussion rhythm known for its powerful beats and vibrant celebrations, often associated with carnival.'),
    ('Samba', 'Brazil', 'A lively Brazilian rhythm characterized by syncopated beats and fast-paced drum patterns, often played during carnival.'),
    ('Makru', 'Africa', 'A rhythm originating from African percussion traditions, incorporating complex polyrhythms and a rich cultural heritage.');

INSERT INTO Material (title, materialType, filePath, link, instrument, category, styleId, uploadedBy)
VALUES
    ('Maracatu Arrangement', 'PDF', 'path/to/maracatu_arrangement.pdf', NULL, 'Snare Drum', 'Sheet Music', 1, 1),
    ('Surdo Rhythm for Maracatu', 'Video', 'path/to/maracatu_surdo_rhythm.mp4', NULL, 'Surdo', 'Rhythm', 1, 1),
    ('Snare Drum Rhythm for Maracatu', 'Video', 'path/to/maracatu_snare_rhythm.mp4', NULL, 'Snare Drum', 'Rhythm', 1, 1),
    ('Shaker Rhythm for Maracatu', 'Video', 'path/to/maracatu_shaker_rhythm.mp4', NULL, 'Shaker', 'Rhythm', 1, 1),
    ('Maracatu on YouTube', 'Link', NULL, 'https://www.youtube.com/watch?v=example', 'All', 'Video', 1, 1);

INSERT INTO Material (title, materialType, filePath, link, instrument, category, styleId, uploadedBy)
VALUES
	('Samba Arrangement', 'PDF', 'path/to/samba_arrangement.pdf', NULL, 'Snare Drum', 'Sheet Music', 2, 1),
    ('Surdo Rhythm for Samba', 'Video', 'path/to/samba_surdo_rhythm.mp4', NULL, 'Surdo', 'Rhythm', 2, 1),
    ('Snare Drum Rhythm for Samba', 'Video', 'path/to/samba_snare_rhythm.mp4', NULL, 'Snare Drum', 'Rhythm', 2, 1),
    ('Shaker Rhythm for Samba', 'Video', 'path/to/samba_shaker_rhythm.mp4', NULL, 'Shaker', 'Rhythm', 2, 1);

INSERT INTO Material (title, materialType, filePath, link, instrument, category, styleId, uploadedBy)
VALUES
    ('Makru Drum Rhythms', 'Video', 'path/to/makru_drum_rhythms.mp4', NULL, 'Djembe', 'Rhythm', 3, 1),
    ('Makru Drum Arrangement', 'PDF', 'path/to/makru_drum_arrangement.pdf', NULL, 'Djembe', 'Sheet Music', 3, 1),
    ('Makru Traditional Drumming', 'Video', 'path/to/makru_traditional_drumming.mp4', NULL, 'Djembe', 'Rhythm', 3, 1);

INSERT INTO Material (title, materialType, filePath, link, instrument, category, styleId, uploadedBy)
VALUES
    ('Snaredrum Oefeningen', 'PDF', 'path/to/snaredrum_oefeningen.pdf', NULL, 'Snare Drum', 'Exercises', NULL, 1),
    ('Leuke Djembe Video', 'Link', NULL, 'https://www.youtube.com/watch?v=djembe_video', 'Djembe', 'Performance', NULL, 1);



-- Select statement

SELECT 
	Material.title,
    Material.materialType,
	Material.instrument,
	Material.category,
	Styles.origin
FROM 
    Material
JOIN 
    Styles ON Material.styleId = Styles.styleId;
