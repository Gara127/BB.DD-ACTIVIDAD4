DROP DATABASE IF EXISTS backupproductos;
CREATE DATABASE IF NOT EXISTS backupproductos; 
Use backupproductos;

CREATE TABLE IF NOT EXISTS producto_copia AS
SELECT * FROM productos.producto;

CREATE TABLE IF NOT EXISTS fabricante_copia AS
SELECT * FROM productos.fabricante;

CREATE TABLE IF NOT EXISTS categoria_copia AS
SELECT * FROM productos.categoria;

-- Añadimos las primary keys y foreing keys que no se copiaron:

ALTER TABLE fabricante_copia
ADD PRIMARY KEY (codigo_fa);

ALTER TABLE categoria_copia
ADD PRIMARY KEY (codigo_cat);

ALTER TABLE producto_copia
ADD PRIMARY KEY (codigo);

ALTER TABLE producto_copia 
ADD CONSTRAINT fk_productofa FOREIGN KEY (codigo_fa) REFERENCES fabricante_copia(codigo_fa);

ALTER TABLE producto_copia
ADD CONSTRAINT fk_productocat FOREIGN KEY (codigo_cat) REFERENCES categoria_copia(codigo_cat);

-- EJERCICIO 5.Incrementa el stock en 2 unidades de todos los productos de la categoría Monitor que tengan un stock menor de 4 unidades.

SELECT p.stock, p.nombre, c.nombre_cat
FROM producto_copia p INNER JOIN categoria_copia c ON p.codigo_cat=c.codigo_cat
WHERE nombre_cat = "Monitor"; 

UPDATE producto_copia AS p
SET p.stock = p.stock + 2
WHERE p.codigo_cat IN (SELECT c.codigo_cat
                      FROM categoria_copia AS c
                      WHERE c.nombre_cat = 'Monitor')
AND p.stock < 4;
 
-- 9.	Queremos borrar al fabricante Lenovo y todos sus productos. Modifica la tabla para permitir borrar en cascada.

ALTER TABLE producto_copia
DROP CONSTRAINT fk_productofa;

ALTER TABLE producto_copia
ADD CONSTRAINT fk_productofa FOREIGN KEY (codigo_fa) REFERENCES fabricante_copia(codigo_fa) ON DELETE CASCADE;

DELETE FROM fabricante_copia WHERE fabricante_copia.nombre_fa = 'Lenovo';

-- 10.	Borra todos aquellos productos del fabricante AMD los cuales no tenemos stock.

DELETE producto_copia FROM producto_copia 
INNER JOIN fabricante_copia ON fabricante_copia.codigo_fa=producto_copia.codigo_fa
WHERE fabricante_copia.nombre_fa = 'AMD' AND producto_copia.stock = 0

