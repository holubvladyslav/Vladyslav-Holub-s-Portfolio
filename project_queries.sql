-- Car Rental Data Analysis Project – PostgreSQL Queries

-- This SQL file includes all queries used in the data analysis
-- for the car rental project inspired by Turo.
-- The goal of this project is to find valuable insights about
-- car performance, rental trends, pricing, and location popularity.

-- The queries cover:
-- 1. Basic Descriptive Statistics
-- 2. Average Daily Rate, Estimated Price, and the Ratio Between Them by Vehicle Type
-- 3. Vehicles with the Best Average Ratings
-- 4. Most popular vehicles considering number of reviews
-- 5. Most Profitable Vehicle Makes
-- 6. Highest Rental Potential Among Vehicle Types
-- 7. Locations by Highest Average Rating
-- 8. Most Renters Trips Vehicles

-- The database was normalized into 3 tables:
-- - locations
-- - vehicles
-- - rentals

-- Median calculations were used instead of average in many places
-- due to outliers in pricing data.

-- All queries were written and tested in PostgreSQL

-- SQL Database Schema Description
-- --------------------------------
-- Table: vehicles
-- Description: Contains unique vehicle-level attributes.
-- Columns:
--   vehicle_id           - INTEGER, Primary key (auto-incremented ID)
--   vehicle_make         - VARCHAR(60), Car manufacturer (e.g., Toyota, BMW)
--   vehicle_model        - VARCHAR(60), Specific model of the vehicle
--   vehicle_type         - VARCHAR(30), Type/category (SUV, sedan, convertible, etc.)
--   vehicle_year         - SMALLINT, Year of production (e.g., 2018)
--   fueltype             - VARCHAR(20), Type of fuel used (gasoline, electric, hybrid, etc.)
--   estimated_car_price  - NUMERIC(10,2), Estimated value of the vehicle in USD (e.g., 27500.00)

-- Table: rentals
-- Description: Stores rental-related data linked to vehicles and locations.
-- Columns:
--   rental_id            - INTEGER, Primary key (unique rental record ID)
--   owner_id             - INTEGER, ID of the vehicle owner
--   vehicle_id           - INTEGER, Foreign key referencing vehicles(vehicle_id)
--   location_id          - INTEGER, Foreign key referencing locations(location_id)
--   rate_daily           - NUMERIC(15,2), Daily rental price in USD (e.g., 85.00)
--   rating               - NUMERIC(5,2), Customer satisfaction rating (e.g., 4.65)
--   rentertripstaken     - INTEGER, Total number of trips taken by renters
--   reviewcount          - INTEGER, Number of reviews for the rental

-- Table: locations
-- Description: Stores unique rental location details.
-- Columns:
--   location_id          - INTEGER, Primary key (unique location identifier)
--   location_city        - VARCHAR(100), City where the vehicle is located (e.g., Los Angeles)
--   location_country     - CHAR(2), 2-letter ISO country code (e.g., US, CA)
--   location_latitude    - NUMERIC(9,6), Latitude coordinate (e.g., 34.052235)
--   location_longitude   - NUMERIC(9,6), Longitude coordinate (e.g., -118.243683)
--   airport_city         - VARCHAR(100), Closest airport city (useful for travel rentals)

-- Basic Descriptive Statistics

-- In this task, I wanted to understand how different car models perform
-- in terms of user rating, total trips taken, and number of reviews.
-- I grouped the data by vehicle make and model, then calculated the average rating,
-- average number of trips, and average review count for each group.
-- This gives a general overview of how popular and well-rated different car models are.

SELECT 

  vehicle_make,
  
  vehicle_model,
  
  ROUND(AVG(rating), 2) as avg_rating,
  
  ROUND(SUM(rentertripstaken) / COUNT(*)) as avg_trips,
  
  ROUND(AVG(reviewcount), 2) as avg_reviewcount

FROM rentals r

JOIN vehicles v

  ON v.vehicle_id = r.vehicle_id

GROUP BY vehicle_make, vehicle_model

ORDER BY avg_trips DESC, avg_rating DESC, avg_reviewcount DESC;



-- Average Daily Rate, Estimated Price, and the Ratio Between Them by Vehicle Type

-- In this task, I decided to use median values instead of averages,
-- because the dataset contains outliers, which was clear after checking the max and min values
-- of the estimated car prices.

SELECT

  vehicle_type,

  ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY rate_daily)::NUMERIC, 2) AS median_daily_rate,

  ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY estimated_car_price)::NUMERIC, 2) AS median_car_price,

  ROUND((PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY rate_daily) / PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY estimated_car_price))::NUMERIC, 5) AS price_ratio,

  ROUND((PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY estimated_car_price) / PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY rate_daily))::NUMERIC, 2) AS days_to_recoup

FROM rentals r

JOIN vehicles v 
  ON v.vehicle_id = r.vehicle_id

WHERE rentertripstaken IS NOT NULL

 AND rate_daily IS NOT NULL

 AND estimated_car_price IS NOT NULL

GROUP BY vehicle_type

ORDER BY median_daily_rate DESC;


-- Vehicles with the Best Average Ratings

-- This task was focused on identifying vehicles with the highest overall rating.
-- To make the results more meaningful, I calculated a weighted score using both
-- the average rating and the total number of trips.
-- The idea was to combine customer satisfaction with vehicle usage to rank the top cars.
-- A vehicle with a good rating and many rentals is more trustworthy than one with just a few reviews.

SELECT

  vehicle_make,
  
  vehicle_model,
  
  ROUND(AVG(rating),3) as avg_rating,
  
  SUM(rentertripstaken) as rentertripstaken,
  
  ROUND(AVG(rating)*0.5 + SUM(rentertripstaken)*0.5, 2) as weighted_score

FROM vehicles v

JOIN rentals r

  ON r.vehicle_id = v.vehicle_id

WHERE rating IS NOT NULL

GROUP BY vehicle_make, vehicle_model

ORDER BY weighted_score DESC;


-- Most popular vehicles considering number of reviews

-- Here, I tried to find the most popular vehicles based on how many reviews they received.
-- More reviews often mean the vehicle is rented often and has wide user engagement.
-- I also included average rating to show whether popularity comes with customer satisfaction.
-- The result highlights the car models that are not only frequently rented but also well-reviewed.

SELECT 

  vehicle_make,
  
  vehicle_model,
  
  SUM(reviewcount) as sum_reviewcount,
  
  ROUND(AVG(rating), 2) as avg_rating

FROM rentals r

JOIN vehicles v

  ON v.vehicle_id = r.vehicle_id

GROUP BY vehicle_make, vehicle_model

ORDER BY sum_reviewcount DESC;


-- Most Profitable Vehicle Makes

-- To solve this task, I also decided to use medians instead of averages,
-- because the dataset contains many outliers in the 'estimated_car_price' column.
-- This query calculates the median daily rate, median car price, and the ratio between them.
-- Finally, it also shows how many days a customer would need to recoup their investment 
-- for different vehicle makes.

SELECT 

  vehicle_make,
  
  ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY rate_daily)::numeric, 2) AS median_rate_daily,
  
  ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY estimated_car_price)::numeric, 2) AS median_car_price,
  
  ROUND(PERCENTILE_CONT (0.5) WITHIN GROUP (ORDER BY rate_daily)::numeric / 
  
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY estimated_car_price)::numeric, 5) AS rate_price_ratio,
  
  ROUND(PERCENTILE_CONT (0.5) WITHIN GROUP (ORDER BY estimated_car_price)::numeric / 
  
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY rate_daily)::numeric, 2) AS days_to_recoup

FROM rentals r

JOIN vehicles v

  ON v.vehicle_id = r.vehicle_id

GROUP BY vehicle_make

ORDER BY rate_price_ratio DESC;


-- Highest Rental Potential Among Vehicle Types

-- In this task, I decided to find the vehicle types with the best rental potential,
-- based on the average number of rental trips and daily rates.
-- The logic is simple: the higher the number of trips and the daily rate, the better the rental potential.
-- So, I first calculated the average values of those columns by vehicle type,
-- then ranked them based on these values, and finally applied a scoring system
-- (60% weight for review count and 40% for daily rate)
-- to identify the top 5 vehicle types with the highest rental potential.


WITH averages AS (

   SELECT 

    vehicle_type,
    
    ROUND(AVG(rate_daily), 2) as avg_rate_daily,
    
    ROUND(AVG(rentertripstaken), 2) as avg_rentertripstaken

  FROM vehicles v

  JOIN rentals r 

    ON r.vehicle_id = v.vehicle_id

  GROUP BY vehicle_type

),



ranks AS (

 SELECT 

  vehicle_type,
  
  avg_rate_daily,
  
  RANK() OVER(ORDER BY avg_rate_daily DESC) as rate_rank,
  
  avg_rentertripstaken,
  
  RANK() OVER(ORDER BY avg_rentertripstaken DESC) as trips_rank

 FROM averages

)



SELECT

  vehicle_type,

  (rate_rank * 0.4 + trips_rank * 0.6) as weighted_score

FROM ranks

ORDER BY weighted_score ASC;


-- Locations by Highest Average Rating

-- This task focused on analyzing which cities had the highest-rated vehicles overall.
-- I grouped the data by city and used a weighted average formula based on rating and number of reviews,
-- to avoid giving too much value to vehicles with just a few reviews.
-- I also filtered out cities with fewer than 30 vehicles to make the results more reliable.
-- The final result shows which locations offer the best rental experiences.

WITH location_stats AS (

 SELECT 

  lo.location_city,

  COUNT(DISTINCT re.vehicle_id) AS veh_count,

  SUM(re.rating * re.reviewcount) AS weighted_rating_sum,

  SUM(re.reviewcount) AS total_reviewcount

 FROM rentals re

 JOIN locations lo ON lo.location_id = re.location_id

 WHERE re.rating IS NOT NULL 

  AND re.reviewcount IS NOT NULL

 GROUP BY lo.location_city

)


SELECT 

  location_city,

  ROUND(weighted_rating_sum::numeric / NULLIF(total_reviewcount, 0), 2) AS avg_rating,

  veh_count

FROM location_stats

WHERE veh_count >= 30

ORDER BY avg_rating DESC;



-- Most Renters Trips Vehicles

-- The goal of this task was to find the vehicles with the highest number of total rental trips.
-- I summed the number of trips for each vehicle and sorted the results in descending order.
-- This allows us to see which exact cars (not just make or model) are the most rented ones.
-- It's useful for identifying high-demand vehicles that perform well in the rental market.

WITH rentals_count AS(

 SELECT 

  vehicle_id,

  SUM(rentertripstaken) as rentals_count

 FROM rentals

 GROUP BY vehicle_id

)



  SELECT 
    ve.vehicle_id,
    
     vehicle_make,
    
     vehicle_model,
    
     vehicle_type,
    
     vehicle_year,
    
     fueltype,
    
     rentals_count
  
  FROM rentals_count rc
  
  JOIN vehicles ve
  
    ON ve.vehicle_id = rc.vehicle_id
  
  ORDER BY rentals_count DESC;
