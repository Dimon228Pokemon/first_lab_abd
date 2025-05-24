-- Вставляем страны (уникальные значения)
INSERT INTO dim_countries (country_name)
SELECT DISTINCT customer_country FROM raw_data
UNION
SELECT DISTINCT seller_country FROM raw_data
UNION
SELECT DISTINCT store_country FROM raw_data
UNION
SELECT DISTINCT supplier_country FROM raw_data;

-- Вставляем типы питомцев
INSERT INTO dim_pet_types (pet_type_name)
SELECT DISTINCT customer_pet_type FROM raw_data;

-- Вставляем породы питомцев
INSERT INTO dim_pet_breeds (pet_breed_name)
SELECT DISTINCT customer_pet_breed FROM raw_data;

-- Вставляем категории товаров
INSERT INTO dim_product_categories (category_name)
SELECT DISTINCT product_category FROM raw_data;

-- Вставляем цвета товаров
INSERT INTO dim_colors (color_name)
SELECT DISTINCT product_color FROM raw_data;

-- Вставляем бренды товаров
INSERT INTO dim_brands (brand_name)
SELECT DISTINCT product_brand FROM raw_data;

-- Вставляем материалы товаров
INSERT INTO dim_materials (material_name)
SELECT DISTINCT product_material FROM raw_data;

-- Вставляем города (связь с странами)
INSERT INTO dim_cities (city_name, state, country_id)
SELECT DISTINCT 
    store_city, 
    store_state, 
    (SELECT country_id FROM dim_countries WHERE country_name = store_country)
FROM raw_data
WHERE store_city IS NOT NULL;

-- Вставляем поставщиков
INSERT INTO dim_suppliers (supplier_name, contact_person, email, phone, address, city_id)
SELECT DISTINCT 
    supplier_name,
    supplier_contact,
    supplier_email,
    supplier_phone,
    supplier_address,
    (SELECT city_id FROM dim_cities WHERE city_name = supplier_city LIMIT 1)
FROM raw_data;

-- Вставляем магазины
INSERT INTO dim_stores (store_name, location, city_id, phone, email)
SELECT DISTINCT 
    store_name,
    store_location,
    (SELECT city_id FROM dim_cities WHERE city_name = store_city LIMIT 1),
    store_phone,
    store_email
FROM raw_data;

-- Вставляем продавцов
INSERT INTO dim_sellers (first_name, last_name, email, postal_code, country_id)
SELECT DISTINCT 
    seller_first_name,
    seller_last_name,
    seller_email,
    seller_postal_code,
    (SELECT country_id FROM dim_countries WHERE country_name = seller_country)
FROM raw_data;

-- Вставляем покупателей
INSERT INTO dim_customers (first_name, last_name, age, email, postal_code, pet_type_id, pet_name, pet_breed_id, country_id)
SELECT DISTINCT 
    customer_first_name,
    customer_last_name,
    customer_age,
    customer_email,
    customer_postal_code,
    (SELECT pet_type_id FROM dim_pet_types WHERE pet_type_name = customer_pet_type),
    customer_pet_name,
    (SELECT pet_breed_id FROM dim_pet_breeds WHERE pet_breed_name = customer_pet_breed),
    (SELECT country_id FROM dim_countries WHERE country_name = customer_country)
FROM raw_data;

-- Вставляем продукты
INSERT INTO dim_products (
    product_name, category_id, price, weight, color_id, size, brand_id, material_id, 
    description, rating, reviews, release_date, expiry_date, supplier_id
)
SELECT DISTINCT 
    product_name,
    (SELECT category_id FROM dim_product_categories WHERE category_name = product_category),
    product_price,
    product_weight,
    (SELECT color_id FROM dim_colors WHERE color_name = product_color),
    product_size,
    (SELECT brand_id FROM dim_brands WHERE brand_name = product_brand),
    (SELECT material_id FROM dim_materials WHERE material_name = product_material),
    product_description,
    product_rating,
    product_reviews,
    product_release_date::DATE,
    product_expiry_date::DATE,
    (SELECT supplier_id FROM dim_suppliers WHERE supplier_name = raw_data.supplier_name LIMIT 1)
FROM raw_data;