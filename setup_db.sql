CREATE DATABASE appointments;
USE appointments;

CREATE TABLE appointments (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	time DATETIME NOT NULL, 
	description VARCHAR(255)
);

# Some initial values
INSERT INTO appointments(time,description) 
	VALUES ('2016-01-04 5:30:00', 'foo');
INSERT INTO appointments(time,description) 
	VALUES ('2016-11-27 15:30:00', 'bar');
