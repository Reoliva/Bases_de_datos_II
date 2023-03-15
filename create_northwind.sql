Create database northwind;

USE northwind;

CREATE TABLE categories(
    category_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    category_name TEXT,
    description TEXT 
);

CREATE TABLE customers(
    customer_id TEXT NOT NULL PRIMARY KEY,
    company_name TEXT,
    contact_name TEXT,
    contact_title TEXT,
    address TEXT,
    city TEXT,
    region TEXT,
    postal_code TEXT,
    country TEXT,
    phone TEXT,
    fax TEXT
);

CREATE TABLE regions(
    region_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    region_description TEXT
);


CREATE TABLE territories(
    territory_id TEXT NOT NULL PRIMARY KEY,
    territory_description TEXT,
    region_id INT,
    FOREIGN KEY (region_id) REFERENCES regions(region_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE suppliers(
    supplier_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,   
    company_name TEXT,
    contact_name TEXT,
    contact_title TEXT,

);
CREATE TABLE products(
    product_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    product_name TEXT,
    supplier_id INT NOT NULL,
    category_id INT NOT NULL,
    quantity_per_unit TEXT,
    unit_price DECIMAL,
    units_in_stock INT,
    units_on_order INT,
    reorder_level INT,
    discontinued INT,
    FOREIGN KEY (supplier_id)  REFERENCES suppliers(supplier_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE ON UPDATE CASCADE 
);

CREATE TABLE regions(
    region_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    region_description TEXT
);

CREATE TABLE shippers(
    shipper_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    company_name TEXT,
    phone TEXT,
    address TEXT,
    city TEXT,
    region TEXT,
    postal_code TEXT,
    country TEXT,
    phone TEXT,
    fax TEXT,
    home_page TEXT
);

CREATE TABLE territories(
    territory_id TEXT NOT NULL PRIMARY KEY,
    territory_description TEXT,
    region_id INT,
    FOREIGN KEY (region_id) REFERENCES regions(region_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE suppliers(
    supplier_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,   
    company_name TEXT,
    contact_name TEXT,
    contact_title TEXT,

);
CREATE TABLE products(
    product_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    product_name TEXT,
    supplier_id INT NOT NULL,
    category_id INT NOT NULL,
    quantity_per_unit TEXT,
    unit_price DECIMAL,

);

CREATE TABLE employees(
    employee_id INT NOT NULL PRIMARY KEY,
    last_name TEXT,
    first_name TEXT,
    title TEXT,
    title_of_courtesy TEXT,
    birth_day DATE,
    hire_date DATE,
    address TEXT,
    city TEXT,
    region TEXT,
    postal_code TEXT,
    country TEXT,
    home_phone TEXT,
    extension TEXT,
    reports_to INT,
    FOREIGN KEY reports_to REFERENCES employees(employee_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE employee_territories(
    employee_id INT NOT NULL,
    territory_id TEXT NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (territory_id) REFERENCES territories(territory_id) ON UPDATE CASCADE ON DELETE CASCADE
);



