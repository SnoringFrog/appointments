CREATE DATABASE appointments;
USE appointments;
CREATE TABLE appointments (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	time SMALLDATETIME, 
	description VARCHAR(255)
);
