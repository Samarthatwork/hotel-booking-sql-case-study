/*
04. Peak Occupancy Date per Hotel
Find the date when occupancy was maximum for each hotel.
A customer is not considered present on the checkout date.
*/

WITH booking_ranges AS (
    SELECT 
        hotel_id,
        customer_id,
        stay_start_date AS start_date,
        DATEADD(day, number_of_nights - 1, stay_start_date) AS end_date
    FROM hotel_bookings
),
expanded_stays AS (
    SELECT 
        hotel_id,
        customer_id,
        start_date AS stay_date,
        end_date
    FROM booking_ranges
    UNION ALL
    SELECT 
        hotel_id,
        customer_id,
        DATEADD(day, 1, stay_date),
        end_date
    FROM expanded_stays
    WHERE DATEADD(day, 1, stay_date) <= end_date
),
daily_occupancy AS (
    SELECT 
        es.hotel_id,
        es.stay_date,
        COUNT(*) AS guest_count,
        h.capacity
    FROM expanded_stays es
    JOIN hotels h ON es.hotel_id = h.id
    GROUP BY es.hotel_id, es.stay_date, h.capacity
)
SELECT 
    hotel_id,
    stay_date,
    guest_count
FROM (
    SELECT *,
           RANK() OVER (
               PARTITION BY hotel_id 
               ORDER BY guest_count DESC
           ) AS rn
    FROM daily_occupancy
) ranked
WHERE rn = 1
ORDER BY hotel_id;



/*
06. Monthly Occupancy Rate per Hotel
Calculate monthly occupancy percentage for each hotel.
*/

WITH daily_data AS (
    SELECT 
        hotel_id,
        stay_date,
        COUNT(*) AS daily_guests,
        capacity
    FROM expanded_stays es
    JOIN hotels h ON es.hotel_id = h.id
    GROUP BY hotel_id, stay_date, capacity
)
SELECT DISTINCT
    hotel_id,
    MONTH(stay_date) AS stay_month,
    SUM(daily_guests) OVER (PARTITION BY hotel_id, MONTH(stay_date)) AS monthly_guests,
    SUM(capacity) OVER (PARTITION BY hotel_id, MONTH(stay_date)) AS monthly_capacity,
    ROUND(
        SUM(daily_guests) OVER (PARTITION BY hotel_id, MONTH(stay_date)) * 100.0 /
        SUM(capacity) OVER (PARTITION BY hotel_id, MONTH(stay_date)),
        2
    ) AS occupancy_rate
FROM daily_data
ORDER BY hotel_id, stay_month;



/*
07. Fully Occupied Dates
Find dates when hotels were fully occupied.
*/

SELECT 
    hotel_id,
    stay_date
FROM daily_occupancy
WHERE guest_count = capacity
ORDER BY hotel_id, stay_date;
