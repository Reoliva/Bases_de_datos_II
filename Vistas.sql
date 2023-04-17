--Vista de productos con descuento:
CREATE VIEW discounted_products AS
SELECT product_name, unit_price, discount
FROM products
WHERE discount > 0;

--Vista de pedidos pendientes:
CREATE VIEW pending_orders AS
SELECT order_id, customer_id, order_date
FROM orders
WHERE status = 'pending';

--Vista de empleados por departamento:
CREATE VIEW employees_by_department AS
SELECT employee_id, first_name, last_name, department
FROM employees
ORDER BY department;

--Vista de clientes con compras recientes:
CREATE VIEW recent_customers AS
SELECT customer_id, first_name, last_name, MAX(order_date) AS last_order_date
FROM orders
GROUP BY customer_id;

--Vista de productos más vendidos:
CREATE VIEW top_selling_products AS
SELECT product_id, SUM(quantity) AS total_sold
FROM order_details
GROUP BY product_id
ORDER BY total_sold DESC;

--Vista de empleados con salarios superiores al promedio:
CREATE VIEW high_salary_employees AS
SELECT employee_id, first_name, last_name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

--Vista de clientes con direcciones de envío y facturación diferentes:
CREATE VIEW customers_with_different_shipping_billing AS
SELECT customer_id, first_name, last_name
FROM customers
WHERE shipping_address <> billing_address;

--Vista de productos agotados:
CREATE VIEW out_of_stock_products AS
SELECT product_id, product_name, units_in_stock
FROM products
WHERE units_in_stock = 0;

--Vista de total de ventas por categoría de producto:
CREATE VIEW sales_by_category AS
SELECT c.category_name, SUM(od.unit_price * od.quantity) AS total_sales
FROM order_details od
JOIN products p ON od.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
GROUP BY c.category_name;


