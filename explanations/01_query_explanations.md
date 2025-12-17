# SQL Query Explanations – Hotel Booking Case Study

This document explains the reasoning and approach behind the more complex SQL queries used in this case study.

---

## 1. Cross-State Customer Bookings

To identify bookings made by customers visiting from a different state, the hotel’s city and the customer’s home city are joined separately using the cities table.  
The state values are then compared to filter only cross-state bookings, which are aggregated at the hotel level.

This approach ensures accurate geographic comparison without duplicating city data.

---

## 2. Monthly Occupancy Rate Calculation

Occupancy is calculated by expanding each booking into individual stay dates using a recursive CTE.  
Each stay date represents a day when the customer occupies a room.

Daily guest counts are aggregated per hotel and joined with the hotel’s capacity.  
Monthly occupancy is then derived using window functions to sum daily guests and capacity across each month.

This method accurately reflects real-world hotel occupancy behavior.

---

## 3. Fully Occupied Dates

Once daily occupancy is calculated, fully occupied dates are identified by comparing daily guest counts with hotel capacity.  
Dates where these values match indicate that all rooms were booked.

This logic directly supports operational capacity analysis.

---

## 4. Peak Occupancy Date per Hotel

After computing daily occupancy, window functions are used to rank dates based on guest count for each hotel.  
The highest-ranked date represents the peak occupancy day.

This avoids incorrect aggregation and preserves day-level accuracy.

---

## 5. Multi-Hotel Stays in the Same Month

Customer stays are grouped by customer and month to calculate the number of distinct hotels visited.  
Only customer-month combinations with three or more distinct hotels are retained.

This approach captures high-mobility customer behavior within a defined time window.

---

## 6. Revenue by Generation

Customer date of birth is converted from VARCHAR to DATE format to classify customers into generational cohorts.  
Conditional aggregation is used to calculate revenue separately for Millennials and Gen Z customers.

This enables demographic-based revenue analysis without duplicating data.
