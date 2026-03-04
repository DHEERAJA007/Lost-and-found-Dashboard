CREATE DATABASE lost_found_db;
USE lost_found_db;

CREATE TABLE items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    item_name VARCHAR(100) NOT NULL,
    description TEXT,
    location VARCHAR(100),
    date_reported DATE,
    status ENUM('Lost','Found','Claimed') DEFAULT 'Lost',
    reporter_name VARCHAR(100),
    reporter_contact VARCHAR(100)
);