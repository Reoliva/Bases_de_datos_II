--Procedimientos

--Procedimiento para obtener la lista de productos con bajo nivel de stock:
--Restricción/Regla de negocio: Obtener la lista de productos cuya cantidad en stock sea menor o igual al nivel de reorden establecido en la tabla de productos.

DELIMITER //

CREATE PROCEDURE get_low_stock_products()
BEGIN
    SELECT product_id, product_name, units_in_stock
    FROM products
    WHERE units_in_stock <= reorder_level;
END;

//

DELIMITER ;


--Procedimiento para calcular el total de ventas por categoría de producto en un rango de fechas:
--Restricción/Regla de negocio: Calcular el total de ventas por categoría de producto en un rango de fechas específico, utilizando la información de las tablas de órdenes y detalles de órdenes.

DELIMITER //

CREATE PROCEDURE get_sales_by_category(IN start_date DATE, IN end_date DATE)
BEGIN
    SELECT c.category_name, SUM(od.unit_price * od.quantity * (1 - od.discount)) AS total_sales
    FROM order_details od
    INNER JOIN products p ON od.product_id = p.product_id
    INNER JOIN categories c ON p.category_id = c.category_id
    INNER JOIN orders o ON od.order_id = o.order_id
    WHERE o.order_date BETWEEN start_date AND end_date
    GROUP BY c.category_name;
END;

//

DELIMITER ;


--Procedimiento para actualizar la información de un cliente en la tabla de clientes:
--Restricción/Regla de negocio: Actualizar la información de un cliente existente en la tabla de clientes, incluyendo la empresa, el nombre de contacto, la dirección y el número de teléfono.

DELIMITER //

CREATE PROCEDURE update_customer(IN customer_id VARCHAR(50), IN company_name TEXT, IN contact_name TEXT, IN address TEXT, IN phone TEXT)
BEGIN
    UPDATE customers
    SET company_name = company_name,
        contact_name = contact_name,
        address = address,
        phone = phone
    WHERE customer_id = customer_id;
END;

//

DELIMITER ;


--Funciones

--Función para obtener el precio total de un pedido:
--Restricción/Regla de negocio: Calcular el precio total de un pedido, sumando el precio unitario de cada producto multiplicado por la cantidad, y aplicando descuentos si los hubiera.
--ESTE NO FUNCIONA DICE QUE ES NO DETERMINISTA
DELIMITER //

CREATE FUNCTION get_order_total(order_id INT)
RETURNS DECIMAL(10, 2)
BEGIN
    DECLARE total DECIMAL(10, 2);
    
    SELECT SUM(unit_price * quantity * (1 - discount))
    INTO total
    FROM order_details
    WHERE order_id = order_id;
    
    RETURN total;
END;

//

DELIMITER ;


--Función para obtener la edad de un empleado en años:
--Restricción/Regla de negocio: Calcular la edad de un empleado a partir de su fecha de nacimiento, en años, redondeando hacia abajo.

DELIMITER //

CREATE FUNCTION get_employee_age(employee_id INT)
RETURNS INT
BEGIN
    DECLARE age INT;
    
    SELECT FLOOR(DATEDIFF(CURDATE(), birth_date) / 365.25)
    INTO age
    FROM employees
    WHERE employee_id = employee_id;
    
    RETURN age;
END;

//

DELIMITER ;

--Función para obtener el nombre completo de un cliente en mayúsculas:
--Restricción/Regla de negocio: Obtener el nombre completo de un cliente, concatenando su nombre y apellido, y convirtiéndolo a mayúsculas.

DELIMITER //

CREATE FUNCTION get_customer_fullname(customer_id VARCHAR(50))
RETURNS VARCHAR(100)
BEGIN
    DECLARE fullname VARCHAR(100);
    
    SELECT UPPER(CONCAT(first_name, ' ', last_name))
    INTO fullname
    FROM customers
    WHERE customer_id = customer_id;
    
    RETURN fullname;
END;

//

DELIMITER ;
