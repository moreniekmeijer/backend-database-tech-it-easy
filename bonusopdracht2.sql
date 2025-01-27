-- Tables for the main entities

CREATE TABLE Users (
    userId INT SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('Docent', 'Leerling') NOT NULL,
    email VARCHAR(100),
);

CREATE TABLE Material (
    materialId INT SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    materialType ENUM('Video', 'Link', 'PDF') NOT NULL,
    filePath VARCHAR(255),
    link VARCHAR(255),
    uploadedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    category VARCHAR(50),
    FOREIGN KEY (uploadedBy) REFERENCES Users(userId)
);

CREATE TABLE Lessons (
    lessonId INT SERIAL PRIMARY KEY,
    scheduledDate DATE NOT NULL,
);

CREATE TABLE Favorites (
    favoriteId INT SERIAL PRIMARY KEY,
    userId INT NOT NULL,
    materialId INT NOT NULL,
    FOREIGN KEY (userId) REFERENCES Users(userId),
    FOREIGN KEY (materialId) REFERENCES Material(materialId)
);

-- Table for many-to-many relation between material and lessons

CREATE TABLE LessonMaterial (
    lessonMaterialId INT SERIAL PRIMARY KEY,
    lessonId INT NOT NULL,
    materialId INT NOT NULL,
    FOREIGN KEY (lessonId) REFERENCES Lessons(lessonId),
    FOREIGN KEY (materialId) REFERENCES Material(materialId)
);
