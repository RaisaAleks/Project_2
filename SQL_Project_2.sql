--1
CREATE TABLE IF NOT EXISTS airbnb_data (
    id Integer PRIMARY KEY,
    name TEXT,
    host_id Bigint,
    host_identity_verified TEXT,
    host_name TEXT,
    neighbourhood_group TEXT,
    neighbourhood TEXT,
    lat Real,  
    long Real,  
    instant_bookable TEXT,
    cancellation_policy TEXT,
    room_type TEXT,
    construction_year Real,  
    price Real,  
    service_fee Real,  
    minimum_nights Real,  
    number_of_reviews Real,  
    last_review date, 
    reviews_per_month Real, 
    review_rate_number Real, 
    calculated_host_listings_count Real, 
    availability_365 Real,  
    house_rules TEXT
);

--2
CREATE TABLE airbnb_data_averages AS
SELECT
    AVG(price) AS avg_price,
    AVG(service_fee) AS avg_service_fee,
    AVG(minimum_nights) AS avg_minimum_nights,
    AVG(number_of_reviews) AS avg_number_of_reviews,
    AVG(reviews_per_month) AS avg_reviews_per_month,
    AVG(review_rate_number) AS avg_review_rate_number,
    AVG(calculated_host_listings_count) AS avg_calculated_host_listings_count,
    AVG(availability_365) AS avg_availability_365
FROM airbnb_data;

--3
CREATE TABLE neighbourhood_counts AS
SELECT
    neighbourhood,
    COUNT(*) AS neighbourhood_count
FROM airbnb_data
GROUP BY neighbourhood;

--4
CREATE TABLE neighbourhood_price_service_fee_stats AS
SELECT
    neighbourhood,
    MIN(price) AS min_price,
    AVG(price) AS avg_price,
    MAX(price) AS max_price,
    MIN(service_fee) AS min_service_fee,
    AVG(service_fee) AS avg_service_fee,
    MAX(service_fee) AS max_service_fee
FROM airbnb_data
GROUP BY neighbourhood;

--5
CREATE TABLE neighbourhood_group_price_service_fee_stats AS
SELECT
    neighbourhood_group,
    MIN(price) AS min_price,
    AVG(price) AS avg_price,
    MAX(price) AS max_price,
    MIN(service_fee) AS min_service_fee,
    AVG(service_fee) AS avg_service_fee,
    MAX(service_fee) AS max_service_fee
FROM airbnb_data
GROUP BY neighbourhood_group;

--6
CREATE TABLE neighbourhood_group_counts AS
SELECT
    neighbourhood_group,
    COUNT(*) AS neighbourhood_group_count
FROM airbnb_data
GROUP BY neighbourhood_group;

--7
CREATE TABLE neighbourhood_popularity AS
SELECT
    neighbourhood_group,
    neighbourhood,
    COUNT(*) AS reservation_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS reservation_percentage
FROM airbnb_data
GROUP BY neighbourhood_group, neighbourhood;

--8
CREATE TABLE apartments_by_construction_year AS
SELECT
    construction_year,
    COUNT(*) AS number_of_apartments,
    AVG(price) AS avg_price,
    AVG(service_fee) AS avg_service_fee
FROM airbnb_data
GROUP BY construction_year
ORDER BY construction_year;

--9
CREATE TABLE reviews_summary AS
SELECT
    neighbourhood_group,
    neighbourhood,
    room_type,
    construction_year,
    price,
    service_fee,
    AVG(number_of_reviews) AS avg_number_of_reviews,
    MAX(last_review) AS last_review, -- This gets the most recent review date
    AVG(review_rate_number) AS avg_review_rate_number
FROM airbnb_data
GROUP BY
    neighbourhood_group,
    neighbourhood,
    room_type,
    construction_year,
    price,
    service_fee;

--10

CREATE TABLE neighbourhood_group_avg_availability AS
SELECT
    neighbourhood_group,
    AVG(availability_365) AS avg_availability
FROM airbnb_data
GROUP BY neighbourhood_group
ORDER BY avg_availability DESC;

--11
CREATE TABLE neighbourhood_avg_availability AS
SELECT
    neighbourhood,
    AVG(availability_365) AS avg_availability
FROM airbnb_data
GROUP BY neighbourhood
ORDER BY avg_availability DESC;

--12

CREATE TABLE room_type_summary AS
SELECT
    room_type,
    COUNT(*) AS room_type_count,
    AVG(price) AS avg_price,
    MIN(price) AS min_price,
    MAX(price) AS max_price,
    AVG(service_fee) AS avg_service_fee,
    (SELECT MIN(service_fee) FROM airbnb_data WHERE service_fee > 0 AND room_type = rt.room_type) AS min_service_fee,
    MAX(service_fee) AS max_service_fee
FROM airbnb_data rt
GROUP BY room_type
ORDER BY room_type_count DESC;







