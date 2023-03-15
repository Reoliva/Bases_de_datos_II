--ENUM solo acepta los valores escritos a continuacion
-- TIMESTAMP muesta el dia, fecha ,hora ,minutos y segundos en los que fue creado.

--ejemplo tabla:
CREATE TABLE usuario(
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(20) UNIQUE NOT NULL,
    email VARCHAR(50) UNIQUE NOT NULL,
    edad INT UNSIGNED NOT NULL,
    estado ENUM("activo", "inactivo")  DEFAULT "inactivo",
    bio TEXT, 
    Creado_el TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);



CREATE TABLE comments(
    id_comments INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(50),
    id_usuario INT,
    com_creado_el TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE
);

-- iNSERTAR DATOS EN TABLA:
INSERT INTO usuario(username, email, edad) VALUES 
("usuario1", "usuario1@gmail.com", 17 ), 
("usuario2" , "usuario2@gmail.com", 21 ),
("usuario3", "usuario3@gmail.com", 18 ), 
("usuario4" , "usuario4@gmail.com", 44);

INSERT INTO usuario(username, email, edad, estado) VALUES 
("usuario5", "usuario5@gmail.com", 51, "activo" );

INSERT INTO usuario(username, email, edad, bio) VALUES 
("usuario6" , "usuario6@gmail.com", 30, "tengo 30 años"),
("usuario7", "usuario7@gmail.com", 23, "tengo 23 años");

--RENOMBRAR COLUMNA TABLA:
ALTER TABLE nombre_tabla RENAME COLUMN nombre_actual TO nombre_nuevo;
--Cambiar tipo de dato y nombre;
ALTER TABLE nombre_tabla CHANGE nombre_columna nuevo_nombre_columna TIPODATO; --ej: ALTER TABLE usuario CHANGE bio Biografia VARCHAR(100);
-- agregar PK y FK
ALTER TABLE nombre_tabla add PRIMARY KEY(atributo);
ALTER TABLE nombre_tabla add FOREIGN KEY(atributo) REFERENCES tabla_x(atributo);

-- MOSTRAR TODOS (*) LOS DATOS DE LA TABLA:
SELECT *  FROM usuario; -- SELECT *  FROM usuario\G; muestra de otra manera no tabla.

-- MOSTRAR LOS DATOS DE TABLA CON CONDICIONES:
SELECT * FROM usuario WHERE id_usuario = 2; -- muestra los datos del usuario con la id 2

SELECT * FROM usuario WHERE email = "usuario5@gmail.com";  -- muestra los datos del usuario con el correo "usuario5@gmail.com"

SELECT * FROM usuario WHERE edad > 25; -- muestra los datos de los usuarios mayores a 25 años

SELECT * FROM usuario WHERE bio IS NOT NULL; -- muestra los usuarios con biografia.

SELECT * FROM usuario WHERE Creado_el > "2022-07-16 00:00:01"; --muestra los datos de los usuarios creados el dia 16 de Julio del 2022
SELECT * FROM usuario WHERE DATE(Creado_el) = "2022-07-16"; --  es lo mismo sin hora

SELECT * FROM usuario WHERE id_usuario IN (2,4,5,7); -- muestra los datos de los usuarios con las id 2, 4, 5, 7.

SELECT * FROM usuario ORDER BY edad; -- muestra los datos de los usuarios ordenados por edad de menos a mayor(ASC). Para ordenar de mayor a menos se escribe "DESC" despues de "edad"

SELECT username, email FROM usuario ORDER BY edad DESC LIMIT 3; --Muestra el username y el correo  de los 3  usuarios con mas edad

SELECT username, email, edad FROM usuario WHERE edad > 25 AND edad < 47; --muestra el username, email y edad de los usuarios entre los 25 y los 47 años

SELECT * FROM usuario WHERE email LIKE "%.com"; -- muestra todos los usuarios cuyo correo electronico termine en ".com"

--agregar datos a un usuario:
UPDATE usuario SET bio="soy el usuario1", username = "Elithio" WHERE id_usuario = 1;  -- Le agrega biografia al usuario 1 y le cambia el username

--Eliminar un registro:
DELETE FROM usuario WHERE id=1; --Elimina los datos del usuario 1, si no se añade condicion limpia la tabla pero no reinicia el autoincrement
TRUNCATE FROM usuario; --Elimina los datos de usuario y reinicia los valores de la tabla, empieza la id desde 1 al contrario de delete.

-- UNIR TABLAS: (INNER JOIN)
SELECT * FROM usuario INNER JOIN comments ON  usuario.id_usuario = comments.id_usuario; -- muestra los datos de los usuarios que tengan al menos un comentario:
SELECT usuario.username, usuario.email, comments.title FROM usuario INNER JOIN comments ON  usuario.id_usuario = comments.id_usuario; -- muestra todos los usuarios, emails y comntarios de usuarios con comentarios.
SELECT DISTINCT usuario.username, usuario.email, comments.title FROM usuario INNER JOIN comments ON  usuario.id_usuario = comments.id_usuario; -- DISTINCT muestra una unica vez el usuario aunque tenga multiples comentarios
SELECT * FROM usuario INNER JOIN comments ON usuario.id_usuario = comments.id_usuario WHERE usuario.estado = "activo"; --muestra todos los datos y comentarios del usuario activo

-- LEFT JOIN  (muestra la parte izquierda)
SELECT * FROM usuario LEFT JOIN comments ON usuario.id_usuario = comments.id_usuario WHERE comments.id_usuario IS NULL; -- muestra los datos de los usuarios SIN comentarios
SELECT * FROM usuario LEFT JOIN comments ON usuario.id_usuario = comments.id_usuario WHERE comments.id_usuario IS NOT NULL; -- muestra los datos de los usuarios con comentarios

SELECT usuario.username, usuario.email FROM usuario INNER JOIN comments ON usuario.id_usuario = comments.id_usuario WHERE DATE(com_creado_el) = "2022-07-17"; --muestra el user y mail de los usuarios con comentarios creados el dia 17-07

SELECT usuario.username, usuario.email, count(*) AS "cantidad_comentarios"
FROM usuario INNER JOIN comments ON usuario.id_usuario = comments.id_usuario WHERE DATE(com_creado_el) = "2022-07-17"
GROUP BY usuario.username
ORDER BY cantidad_comentarios DESC
LIMIT 1; --MUESTRA el usuarname, correo y cantidad de comentarios del usuario con mas comentarios creados el dia 17-07.

--Subconsultas  o consulta anidada: 
SELECT username, email FROM (
    SELECT usuario.username, usuario.email, count(*) AS "cantidad_comentarios"
    FROM usuario INNER JOIN comments ON usuario.id_usuario = comments.id_usuario WHERE DATE(com_creado_el) = "2022-07-17"
    GROUP BY usuario.username
    ORDER BY cantidad_comentarios DESC
    LIMIT 1
) AS resultado;   -- Muestra SOLO el username y correo del usuario con mas comentarios creados el dia 17-07

SELECT username, email FROM (
    SELECT usuario.username, usuario.email, count(*) AS "cantidad_comentarios"
    FROM usuario INNER JOIN comments ON usuario.id_usuario = comments.id_usuario WHERE DATE(com_creado_el) = "2022-07-17"
    GROUP BY usuario.username
    HAVING cantidad_comentarios >= 2
    ORDER BY cantidad_comentarios DESC

) AS resultado; --muestra los username y correos de los usuarios con 2 o mas comentarios.

-- variables
SET @username = "user2" -- para modificar la variable solo se escribe nuevamente con otro valor
--conocer valor de variable
SELECT  @username AS "valor"; --AS "valor" no es necesario pero lo renombra para visualizar
--uso:
SELECT * FROM usuario WHERE username = @username;
-- GUARDAR RESULTADO EN VARIABLE
SET @id = (SELECT id_usuario FROM usuario WHERE estado = "activo" ORDER BY Creado_el DESC LIMIT 1); --guarda en @id el usuario activo mas antiguo

--respaldar la base de datos
-- En otra cmd, entrar a mysql bin ("C:\Program Files\MySQL\MySQL Server 5.7"\bin) o algo parecido
-- una vez ahi escribir 
mysqldump.exe -u root -p nombrebd > C:\Users\Laboratorio\Desktop\respaldo.txt --  > DIRECCION DONDE LA VAS A GUARDAR puedes guardar en .sql o .txt

-- usar respaldo de la base de datos:
-- se tiene que tener una base de datos creada, vacia o llena pero se va a reemplazar con el respaldo.
-- entrar a mysql bin ("C:\Program Files\MySQL\MySQL Server 5.7"\bin) 
--ahi se escribe 
mysql.exe -u root -p nombre_bd < C:\Users\Laboratorio\Desktop\respaldo.sql  -- donde nombre_bd es tu base de datos ya creada y respaldo.sql es el respaldo que hiciste, puede ser .sql o .txt




SELECT * FROM personas INNER JOIN Mascotas ON personas.Nombre = Mascotas.Dueño; 