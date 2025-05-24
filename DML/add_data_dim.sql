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

-- Вставляем города (связь с странами через JOIN)
INSERT INTO dim_cities (city_name, state, country_id)
SELECT DISTINCT 
    r.store_city, 
    r.store_state, 
    c.country_id
FROM 
    raw_data r
JOIN 
    dim_countries c ON r.store_country = c.country_name
WHERE 
    r.store_city IS NOT NULL;

-- Вставляем поставщиков 
INSERT INTO dim_suppliers (supplier_name, contact_person, email, phone, address, city_id)
SELECT DISTINCT 
    r.supplier_name,
    r.supplier_contact,
    r.supplier_email,
    r.supplier_phone,
    r.supplier_address,
    c.city_id
FROM 
    raw_data r
JOIN 
    dim_cities c ON r.supplier_city = c.city_name
WHERE 
    r.supplier_name IS NOT NULL;

-- Вставляем магазины 
INSERT INTO dim_stores (store_name, location, city_id, phone, email)
SELECT DISTINCT 
    r.store_name,
    r.store_location,
    c.city_id,
    r.store_phone,
    r.store_email
FROM 
    raw_data r
JOIN 
    dim_cities c ON r.store_city = c.city_name
WHERE 
    r.store_name IS NOT NULL;

-- Вставляем продавцов 
INSERT INTO dim_sellers (first_name, last_name, email, postal_code, country_id)
SELECT DISTINCT 
    r.seller_first_name,
    r.seller_last_name,
    r.seller_email,
    r.seller_postal_code,
    c.country_id
FROM 
    raw_data r
JOIN 
    dim_countries c ON r.seller_country = c.country_name
WHERE 
    r.seller_first_name IS NOT NULL;

-- Вставляем покупателей
INSERT INTO dim_customers (first_name, last_name, age, email, postal_code, pet_type_id, pet_name, pet_breed_id, country_id)
SELECT DISTINCT 
    r.customer_first_name,
    r.customer_last_name,
    r.customer_age,
    r.customer_email,
    r.customer_postal_code,
    pt.pet_type_id,
    r.customer_pet_name,
    pb.pet_breed_id,
    c.country_id
FROM 
    raw_data r
JOIN 
    dim_countries c ON r.customer_country = c.country_name
JOIN 
    dim_pet_types pt ON r.customer_pet_type = pt.pet_type_name
JOIN 
    dim_pet_breeds pb ON r.customer_pet_breed = pb.pet_breed_name
WHERE 
    r.customer_first_name IS NOT NULL;

-- Вставляем продукты 
INSERT INTO dim_products (
    product_name, category_id, price, weight, color_id, size, brand_id, material_id, 
    description, rating, reviews, release_date, expiry_date, supplier_id
)
SELECT DISTINCT 
    r.product_name,
    pc.category_id,
    r.product_price,
    r.product_weight,
    cl.color_id,
    r.product_size,
    b.brand_id,
    m.material_id,
    r.product_description,
    r.product_rating,
    r.product_reviews,
    r.product_release_date::DATE,
    r.product_expiry_date::DATE,
    s.supplier_id
FROM 
    raw_data r
LEFT JOIN dim_product_categories pc ON r.product_category = pc.category_name
LEFT JOIN dim_colors cl ON r.product_color = cl.color_name
LEFT JOIN dim_brands b ON r.product_brand = b.brand_name
LEFT JOIN dim_materials m ON r.product_material = m.material_name
LEFT JOIN dim_suppliers s ON r.supplier_name = s.supplier_name
WHERE 
    r.product_name IS NOT NULL;