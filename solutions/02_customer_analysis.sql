/*
02. Customers Visiting Multiple States
Find customers who have booked hotels in at least three different states.
*/

SELECT 
    c.customer_id,
    COUNT(DISTINCT ci.state) AS states_visited
FROM hotel_bookings hb
JOIN customers c ON hb.customer_id = c.customer_id
JOIN hotels h ON hb.hotel_id = h.id
JOIN cities ci ON h.city_id = ci.id
GROUP BY c.customer_id
HAVING COUNT(DISTINCT ci.state) >= 3;



/*
13. Customers with No Bookings
Identify customers who have never made any hotel booking.
*/

SELECT 
    customer_id
FROM customers
WHERE customer_id NOT IN (
    SELECT DISTINCT customer_id
    FROM hotel_bookings
);



/*
14. Multi-Hotel Stays in Same Month
Find customers who stayed in at least three distinct hotels
within the same month.
*/

WITH monthly_stays AS (
    SELECT 
        hb.customer_id,
        MONTH(hb.stay_start_date) AS stay_month,
        COUNT(DISTINCT hb.hotel_id) AS hotels_visited,
        COUNT(DISTINCT hb.booking_id) AS total_bookings
    FROM hotel_bookings hb
    GROUP BY hb.customer_id, MONTH(hb.stay_start_date)
)
SELECT 
    customer_id,
    stay_month,
    total_bookings
FROM monthly_stays
WHERE hotels_visited >= 3
ORDER BY customer_id, stay_month;
