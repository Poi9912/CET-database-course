-- ============================================================
-- Proyecto: Gestión de inscripciones de una academia
-- Integrantes: Julio Urrego
-- Fecha: 2026-11-25
-- Problema de negocio: Una academia requiere almacenar 
-- digitalmente las inscripciones de múltiples periodos,
-- teniendo control de maestros asignados a cada programa
-- tengan conocimientos en las áreas respectivas y el
-- estudiante tenga conocimiento de la intensidad horaria, así
-- como el maestro asignado.
-- ============================================================


CREATE TABLE periodos (
  id bigint PRIMARY KEY NOT NULL AUTO_INCREMENT,
  nombre varchar(255) NOT NULL,
  anio int NOT NULL,
  fecha_inicio date NOT NULL,
  fecha_fin date NOT NULL
);

CREATE TABLE maestros (
  id bigint PRIMARY KEY NOT NULL AUTO_INCREMENT,
  primer_nombre varchar(255) NOT NULL,
  segundo_nombre varchar(255),
  primer_apellido varchar(255) NOT NULL,
  segundo_apellido varchar(255),
  tipodocumento ENUM ('cedula_de_ciudadania', 'cedula_de_extranjeria', 'pasaporte', 'tarjeta_de_identidad', 'permiso_proteccion_temporal') NOT NULL DEFAULT "cedula_de_ciudadania",
  documento varchar(255) UNIQUE NOT NULL,
  email varchar(255) UNIQUE NOT NULL,
  telefono varchar(255) UNIQUE NOT NULL,
  fecha_nacimiento date NOT NULL
);

CREATE TABLE maestros_categorias (
  maestro_id bigint NOT NULL,
  categoria_id bigint NOT NULL,
  PRIMARY KEY (maestro_id, categoria_id)
);

CREATE TABLE categorias (
  id bigint PRIMARY KEY NOT NULL AUTO_INCREMENT,
  nombre varchar(255) UNIQUE NOT NULL
);

CREATE TABLE estudiante (
  id bigint PRIMARY KEY NOT NULL AUTO_INCREMENT,
  primer_nombre varchar(255) NOT NULL,
  segundo_nombre varchar(255),
  primer_apellido varchar(255) NOT NULL,
  segundo_apellido varchar(255),
  tipodocumento ENUM ('cedula_de_ciudadania', 'cedula_de_extranjeria', 'pasaporte', 'tarjeta_de_identidad', 'permiso_proteccion_temporal') NOT NULL DEFAULT "cedula_de_ciudadania",
  documento varchar(255) UNIQUE NOT NULL,
  email varchar(255) UNIQUE NOT NULL,
  telefono varchar(255) NOT NULL,
  fecha_nacimiento date NOT NULL
);

CREATE TABLE programas (
  id bigint PRIMARY KEY NOT NULL AUTO_INCREMENT,
  codigo varchar(255) UNIQUE NOT NULL,
  categoria bigint NOT NULL,
  nombre varchar(255) NOT NULL,
  descripcion text,
  maestro_id bigint NOT NULL,
  horas_semanales int NOT NULL,
  semanas int NOT NULL
);

CREATE TABLE inscripcion (
  id bigint PRIMARY KEY NOT NULL AUTO_INCREMENT,
  estudiante_id bigint NOT NULL,
  programa_id bigint NOT NULL,
  periodo_id bigint NOT NULL,
  fecha_inscripcion date NOT NULL,
  estado ENUM ('creada', 'reservada', 'pendiente_por_pago', 'aprobada', 'activa', 'retirada') NOT NULL DEFAULT "creada"
);

ALTER TABLE maestros_categorias ADD FOREIGN KEY (maestro_id) REFERENCES maestros (id);

ALTER TABLE maestros_categorias ADD FOREIGN KEY (categoria_id) REFERENCES categorias (id);

ALTER TABLE programas ADD FOREIGN KEY (categoria) REFERENCES categorias (id);

ALTER TABLE programas ADD FOREIGN KEY (maestro_id) REFERENCES maestros (id);

ALTER TABLE inscripcion ADD FOREIGN KEY (estudiante_id) REFERENCES estudiante (id);

ALTER TABLE inscripcion ADD FOREIGN KEY (programa_id) REFERENCES programas (id);

ALTER TABLE inscripcion ADD FOREIGN KEY (periodo_id) REFERENCES periodos (id);

ALTER TABLE programas ADD FOREIGN KEY (maestro_id, categoria) REFERENCES maestros_categorias (maestro_id, categoria_id);

