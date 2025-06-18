## Car Rental Dashboard – Data Analysis Project Inspired by Turo

The whole project was inspired by the popular peer-to-peer car rental platform Turo. The idea was simple: to use a dataset that simulates real-life business data related to car rentals in order to help users choose the best vehicle to buy and rent out. The analysis was done under different perspectives: price, popularity, renters satisfaction and ROI.

## Project Goal

My goal was to build a Tableau dashboard and support it with strong data analytics in PostgreSQL. This dashboard can help users:

- Find the most rented and highest-rated cars
- Analyze car types by profit potential
- Explore rental performance by location
- Compare daily rental rates and estimated car prices

Also I can not hide the fact that I am passionate about automotive industry, so working on this project was both useful and also exciting for me.

## Data Cleaning

First decision was to do data cleansing stage:
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

- `project_queries.sql` – all SQL scripts used in the analysis
- `dashboard.twbx` – Tableau workbook
- `data_cleaned.csv` – cleaned and enriched dataset
- `README.md` – project documentation


## About Me

I’m a data analyst who enjoys working with real-world datasets, especially in fields that I personally like – such as **automotive** and **consumer behavior**. This project helped me grow in data modeling, writing advanced SQL, and visual storytelling with Tableau.

Thanks for visiting! 🙌
