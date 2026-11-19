CREATE DATABASE IF NOT EXISTS tienda;

USE tienda;

CREATE TABLE IF NOT EXISTS clientes (
  id int PRIMARY KEY NOT NULL AUTO_INCREMENT,
  nombre varchar(4100) NOT NULL,
  email varchar(100) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS pedidos (
  id int PRIMARY KEY NOT NULL AUTO_INCREMENT,
  fecha date NOT NULL,
  total decimal(10,2) NOT NULL,
  cliente_id int NOT NULL,
);

ALTER TABLE pedidos ADD FOREIGN KEY (cliente_id) REFERENCES clientes (id);
