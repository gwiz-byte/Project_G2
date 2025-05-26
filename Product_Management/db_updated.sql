-- Create database
CREATE DATABASE Project_G2;
USE Project_G2;

-- Table for Users
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    password VARCHAR(255),
    phone_number VARCHAR(20),
    address TEXT,
    role ENUM('customer', 'admin', 'staff') DEFAULT 'customer'
);

-- Table for Categories (CPU, GPU, RAM, PSU, etc.)
CREATE TABLE categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) UNIQUE,
    description TEXT
);

-- Table for Products (including specs as JSON)
CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(150),
    category_id INT,
    price DECIMAL(10,2),
    stock INT,
    status ENUM('active', 'inactive') DEFAULT 'active',
    image_url TEXT,
    description TEXT,
    spec_description TEXT, -- JSON containing technical specifications
    FOREIGN KEY (category_id) REFERENCES categories(id)
);

-- Table for Cart Items
CREATE TABLE cart_items (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT, -- Foreign key referencing users table
    product_id INT,
    quantity INT,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- Table for Payment Methods
CREATE TABLE payment_methods (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    description TEXT
);

-- Table for Orders
CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT, -- Foreign key referencing users table
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    total_price DECIMAL(10,2),
    payment_method_id INT, -- Foreign key referencing payment_methods table
    status ENUM('pending', 'shipping', 'completed', 'cancelled') DEFAULT 'pending',
    address TEXT,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (payment_method_id) REFERENCES payment_methods(id)
);

-- Table for Order Details
CREATE TABLE order_details (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT, -- Foreign key referencing orders table
    product_id INT, -- Foreign key referencing products table
    quantity INT,
    item_price DECIMAL(10,2),
    total_price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- Table for Feedback
CREATE TABLE feedback (
    id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT, -- Foreign key referencing products table
    user_id INT, -- Foreign key referencing users table
    rating INT CHECK (rating BETWEEN 1 AND 5),
    content TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Table for Blogs
CREATE TABLE blogs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200),
    content TEXT,
    user_id INT, -- Foreign key referencing users table
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);
