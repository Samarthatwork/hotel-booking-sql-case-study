/*
01. Same-City Bookings by Customers
Find the top 5 customers who made the highest number of bookings
in the same city where they live.
Display the customer ID and the percent of those bookings compared to the total number of bookings done by them.
In case of a tie, prefer the customers with a higher same-city booking percent
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

/*
02. Cross-State Customer Bookings
For each hotel, find the number of bookings made by customers
who visited from a different state.
*/

SELECT 
    hb.hotel_id,
    COUNT(*) AS different_state_bookings
FROM hotel_bookings hb
JOIN hotels h ON hb.hotel_id = h.id
JOIN cities hotel_city ON h.city_id = hotel_city.id
JOIN customers c ON hb.customer_id = c.customer_id
JOIN cities customer_city ON c.city_id = customer_city.id
WHERE hotel_city.state <> customer_city.state
GROUP BY hb.hotel_id
ORDER BY hb.hotel_id;
