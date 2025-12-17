/*
01. Female Contribution by Hotel
Calculate the percentage contribution by female customers
in terms of bookings and revenue for each hotel.
*/

SELECT 
    hb.hotel_id,
    ROUND(
        COUNT(CASE WHEN c.gender = 'F' THEN hb.booking_id END) * 100.0 
        / COUNT(*), 
        2
    ) AS female_booking_contribution_perc,
    ROUND(
        SUM(CASE WHEN c.gender = 'F' 
                 THEN hb.number_of_nights * hb.per_night_rate END) * 100.0
        / SUM(hb.number_of_nights * hb.per_night_rate),
        2
    ) AS female_revenue_contribution_perc
FROM hotel_bookings hb
JOIN customers c ON hb.customer_id = c.customer_id
GROUP BY hb.hotel_id;

/*
02. Highest Revenue Booking Channel
For each hotel and each month, find the booking channel
that generated the highest revenue.
*/

WITH channel_revenue AS (
    SELECT 
        hotel_id,
        MONTH(booking_date) AS booking_month,
        booking_channel,
        SUM(number_of_nights * per_night_rate) AS revenue
    FROM hotel_bookings
    GROUP BY hotel_id, MONTH(booking_date), booking_channel
)
SELECT 
    hotel_id,
    booking_month,
    booking_channel
FROM (
    SELECT *,
           RANK() OVER (
               PARTITION BY hotel_id, booking_month 
               ORDER BY revenue DESC
           ) AS rn
    FROM channel_revenue
) ranked
WHERE rn = 1
ORDER BY hotel_id, booking_month;

/*
03. Booking Channel Share
Find the percentage share of total bookings
contributed by each booking channel.
*/

SELECT 
    booking_channel,
    ROUND(
        COUNT(DISTINCT booking_id) * 100.0 /
        (SELECT COUNT(DISTINCT booking_id) FROM hotel_bookings),
        2
    ) AS booking_percentage
FROM hotel_bookings
GROUP BY booking_channel;
