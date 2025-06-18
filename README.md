## Car Rental Dashboard – Data Analysis Project Inspired by Turo

The whole project was inspired by the popular peer-to-peer car rental platform Turo. The idea was simple: to use a dataset that simulates real-life business data related to car rentals in order to help users choose the best vehicle to buy and rent out. The analysis was done under different perspectives: price, popularity, renters satisfaction and ROI.

## Project Goal

My goal was to build a Tableau dashboard and support it with strong data analytics in PostgreSQL. This dashboard can help users:

- Find the most rented and highest-rated cars
- Analyze car types by profit potential
- Explore rental performance by location
- Compare daily rental rates and estimated car prices

Also I can not hide the fact that I am passionate about automotive industry, so working on this project was both useful and exciting for me.

## Dataset Overview
The dataset used in this project contains approximately 11,000 rows of rental data. It includes detailed information about 1,992 unique vehicles and covers nearly 400,000 trips taken by renters.

The data simulates a real-world peer-to-peer car rental platform, similar to Turo. Each row includes various attributes like vehicle details, rental prices, user ratings, number of trips, and locations. This makes it possible to perform deep analysis from different perspectives, such as popularity, profitability, and renter satisfaction.

## Database Structure

The original dataset was provided as a single flat table. To improve clarity and support deeper analysis, it was normalized into three relational tables using PostgreSQL best practices:

Table Name	Description
- `vehicles`	Contains all details about the vehicles available for rent (make, model, type, year, etc.)
- `rentals`	Links rental records to a vehicle and location. Also includes rental price, ratings, and review data. Each row can contain multiply number of trips taken depending on the vehicle id and location
- `locations`	Stores rental locations with geographic coordinates and airport city information

This restructuring helps ensure data integrity and simplifies analytical queries, especially for aggregation and reporting dashboards.

## Data Cleaning

First decision was to do a data cleansing stage:
- Fixed inconsistent vehicle types (e.g. replaced general “car” type with sedan, coupe, hatchback, convertible). This task was half-automated by AI
- Fixed duplicate entries in `vehicle_make` like “Mercedes-Benz” vs “Mercedes Benz”
- Filled 75 missing values in `fueltype` based on make & model groups also by using help of AI
- Added an `estimated_car_price` column using AI model predictions

## Data Normalization

The original dataset was a flat table. I normalized it into 3 related tables to follow **3rd Normal Form (3NF)**:

1. **Locations** – city, country, coordinates, and airport city
2. **Vehicles** – make, model, type, year, fueltype, price
3. **Rentals** – trip info, ratings, reviews, daily rate, etc.

[Screenshot of database structure](https://imgur.com/a/nV8zVMU)


## Key Analysis (PostgreSQL)

- Vehicles with the **best average ratings**
- **Popular** vehicles based on number of trips and reviews
- **Profit potential** of vehicle types and makes
- Cities with **highest-rated rentals**
- Most **rented vehicles**
- Ratio between car price and daily rate to find best **investment cars**

I mostly used **median values** instead of averages because of many outliers in the dataset.


## Tools Used

- **PostgreSQL** for SQL queries and data modeling
- **Tableau** for dashboard and visual analytics
- **Excel** for small pre-cleaning steps


## Insights

This dashboard and analysis could be useful for:
- Car owners deciding which car to buy and rent out
- Turo-like platforms to suggest car prices or give market insights
- Data analysts exploring real-world rental business cases


## Files Included

- [`project_queries.sql`](https://github.com/holubvladyslav/Vladyslav-Holub-s-Portfolio/blob/main/project_queries.sql) – all SQL scripts used in the analysis
- [`car_rental_business.twbx`](https://github.com/holubvladyslav/Vladyslav-Holub-s-Portfolio/blob/main/car_rental_business.twbx) – Tableau workbook
- [`car_project.csv`](https://github.com/holubvladyslav/Vladyslav-Holub-s-Portfolio/blob/main/car_project.csv) – cleaned and enriched dataset
- [`README.md`](https://github.com/mrankitgupta/Sales-Insights-Data-Analysis-using-Tableau-and-SQL/blob/main/README.md) – project documentation

## Links
- [Tableau dashboard](https://public.tableau.com/app/profile/vladyslav.holub7989/viz/project_cars_2/Dashboard2)
- [LinkedIn](https://www.linkedin.com/in/vladyslav-holub-67a325248/?originalSubdomain=pl)
