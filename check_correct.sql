-- Проверяем, что все продажи загружены
SELECT COUNT(*) FROM fact_sales;
-- Проверяем, что нет NULL в ключевых полях
SELECT * FROM fact_sales WHERE customer_id IS NULL OR seller_id IS NULL OR product_id IS NULL;