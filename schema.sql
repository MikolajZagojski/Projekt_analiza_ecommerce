-- Tworzenie tabeli użytkowników
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(255),
    age INT,
    gender CHAR(1),
    state VARCHAR(100),
    street_address TEXT,
    postal_code VARCHAR(20),
    city VARCHAR(100),
    country VARCHAR(100),
    latitude FLOAT,
    longitude FLOAT,
    traffic_source VARCHAR(50),
    created_at TIMESTAMP,
    user_geom TEXT -- lub GEOMETRY jeśli używasz PostGIS
);

-- Tworzenie tabeli produktów
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    cost NUMERIC(10, 2),
    category VARCHAR(100),
    name TEXT,
    brand VARCHAR(100),
    retail_price NUMERIC(10, 2),
    department VARCHAR(50),
    sku TEXT,
    distribution_center_id INT
);

-- Tworzenie tabeli zamówień
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id),
    status VARCHAR(50),
    gender CHAR(1),
    created_at TIMESTAMP,
    returned_at TIMESTAMP,
    shipped_at TIMESTAMP,
    delivered_at TIMESTAMP,
    num_of_item INT
);

-- Tworzenie tabeli pozycji zamówienia
CREATE TABLE order_items (
    id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    user_id INT REFERENCES users(id),
    product_id INT REFERENCES products(id),
    inventory_item_id INT,
    status VARCHAR(50),
    created_at TIMESTAMP,
    shipped_at TIMESTAMP,
    delivered_at TIMESTAMP,
    returned_at TIMESTAMP,
    sale_price NUMERIC(10, 2)
);