CREATE DATABASE IF NOT EXISTS bigbasket_db;
USE bigbasket_db;

DROP TABLE IF EXISTS products;
CREATE TABLE products (
    product_id       INT,
    product          VARCHAR(255),
    category         VARCHAR(100),
    sub_category     VARCHAR(100),
    brand            VARCHAR(100),
    sale_price       DECIMAL(10,2),
    market_price     DECIMAL(10,2),
    product_type     VARCHAR(100),
    rating           DECIMAL(2,1) NULL,
    discount_amount  DECIMAL(10,2),
    discount_pct     DECIMAL(5,2),
    is_discounted    TINYINT,
    price_band       VARCHAR(30),
    discount_band    VARCHAR(30),
    rating_band      VARCHAR(30),
    has_rating       TINYINT,
    brand_type       VARCHAR(30)
);



CREATE TABLE products_raw (
    product_id VARCHAR(20),
    product VARCHAR(255),
    category VARCHAR(100),
    sub_category VARCHAR(100),
    brand VARCHAR(100),
    sale_price VARCHAR(30),
    market_price VARCHAR(30),
    product_type VARCHAR(100),
    rating VARCHAR(10),
    discount_amount VARCHAR(30),
    discount_pct VARCHAR(30),
    is_discounted VARCHAR(5),
    price_band VARCHAR(30),
    discount_band VARCHAR(30),
    rating_band VARCHAR(30),
    has_rating VARCHAR(5),
    brand_type VARCHAR(30)
);


select * from products;

select * from products_raw;



SELECT COUNT(*) AS rows_in_raw FROM products_raw;


INSERT INTO products
SELECT product_id, product, category, sub_category, brand,
       sale_price, market_price, product_type,
       NULLIF(rating, ''),
       discount_amount, discount_pct, is_discounted,
       price_band, discount_band,
       NULLIF(rating_band, ''),
       has_rating, brand_type
FROM products_raw;

select * from products;


SELECT COUNT(*) AS total_rows, SUM(rating IS NULL) AS products_without_rating
FROM products;

-- 1 HOW MANY PRODUCTS ARE IN THE TABLE ? 

SELECT COUNT(*) AS total_products
FROM products;

--  2 SHOW ME THE FIRST 10 PRODUCTS ?

SELECT *
FROM products
LIMIT 10;

-- 3 WHICH CATEGORIES ARE THEIR ? 

SELECT DISTINCT category
FROM products;

-- 4  HOW MANY PRODUCTS DOES EACH CATEGORIES HAVE ? 

SELECT category, COUNT(*) AS total_products
FROM products
GROUP BY category
ORDER BY total_products DESC;

-- 5 WHAT IS THE AVERAGE PRICE OF EACH CATEGORIES?

SELECT category, ROUND(AVG(sale_price), 1) AS avg_price
FROM products
GROUP BY category
ORDER BY avg_price DESC;

-- 6 WHAT IS THE AVERAGE DISCOUNT OF EACH CATEGORIES?

SELECT category, ROUND(AVG(discount_pct), 1) AS avg_discount_pct
FROM products
GROUP BY category
ORDER BY avg_discount_pct DESC;

-- 7 WHAT IS THE AVERAGE RATING OF EACH CATEGORIES ? 

SELECT category, ROUND(AVG(rating), 2) AS avg_rating
FROM products
GROUP BY category
ORDER BY avg_rating DESC;

-- 8 WHICH ARE THE TOP 10 BRANDS ? 

SELECT brand, COUNT(*) AS total_products
FROM products
GROUP BY brand
ORDER BY total_products DESC
LIMIT 10;

-- 9 Which products have a discount of more than 40%?

SELECT product, brand, market_price, sale_price, discount_pct
FROM products
WHERE discount_pct > 40
ORDER BY discount_pct DESC
LIMIT 10;

-- 10  HOW DO BIGBASKET'S OWN BRANDS COMPARE WITH THIRD-PARTY BRANDS ? 

SELECT brand_type,
       COUNT(*) AS total_products,
       ROUND(AVG(sale_price), 1) AS avg_price,
       ROUND(AVG(discount_pct), 1) AS avg_discount_pct,
       ROUND(AVG(rating), 2) AS avg_rating
FROM products
GROUP BY brand_type;

-- 11 HOW MANY PRODUCTS ARE IN EACH PRICE BAND ?  

SELECT price_band, COUNT(*) AS total_products
FROM products
GROUP BY price_band
ORDER BY total_products DESC;

-- 12 WHICH CATEGORIES HAVE NO RATING ? 

SELECT category, COUNT(rating) AS products_with_rating
FROM products
GROUP BY category
ORDER BY products_with_rating ASC;

-- 13 WHHICH EXPENSIVE PRODUCTS (PRICE ABOVE 500) HAVE A LOW RATING (BELOW 3.5)?

SELECT product, brand, sale_price, rating
FROM products
WHERE sale_price > 500 AND rating < 3.5
ORDER BY sale_price DESC
LIMIT 10;

-- 14 DOES A BIGGER DISCOUNT MEAN A BETTER RATING ? 

SELECT discount_band, ROUND(AVG(rating), 2) AS avg_rating
FROM products
GROUP BY discount_band
ORDER BY avg_rating DESC;

-----------------------------------------------------------------------------------------------------------------------------------------------------










