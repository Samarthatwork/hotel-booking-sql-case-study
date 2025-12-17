/*
01. Same-City Bookings by Customers
Find the top 5 customers who made the highest number of bookings
in the same city where they live.
*/

SELECT TOP 5 
    hb.customer_id,
    COUNT(CASE WHEN h.city_id = c.city_id THEN hb.booking_id END) AS same_city_bookings,
    COUNT(*) AS total_bookings,
    COUNT(CASE WHEN h.city_id = c.city_id THEN hb.booking_id END) * 100.0 / COUNT(*) 
        AS same_city_booking_perc
FROM hotel_bookings hb
JOIN customers c ON hb.customer_id = c.customer_id
JOIN hotels h ON hb.hotel_id = h.id
GROUP BY hb.customer_id
ORDER BY same_city_bookings DESC, same_city_booking_perc DESC;
