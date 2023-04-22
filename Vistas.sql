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

--northwind 1
--Show the employee's first_name and last_name, a "num_orders" column with a count of the orders taken, and a column called "Shipped" that displays "On Time" if the order shipped on time and "Late" if the order shipped late.
--Order by employee last_name, then by first_name, and then descending by number of orders.
--Mostrar el nombre y apellido del empleado, una columna "num_orders" con la cantidad de pedidos realizados, y una columna llamada "Shipped" que muestra "On Time" si el pedido se envió a tiempo y "Late" si se envió tarde.
--Ordenar por apellido del empleado, luego por nombre, y luego en orden descendente por número de pedidos.

CREATE VIEW employee_order_info AS
SELECT
  e.first_name,
  e.last_name,
  COUNT(o.order_id) As num_orders,
  (
    CASE
      WHEN o.shipped_date < o.required_date THEN 'On Time'
      ELSE 'Late'
    END
  ) AS shipped
FROM orders o
  JOIN employees e ON e.employee_id = o.employee_id
GROUP BY
  e.first_name,
  e.last_name,
  shipped
ORDER BY
  e.last_name,
  e.first_name,
  num_orders DESC

--Hospital 1.
--Show all of the patients grouped into weight groups.
--Show the total amount of patients in each weight group.
--Order the list by the weight group decending.
--For example, if they weight 100 to 109 they are placed in the 100 weight group, 110-119 = 110 weight group, etc.

SELECT
  COUNT(*) AS patients_in_group,
  FLOOR(weight / 10) * 10 AS weight_group
FROM patients
GROUP BY weight_group
ORDER BY weight_group DESC;


--Hospital 2.
--Show patient_id, weight, height, isObese from the patients table.
--Display isObese as a boolean 0 or 1.
--Obese is defined as weight(kg)/(height(m)2) >= 30.
--weight is in units kg.
--height is in units cm.

SELECT patient_id, weight, height, 
  (CASE 
      WHEN weight/(POWER(height/100.0,2)) >= 30 THEN
          1
      ELSE
          0
      END) AS isObese
FROM patients;


--Show patient_id, first_name, last_name, and attending doctor's specialty.
--Show only the patients who has a diagnosis as 'Epilepsy' and the doctor's first name is 'Lisa'
--Check patients, admissions, and doctors tables for required information.

SELECT
  p.patient_id,
  p.first_name AS patient_first_name,
  p.last_name AS patient_last_name,
  ph.specialty AS attending_doctor_specialty
FROM patients p
  JOIN admissions a ON a.patient_id = p.patient_id
  JOIN doctors ph ON ph.doctor_id = a.attending_doctor_id
WHERE
  ph.first_name = 'Lisa' and
  a.diagnosis = 'Epilepsy'

