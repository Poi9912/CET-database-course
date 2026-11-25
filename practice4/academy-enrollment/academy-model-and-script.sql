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
-- Motor usado: MySQL
-- ============================================================

-- === Base de datos === --

CREATE DATABASE IF NOT EXISTS academia;

USE academia;

-- === Tablas === --

CREATE TABLE IF NOT EXISTS periodos (
  id bigint PRIMARY KEY NOT NULL AUTO_INCREMENT,
  nombre varchar(255) NOT NULL,
  anio int NOT NULL,
  fecha_inicio date NOT NULL,
  fecha_fin date NOT NULL
);

CREATE TABLE IF NOT EXISTS maestros (
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

CREATE TABLE IF NOT EXISTS maestros_categorias (
  maestro_id bigint NOT NULL,
  categoria_id bigint NOT NULL,
  PRIMARY KEY (maestro_id, categoria_id)
);

CREATE TABLE IF NOT EXISTS categorias (
  id bigint PRIMARY KEY NOT NULL AUTO_INCREMENT,
  nombre varchar(255) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS estudiantes (
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

CREATE TABLE IF NOT EXISTS programas (
  id bigint PRIMARY KEY NOT NULL AUTO_INCREMENT,
  codigo varchar(255) UNIQUE NOT NULL,
  categoria bigint NOT NULL,
  nombre varchar(255) NOT NULL,
  descripcion text,
  maestro_id bigint NOT NULL,
  horas_semanales int NOT NULL,
  semanas int NOT NULL
);

CREATE TABLE IF NOT EXISTS inscripcion (
  id bigint PRIMARY KEY NOT NULL AUTO_INCREMENT,
  estudiante_id bigint NOT NULL,
  programa_id bigint NOT NULL,
  periodo_id bigint NOT NULL,
  fecha_inscripcion date NOT NULL,
  estado ENUM ('creada', 'reservada', 'pendiente_por_pago', 'aprobada', 'activa', 'retirada') NOT NULL DEFAULT "creada"
);

-- === LLaves foraneas === --

ALTER TABLE maestros_categorias ADD FOREIGN KEY (maestro_id) REFERENCES maestros (id);
ALTER TABLE maestros_categorias ADD FOREIGN KEY (categoria_id) REFERENCES categorias (id);
ALTER TABLE programas ADD FOREIGN KEY (categoria) REFERENCES categorias (id);
ALTER TABLE programas ADD FOREIGN KEY (maestro_id) REFERENCES maestros (id);
ALTER TABLE inscripcion ADD FOREIGN KEY (estudiante_id) REFERENCES estudiantes (id);
ALTER TABLE inscripcion ADD FOREIGN KEY (programa_id) REFERENCES programas (id);
ALTER TABLE inscripcion ADD FOREIGN KEY (periodo_id) REFERENCES periodos (id);
ALTER TABLE programas ADD FOREIGN KEY (maestro_id, categoria) REFERENCES maestros_categorias (maestro_id, categoria_id);

-- === Pregarga de datos === --

-- Categorías
INSERT INTO categorias (nombre) VALUES
  ('Cocina'),
  ('Contabilidad'),
  ('Desarrollo de software'),
  ('Recursos humanos'),
  ('Excel')
ON DUPLICATE KEY UPDATE id = LAST_INSERT_ID(id);

SELECT id INTO @cat_cocina
FROM categorias WHERE nombre = 'Cocina';

SELECT id INTO @cat_contabilidad
FROM categorias WHERE nombre = 'Contabilidad';

SELECT id INTO @cat_desarrollo
FROM categorias WHERE nombre = 'Desarrollo de software';

SELECT id INTO @cat_rrhh
FROM categorias WHERE nombre = 'Recursos humanos';

SELECT id INTO @cat_excel
FROM categorias WHERE nombre = 'Excel';

-- 
INSERT INTO maestros (
  primer_nombre, segundo_nombre, primer_apellido, segundo_apellido,
  documento, email, telefono, fecha_nacimiento
) VALUES
  ('Ana', 'Lucía', 'Pérez', 'Gómez',
   '100200', 'ana.perez@example.test', '3001001010', '1985-04-12'),
  ('Carlos', 'Andrés', 'Rojas', 'Díaz',
   '100300', 'carlos.rojas@example.test', '3001001011', '1982-09-23'),
  ('Sofía', 'Valentina', 'Torres', 'Ruiz',
   '100100', 'sofia.torres@example.test', '3001001012', '1990-02-08'),
  ('Miguel', 'Ángel', 'Castro', 'León',
   '100500', 'miguel.castro@example.test', '30010010103', '1987-11-17')
ON DUPLICATE KEY UPDATE id = LAST_INSERT_ID(id);

SELECT id INTO @maestro_cocina
FROM maestros WHERE documento = '100200';

SELECT id INTO @maestro_contabilidad
FROM maestros WHERE documento = '100300';

SELECT id INTO @maestro_desarrollo_excel
FROM maestros WHERE documento = '100100';

SELECT id INTO @maestro_rrhh
FROM maestros WHERE documento = '100500';

-- Categorías que cada instructor puede impartir
INSERT INTO maestros_categorias (maestro_id, categoria_id) VALUES
  (@maestro_cocina, @cat_cocina),
  (@maestro_contabilidad, @cat_contabilidad),
  (@maestro_desarrollo_excel, @cat_desarrollo),
  (@maestro_desarrollo_excel, @cat_excel),
  (@maestro_rrhh, @cat_rrhh)
ON DUPLICATE KEY UPDATE categoria_id = VALUES(categoria_id);

-- Programas
INSERT INTO programas (
  codigo, categoria, nombre, descripcion, maestro_id,
  horas_semanales, semanas
) VALUES
  ('TEC-COC-001', @cat_cocina, 'Técnico de Cocina',
   'Formación técnica en cocina.', @maestro_cocina, 12, 16),
  ('TEC-CON-001', @cat_contabilidad, 'Técnico de Contabilidad',
   'Formación técnica en contabilidad.', @maestro_contabilidad, 10, 16),
  ('TEC-DES-001', @cat_desarrollo, 'Técnico de Desarrollo de Software',
   'Formación técnica en desarrollo de software.', @maestro_desarrollo_excel, 12, 24),
  ('TEC-GH-001', @cat_rrhh, 'Técnico de Gestión Humana',
   'Formación técnica en gestión humana.', @maestro_rrhh, 8, 12),
  ('CUR-EXC-001', @cat_excel, 'Curso Excel',
   'Curso de herramientas de Excel.', @maestro_desarrollo_excel, 6, 8)
ON DUPLICATE KEY UPDATE id = LAST_INSERT_ID(id);

-- === Consultas previas === --

-- Todos los estudiantes y sus cursos inscritos, instructores y periodos
SELECT
  e.id AS estudiante_id,
  CONCAT_WS(' ', e.primer_nombre, e.segundo_nombre,
            e.primer_apellido, e.segundo_apellido) AS estudiante,
  e.documento AS documento_estudiante,
  i.id AS inscripcion_id,
  p.nombre AS curso,
  CONCAT_WS(' ', m.primer_nombre, m.segundo_nombre,
            m.primer_apellido, m.segundo_apellido) AS instructor,
  pe.nombre AS periodo,
  pe.anio AS anio_periodo,
  i.fecha_inscripcion,
  i.estado AS estado_inscripcion
FROM estudiantes AS e
LEFT JOIN inscripcion AS i
  ON i.estudiante_id = e.id
LEFT JOIN programas AS p
  ON p.id = i.programa_id
LEFT JOIN maestros AS m
  ON m.id = p.maestro_id
LEFT JOIN periodos AS pe
  ON pe.id = i.periodo_id
ORDER BY e.primer_apellido, e.primer_nombre, i.id;

-- Estudiantes que aún no tienen inscripciones
SELECT
  e.id AS estudiante_id,
  CONCAT_WS(' ', e.primer_nombre, e.segundo_nombre,
            e.primer_apellido, e.segundo_apellido) AS estudiante,
  e.documento AS documento_estudiante,
  e.email,
  e.telefono
FROM estudiantes AS e
LEFT JOIN inscripcion AS i
  ON i.estudiante_id = e.id
WHERE i.id IS NULL
ORDER BY e.primer_apellido, e.primer_nombre;