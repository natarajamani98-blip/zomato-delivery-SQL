CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(1000),
    city VARCHAR(100),
    signup_date DATE
);
CREATE TABLE restaurants (
    rest_id INT PRIMARY KEY,
    rest_name VARCHAR(60),
    cuisine VARCHAR(40),
    rating DECIMAL(1 , 1 ),
    city VARCHAR(60)
);
CREATE TABLE delivery_partner (
    partner_id INT PRIMARY KEY,
    partner_name VARCHAR(100),
    vehicle_type VARCHAR(30),
    joining_date DATE
);
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    rest_id INT,
    partner_id INT,
    order_date DATE,
    order_amount INT,
    delivery_time INT,
    order_status VARCHAR(30),
    FOREIGN KEY (customer_id)
        REFERENCES customers (customer_id),
    FOREIGN KEY (rest_id)
        REFERENCES restaurants (rest_id),
    FOREIGN KEY (partner_id)
        REFERENCES delivery_partner (partner_id)
);
create table payment (
payment_id int primary key,
order_id int,
payment_method varchar(50),
payment_status varchar(50),
foreign key(order_id) references orders(order_id)
);
INSERT INTO customers VALUES
(1,'Mani','Mysore','2024-01-10'),
(2,'Arun','Bangalore','2024-02-05'),
(3,'Sneha','Hyderabad','2024-03-12'),
(4,'Rahul','Chennai','2024-01-25');
INSERT INTO restaurants VALUES
(101,'Burger Hub','Fast Food',4.2,'Bangalore'),
(102,'Spice Garden','Indian',4.5,'Mysore'),
(103,'Pizza World','Italian',4.1,'Chennai');
INSERT INTO delivery_partner VALUES
(201,'Ravi','Bike','2023-12-01'),
(202,'Kiran','Scooter','2024-01-15'),
(203,'Amit','Bike','2024-02-10');
INSERT INTO orders VALUES
(1001,1,102,201,'2024-05-01',350,25,'Delivered'),
(1002,2,101,202,'2024-05-02',200,30,'Delivered'),
(1003,3,103,203,'2024-05-02',500,45,'Delayed'),
(1004,1,101,201,'2024-05-03',150,20,'Delivered'),
(1005,4,102,202,'2024-05-04',400,35,'Cancelled');
INSERT INTO payment VALUES
(501,1001,'UPI','Success'),
(502,1002,'Card','Success'),
(503,1003,'Cash','Pending'),
(504,1004,'UPI','Success'),
(505,1005,'Card','Refunded');

SELECT 
    r.rest_id, r.rest_name, SUM(o.order_amount) AS total_sales
FROM
    orders o
        JOIN
    restaurants r ON o.rest_id = r.rest_id
GROUP BY r.rest_id
ORDER BY total_sales DESC;

SELECT 
    d.partner_id,
    d.partner_name,
    AVG(o.delivery_time) AS avg_delivery_time
FROM
    orders o
        JOIN
    delivery_partner d ON o.partner_id = d.partner_id
GROUP BY d.partner_name , d.partner_id;

SELECT 
    c.customer_id,
    c.customer_name,
    SUM(o.order_amount) AS total_amount
FROM
    orders o
        JOIN
    customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_id , c.customer_name
ORDER BY total_amount DESC;

SELECT payment_method, COUNT(*) AS total_orders
FROM payment
GROUP BY payment_method;

CREATE TABLE daily_sales_summary AS SELECT order_date,
    SUM(order_amount) AS daily_revenue,
    COUNT(order_id) AS total_orders FROM
    orders
WHERE
    order_status = 'Delivered'
GROUP BY order_date;

select*from daily_sales_summary;

SELECT rest_id,
SUM(order_amount) AS revenue,
RANK() OVER(ORDER BY SUM(order_amount) DESC) AS rank_no
FROM orders
GROUP BY rest_id;






















