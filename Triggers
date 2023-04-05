--comprobar stock antes de generar orden ==> no se puede vender un producto inexistente

delimiter //
CREATE TRIGGER check_stock
BEFORE INSERT ON order_details
FOR EACH ROW
BEGIN
    DECLARE stock INT;
    SELECT units_in_stock INTO stock FROM products WHERE product_id = NEW.product_id;
    IF stock < NEW.quantity THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede vender un producto inexistente.';
    END IF;
END;//

delimiter ;

--no se puede realizar un descuento superior a 80%

delimiter //

CREATE TRIGGER check_discount
BEFORE INSERT ON order_details
FOR EACH ROW
BEGIN
    IF NEW.discount > 0.8 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede realizar un descuento superior al 80%.';
    END IF;
END;//

delimiter ;

--actualizar automáticamente el stock de un producto en la tabla de productos cuando se inserta una nueva fila en la tabla de órdenes

delimiter //

CREATE TRIGGER update_stock
AFTER INSERT ON order_details
FOR EACH ROW
UPDATE products SET units_in_stock = units_in_stock - NEW.quantity WHERE product_id = NEW.product_id;//
delimiter ;


