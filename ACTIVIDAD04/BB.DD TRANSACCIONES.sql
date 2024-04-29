drop database if exists transacciones;
CREATE DATABASE if not exists transacciones; 
use transacciones;

CREATE TABLE personas (
  codigo INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(30) NOT NULL,
  mail VARCHAR(30) NOT NULL
);

-- añadir datos a personas
INSERT INTO personas VALUES(1,'Pedro Martinez', 'pmartinez@gmail.com');
INSERT INTO personas VALUES(2,'Isabel Luque','iluque@gmail.com');
INSERT INTO personas VALUES(3,'Susana Iglesias','siglesias@gmail.com');

-- EJERCICIO 1.1 

START TRANSACTION;
INSERT INTO personas VALUES(1,'Pedro Martinez', 'pmartinez@gmail.com');
INSERT INTO personas VALUES(2,'Isabel Luque','iluque@gmail.com');
INSERT INTO personas VALUES(3,'Susana Iglesias','siglesias@gmail.com');
INSERT INTO personas VALUES(4, 'GARA Gonzalez', 'gara127gs@gmail.com');
ROLLBACK;

/* Al iniciar una transacción, estamos solicitando al sistema que registre todas las operaciones, 
sin embargo, estas no se incorporarán de manera definitiva a la base de datos hasta que confirmemos
 mediante un "commit". El rollback cancelará la transacción y dejará la base de datos en el estado que
 tenía antes de comenzar la transacción, como si las operaciones no hubieran ocurrido.
*/

-- EJERCICO 2.1 --

START TRANSACTION;
-- añadir datos a personas
INSERT INTO personas VALUES(1,'Pedro Martinez', 'pmartinez@gmail.com');
INSERT INTO personas VALUES(2,'Isabel Luque','iluque@gmail.com');
INSERT INTO personas VALUES(3,'Susana Iglesias','siglesias@gmail.com');
INSERT INTO personas VALUES(4, 'Gara Gonzalez', 'gara127gs@gmail.com');
COMMIT;

/* Si inicias una transacción, añades un registro a la tabla personas y luego realizas un commit,
 lo que sucede es que todas las operaciones realizadas durante esa transacción se aplican de manera definitiva
 a la base de datos. 
El commit confirma y finaliza la transacción, lo que significa que todas las modificaciones realizadas durante 
la transacción se vuelven permanentes y quedan reflejadas en la base de datos. En este caso, el registro que añadimos a la tabla personas
 estará presente en la base de datos después de realizar el commit.
*/

-- EJERCICIO 3.1 --

START TRANSACTION;
UPDATE personas SET nombre = 'Gara Gonzalez' WHERE codigo = 1; 
SAVEPOINT PASO1; 
DELETE FROM personas WHERE codigo > 1; 
ROLLBACK TO PASO1;
COMMIT;

/*
 Se inicia una transacción y actualiza el nombre en la tabla "personas" para el registro con código 1.
 Luego establecemos  un punto de control llamado 'PASO1' antes de eliminar todos los registros en la tabla "personas" con un código mayor a 1. 
 Sin embargo, antes de confirmar definitivamente la eliminación, se ejecuta un rollback hasta el punto de control 'PASO1', deshaciendo la operación
 de eliminación pero conservando la actualización del nombre. Finalmente, se confirma la transacción con un commit, asegurando que la única modificación
 permanente sea la actualización del nombre en el registro con código 1.
*/
-- EJERCICIO 4.1 --

-- Bloqueamos para escritura--
START TRANSACTION;
LOCK TABLES personas WRITE; -- Bloqueo por escritura
UPDATE personas SET nombre = 'Gara' WHERE codigo = 1; 
UNLOCK TABLES; 
COMMIT;

-- Bloqueamos para lectura--
START TRANSACTION;
LOCK TABLES personas READ; 
UPDATE personas SET nombre = 'Gara' WHERE codigo = 2; 
UNLOCK TABLES;
COMMIT;

/*
En el primer bloque de código, se bloquea la tabla "personas" para escritura, permitiendo la actualización exitosa nombre 'Gara' en la fila. 
En el segundo bloque, al intentar bloquear la tabla para lectura y luego realizar una actualización, se produce un conflicto ya que el bloqueo de lectura 
no permite operaciones de escritura concurrentes. La actualización en el segundo bloque no se ejecuta correctamente debido a esta restricción.

Hay que tener en cuenta que el bloqueo para escritura (WRITE) permite operaciones de escritura pero impide que otros procesos obtengan bloqueos para escritura 
o lectura en la misma tabla hasta que se libere el bloqueo. Por otro lado, el bloqueo para lectura (READ) permite operaciones de lectura concurrentes, pero impide 
que otros procesos obtengan bloqueos para escritura en la misma tabla hasta que se libere el bloqueo de lectura.
*/



