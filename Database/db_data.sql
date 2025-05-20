USE Project_G2;
GO

-- Note: In a real environment, PASSWORDS should be HASHED before storing in the database.
-- The data below is for illustrative purposes only.

-- Insert data into users table
PRINT 'Inserting data into users...';
INSERT INTO users (name, email, password, phone_number, address, role) VALUES
('John Doe', 'johndoe@example.com', 'abc123123', '0901234567', '123 ABC Street, District 1, HCMC', 'customer'),
('Jane Smith', 'janesmith@example.com', 'abc123123', '0918765432', '456 XYZ Avenue, Binh Thanh District, HCMC', 'customer'),
('Peter Jones (Admin)', 'peterj_admin@example.com', 'abc123123', '0987654321', '100 Admin Road, District 5, HCMC', 'admin'),
('Mary Brown', 'maryb@example.com', 'abc123123', '0369852147', '789 EFG Lane, Cau Giay District, Hanoi', 'customer'),
('David Green (Staff)', 'davidg_staff@example.com', 'abc123123', '0975159357', '20 HIK Street, District 3, HCMC', 'staff'),
('Sarah White', 'sarahw@example.com', 'abc123123', '0888111222', '30 LMN Street, Thanh Xuan District, Hanoi', 'customer'),
('Michael Black', 'michaelb@example.com', 'abc123123', '0909999888', '45 OPQ Street, Go Vap District, HCMC', 'customer');
GO

-- Insert data into categories table
PRINT 'Inserting data into categories...';
INSERT INTO categories (name, description) VALUES
('CPU', 'Central Processing Unit'),
('GPU', 'Graphics Processing Unit'), -- Keep ID 2 for GPU for product reference
('RAM', 'Random Access Memory'), -- Keep ID 3 for RAM
('Mainboard', 'Motherboard'), -- Keep ID 4 for Mainboard
('PSU', 'Power Supply Unit'), -- Keep ID 5 for PSU
('SSD', 'Solid State Drive'), -- Keep ID 6 for SSD
('Case', 'Computer Case'); -- Keep ID 7 for Case
GO

-- Insert data into products table
PRINT 'Inserting data into products...';
-- Note: category_id references the ID in the categories table
INSERT INTO products (name, category_id, price, stock, status, image_url, description, spec_description) VALUES
('Intel Core i5-12400F', 1, 4500000.00, 50, 'active', 'http://example.com/images/i5-12400f.jpg', '12th Gen Intel CPU', '{"Socket":"LGA 1700", "Cores/Threads":"6/12", "Frequency":"2.5GHz (Boost 4.4GHz)", "Cache":"18MB"}'),
('AMD Ryzen 5 5600X', 1, 4800000.00, 45, 'active', 'http://example.com/images/r5-5600x.jpg', 'AMD Ryzen 5000 series CPU', '{"Socket":"AM4", "Cores/Threads":"6/12", "Frequency":"3.7GHz (Boost 4.6GHz)", "Cache":"32MB"}'),
('Nvidia GeForce RTX 3060', 2, 8000000.00, 30, 'active', 'http://example.com/images/rtx3060.jpg', 'Mid-range Graphics Card', '{"Chipset":"RTX 3060", "VRAM":"12GB GDDR6", "Interface":"PCIe 4.0"}'),
('AMD Radeon RX 6600', 2, 7500000.00, 25, 'active', 'http://example.com/images/rx6600.jpg', 'AMD Graphics Card', '{"Chipset":"RX 6600", "VRAM":"8GB GDDR6", "Interface":"PCIe 4.0"}'),
('Corsair Vengeance LPX 16GB (2x8GB) DDR4 3200MHz', 3, 1800000.00, 100, 'active', 'http://example.com/images/ddr4-16gb.jpg', 'High-performance DDR4 RAM', '{"Type":"DDR4", "Capacity":"16GB (2x8GB)", "Speed":"3200MHz", "CAS Latency":"CL16"}'),
('Kingston FURY Beast 8GB DDR4 3200MHz', 3, 900000.00, 120, 'active', 'http://example.com/images/ddr4-8gb.jpg', 'Good value 8GB RAM', '{"Type":"DDR4", "Capacity":"8GB", "Speed":"3200MHz", "CAS Latency":"CL16"}'),
('ASUS PRIME B660M-A D4', 4, 3000000.00, 20, 'active', 'http://example.com/images/b660m.jpg', 'Mainboard for Intel Gen 12', '{"Socket":"LGA 1700", "Chipset":"Intel B660", "RAM":"4 x DDR4 DIMM", "Form Factor":"Micro-ATX"}'),
('Gigabyte B550M DS3H', 4, 2500000.00, 22, 'active', 'http://example.com/images/b550m.jpg', 'Mainboard for AMD Ryzen', '{"Socket":"AM4", "Chipset":"AMD B550", "RAM":"4 x DDR4 DIMM", "Form Factor":"Micro-ATX"}'),
('Corsair RM750e (2023)', 5, 2800000.00, 15, 'active', 'http://example.com/images/rm750e.jpg', '750W Full Modular PSU', '{"Power":"750W", "Certification":"80 Plus Gold", "Modular":"Full Modular"}'),
('Samsung 970 EVO Plus 500GB', 6, 1500000.00, 40, 'active', 'http://example.com/images/970evo.jpg', 'High-speed NVMe SSD', '{"Capacity":"500GB", "Interface":"NVMe PCIe 3.0", "Read Speed":"~3500MB/s", "Write Speed":"~3200MB/s"}');
GO

-- Insert data into payment_methods table
PRINT 'Inserting data into payment_methods...';
INSERT INTO payment_methods (name, description) VALUES
('Cash on Delivery (COD)', 'Pay directly to the delivery person.'),
('Bank Transfer', 'Transfer through the bank.'),
('Credit/Debit Card', 'Pay using Visa, Mastercard.'),
('Momo E-wallet', 'Pay via Momo wallet.'),
('ZaloPay E-wallet', 'Pay via ZaloPay wallet.');
GO

-- Insert data into cart_items table (assuming some users added items to cart)
PRINT 'Inserting data into cart_items...';
INSERT INTO cart_items (user_id, product_id, quantity) VALUES
(1, 1, 1), -- User 1 (John Doe) has Product 1 (i5)
(1, 3, 1), -- User 1 (John Doe) has Product 3 (RTX 3060)
(2, 5, 2), -- User 2 (Jane Smith) has Product 5 (RAM 16GB)
(4, 10, 1), -- User 4 (Mary Brown) has Product 10 (SSD 500GB)
(6, 6, 1), -- User 6 (Sarah White) has Product 6 (RAM 8GB)
(7, 8, 1); -- User 7 (Michael Black) has Product 8 (Mainboard B550M)
GO

-- Insert data into orders table (assuming some users placed orders)
PRINT 'Inserting data into orders...';
INSERT INTO orders (user_id, order_date, total_price, payment_method_id, status, address) VALUES
(1, '2023-10-26 10:00:00', 12500000.00, 1, 'completed', '123 ABC Street, District 1, HCMC'), -- Order of User 1, Payment 1
(2, '2023-10-27 14:30:00', 3600000.00, 2, 'shipping', '456 XYZ Avenue, Binh Thanh District, HCMC'), -- Order of User 2, Payment 2
(4, '2023-10-28 09:15:00', 1500000.00, 4, 'completed', '789 EFG Lane, Cau Giay District, Hanoi'), -- Order of User 4, Payment 4
(6, '2023-10-28 11:00:00', 900000.00, 1, 'pending', '30 LMN Street, Thanh Xuan District, Hanoi'), -- Order of User 6, Payment 1
(7, '2023-10-28 15:45:00', 2500000.00, 3, 'shipping', '45 OPQ Street, Go Vap District, HCMC'); -- Order of User 7, Payment 3
GO

-- Insert data into order_details table (details for the orders above)
PRINT 'Inserting data into order_details...';
INSERT INTO order_details (order_id, product_id, quantity, item_price) VALUES
(1, 1, 1, 4500000.00), -- Order 1 Detail: 1x Product 1
(1, 3, 1, 8000000.00), -- Order 1 Detail: 1x Product 3
(2, 5, 2, 1800000.00), -- Order 2 Detail: 2x Product 5
(3, 10, 1, 1500000.00), -- Order 3 Detail: 1x Product 10
(4, 6, 1, 900000.00), -- Order 4 Detail: 1x Product 6
(5, 8, 1, 2500000.00); -- Order 5 Detail: 1x Product 8
GO

-- Insert data into feedback table (assuming some users left feedback)
PRINT 'Inserting data into feedback...';
INSERT INTO feedback (product_id, user_id, rating, content, created_at) VALUES
(1, 1, 5, 'Powerful CPU, runs smoothly.', '2023-11-01 09:00:00'), -- User 1 feedback for Product 1
(3, 1, 4, 'Good graphics card for the price.', '2023-11-01 09:10:00'), -- User 1 feedback for Product 3
(5, 2, 5, 'Stable RAM, easy to install.', '2023-11-02 10:00:00'), -- User 2 feedback for Product 5
(10, 4, 5, 'Very fast SSD, satisfied.', '2023-11-03 11:30:00'), -- User 4 feedback for Product 10
(6, 6, 4, 'RAM works well for office tasks.', '2023-11-04 14:00:00'), -- User 6 feedback for Product 6
(8, 7, 5, 'Sturdy mainboard, many ports.', '2023-11-05 16:00:00'); -- User 7 feedback for Product 8
GO

-- Insert data into blogs table (assuming some users wrote blogs)
PRINT 'Inserting data into blogs...';
INSERT INTO blogs (title, content, user_id, created_at, updated_at) VALUES
('Guide to Building a Budget Gaming PC', 'Detailed content on how to choose components and assemble a gaming PC on a limited budget...', 3, '2023-10-25 08:00:00', '2023-10-25 08:00:00'), -- User 3 (Admin) wrote blog
('Detailed Review of RTX 4070 Super', 'Real-world performance evaluation of the RTX 4070 Super graphics card...', 5, '2023-10-26 10:00:00', '2023-10-26 10:00:00'), -- User 5 (Staff) wrote blog
('Choosing the Right RAM for Intel and AMD CPUs', 'Analysis of differences and how to choose optimal RAM for each CPU platform...', 1, '2023-10-27 14:00:00', '2023-10-27 14:00:00'), -- User 1 (Customer) wrote blog
('What is NVMe SSD? Why Should You Upgrade?', 'Explanation of NVMe SSD technology and the benefits of using it...', 4, '2023-10-28 09:30:00', '2023-10-28 09:30:00'), -- User 4 (Customer) wrote blog
('The Importance of Power Supply Unit (PSU) in a PC Build', 'Why you should not save money when choosing a power supply...', 3, '2023-10-29 11:00:00', '2023-10-29 11:00:00'); -- User 3 (Admin) wrote blog
GO

PRINT 'Sample data insertion complete.';
GO
