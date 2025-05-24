-- Вставляем продажи
INSERT INTO fact_sales (sale_date, customer_id, seller_id, product_id, store_id, quantity, total_price)
SELECT 
    sale_date::DATE,
    (SELECT customer_id FROM dim_customers 
     WHERE first_name = customer_first_name AND last_name = customer_last_name LIMIT 1),
    (SELECT seller_id FROM dim_sellers 
     WHERE first_name = seller_first_name AND last_name = seller_last_name LIMIT 1),
    (SELECT product_id FROM dim_products WHERE product_name = raw_data.product_name LIMIT 1),
    (SELECT store_id FROM dim_stores WHERE store_name = raw_data.store_name LIMIT 1),
    sale_quantity,
    sale_total_price
FROM raw_data;