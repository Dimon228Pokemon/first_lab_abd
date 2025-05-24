--Страны 
CREATE TABLE dim_countries (
    country_id SERIAL PRIMARY KEY,
    country_name VARCHAR(100) UNIQUE NOT NULL
);


--Типы питомцев
CREATE TABLE dim_pet_types (
    pet_type_id SERIAL PRIMARY KEY,
    pet_type_name VARCHAR(50) UNIQUE NOT NULL 
);

--Породы питомцев
CREATE TABLE dim_pet_breeds (
    pet_breed_id SERIAL PRIMARY KEY,
    pet_breed_name VARCHAR(100) UNIQUE NOT NULL
);

--Категории товаров
CREATE TABLE dim_product_categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) UNIQUE NOT NULL
);

--Цвета товаров
CREATE TABLE dim_colors (
    color_id SERIAL PRIMARY KEY,
    color_name VARCHAR(50) UNIQUE NOT NULL 
);

--Бренды товаров
CREATE TABLE dim_brands (
    brand_id SERIAL PRIMARY KEY,
    brand_name VARCHAR(100) UNIQUE NOT NULL 
);


--Материалы товаров
CREATE TABLE dim_materials (
    material_id SERIAL PRIMARY KEY,
    material_name VARCHAR(100) UNIQUE NOT NULL 
);

--Города
CREATE TABLE dim_cities (
    city_id SERIAL PRIMARY KEY,
    city_name VARCHAR(100) NOT NULL,
    state VARCHAR(100),
    country_id INT REFERENCES dim_countries(country_id),
    UNIQUE (city_name, state, country_id)
);


--Поставщики
CREATE TABLE dim_suppliers (
    supplier_id SERIAL PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL,
    contact_person VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(50),
    address VARCHAR(200),
    city_id INT REFERENCES dim_cities(city_id)
);

--Магазины
CREATE TABLE dim_stores (
    store_id SERIAL PRIMARY KEY,
    store_name VARCHAR(100) NOT NULL,
    location VARCHAR(200),
    city_id INT REFERENCES dim_cities(city_id),
    phone VARCHAR(50),
    email VARCHAR(100)
);

--Продавцы
CREATE TABLE dim_sellers (
    seller_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100),
    postal_code VARCHAR(20),
    country_id INT REFERENCES dim_countries(country_id)
);


--Покупатели
CREATE TABLE dim_customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    age INT,
    email VARCHAR(100),
    postal_code VARCHAR(20),
    pet_type_id INT REFERENCES dim_pet_types(pet_type_id),
    pet_name VARCHAR(50),
    pet_breed_id INT REFERENCES dim_pet_breeds(pet_breed_id),
    country_id INT REFERENCES dim_countries(country_id)
);

--Продукты
CREATE TABLE dim_products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(200) NOT NULL,
    category_id INT REFERENCES dim_product_categories(category_id),
    price DECIMAL(10, 2) NOT NULL,
    weight DECIMAL(10, 2),
    color_id INT REFERENCES dim_colors(color_id),
    size VARCHAR(20),
    brand_id INT REFERENCES dim_brands(brand_id),
    material_id INT REFERENCES dim_materials(material_id),
    description TEXT,
    rating DECIMAL(3, 1),
    reviews INT,
    release_date DATE,
    expiry_date DATE,
    supplier_id INT REFERENCES dim_suppliers(supplier_id)
);