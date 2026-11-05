CREATE TABLE autores (
  id bigint PRIMARY KEY NOT NULL AUTO_INCREMENT,
  nombre varchar(255) UNIQUE NOT NULL,
  nacionalidad varchar(255),
  fecha_nacimiento date NOT NULL DEFAULT 'CURRENT_DATE()',
  CONSTRAINT chk_fecha_nacimiento CHECK (fecha_nacimiento <= CURRENT_DATE())
);

CREATE TABLE libros (
  id bigint PRIMARY KEY NOT NULL AUTO_INCREMENT,
  titulo varchar(500) UNIQUE,
  lenguaje varchar(255) NOT NULL,
  numero_paginas integer NOT NULL DEFAULT 1,
  libro_referenciado_id bigint UNIQUE
);

CREATE TABLE libros_autores (
  libro_id bigint,
  autor_id bigint,
  PRIMARY KEY (libro_id, autor_id)
);

CREATE TABLE ediciones (
  isbn varchar(255) UNIQUE PRIMARY KEY NOT NULL,
  libro_id bigint NOT NULL,
  anno date
);

CREATE TABLE copias (
  id bigint PRIMARY KEY NOT NULL AUTO_INCREMENT,
  edicion_isbn varchar(255) NOT NULL,
  numero_copias integer
);

CREATE TABLE usuarios (
  dni bigint UNIQUE PRIMARY KEY,
  nombres varchar(255),
  apellidos varchar(255),
  domicilio varchar(500)
);

CREATE TABLE prestamos (
  id bigint PRIMARY KEY NOT NULL AUTO_INCREMENT,
  copia_id bigint NOT NULL,
  usuario_id bigint NOT NULL,
  precio decimal(12,2) NOT NULL DEFAULT 0.00,
  fecha_prestamo date NOT NULL DEFAULT 'CURRENT_DATE()',
  fecha_devolucion date
);

ALTER TABLE libros_autores ADD FOREIGN KEY (libro_id) REFERENCES libros (id);

ALTER TABLE libros_autores ADD FOREIGN KEY (autor_id) REFERENCES autores (id);

ALTER TABLE ediciones ADD FOREIGN KEY (libro_id) REFERENCES libros (id);

ALTER TABLE copias ADD FOREIGN KEY (edicion_isbn) REFERENCES ediciones (isbn);

ALTER TABLE prestamos ADD FOREIGN KEY (copia_id) REFERENCES copias (id);

ALTER TABLE prestamos ADD FOREIGN KEY (usuario_id) REFERENCES usuarios (dni);

ALTER TABLE libros ADD FOREIGN KEY (id) REFERENCES libros (libro_referenciado_id);
