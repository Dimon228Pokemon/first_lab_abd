-- Вставляем продажи
INSERT INTO fact_sales (sale_date, customer_id, seller_id, product_id, store_id, quantity, total_price)
SELECT 
    r.sale_date::DATE,
    c.customer_id,
    s.seller_id,
    p.product_id,
    st.store_id,
    r.sale_quantity,
    r.sale_total_price
FROM 
    raw_data r
JOIN dim_customers c ON r.customer_first_name = c.first_name AND r.customer_last_name = c.last_name
JOIN dim_sellers s ON r.seller_first_name = s.first_name AND r.seller_last_name = s.last_name
JOIN dim_products p ON r.product_name = p.product_name
JOIN dim_stores st ON r.store_name = st.store_name;