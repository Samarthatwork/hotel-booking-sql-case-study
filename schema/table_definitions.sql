-- customers table
-- Stores customer demographic details and home city

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    gender CHAR(1),
    dob VARCHAR(10),
    city_id INT
);

--------------------------------------------------

-- hotels table
-- Stores hotel details and location

CREATE TABLE hotels (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    capacity INT,
    city_id INT
);

--------------------------------------------------

-- cities table
-- Stores city and state mapping

CREATE TABLE cities (
    id INT PRIMARY KEY,
    city VARCHAR(50),
    state VARCHAR(50)
);

--------------------------------------------------

-- hotel_bookings table
-- Stores booking-level transactional data

CREATE TABLE hotel_bookings (
    booking_id VARCHAR(20) PRIMARY KEY,
    booking_date DATE,
    booking_channel VARCHAR(50),
    customer_id INT,
    stay_start_date DATE,
    number_of_nights INT,
    per_night_rate DECIMAL(10,2),
    hotel_id INT
);
