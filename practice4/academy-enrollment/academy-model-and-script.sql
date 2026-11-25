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
ON DUPLICATE KEY UPDATE categoria_id = categoria_id;

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

-- Estudiantes de prueba
INSERT INTO estudiantes (
  primer_nombre, segundo_nombre, primer_apellido, segundo_apellido,
  documento, email, telefono, fecha_nacimiento
) VALUES
  ('Laura', 'María', 'Gómez', 'Ruiz',
   '200500', 'laura.gomez@example.test', '3009005050', '2001-03-14'),
  ('Juan', 'David', 'Martínez', 'Peña',
   '200600', 'juan.martinez@example.test', '3009005051', '2000-07-22'),
  ('Camila', 'Andrea', 'López', 'Díaz',
   '200700', 'camila.lopez@example.test', '3009005052', '2002-11-05'),
  ('Andrés', 'Felipe', 'Ramírez', 'Soto',
   '200800', 'andres.ramirez@example.test', '3009005053', '1999-01-30'),
  ('Valentina', 'Isabel', 'Herrera', 'Cruz',
   '200100', 'valentina.herrera@example.test', '3009005054', '2001-09-18'),
  ('Sebastián', 'Alejandro', 'Moreno', 'Gil',
   '300700', 'sebastian.moreno@example.test', '3009005055', '2000-05-09'),
  ('Daniela', 'Sofía', 'Vargas', 'León',
   '500900', 'daniela.vargas@example.test', '3009005056', '2003-02-26'),
  ('Nicolás', 'Esteban', 'Castro', 'Ríos',
   '300300', 'nicolas.castro@example.test', '3009005057', '2002-12-11')
ON DUPLICATE KEY UPDATE id = LAST_INSERT_ID(id);


-- Periodo requerido por la llave foránea de inscripcion
INSERT INTO periodos (nombre, anio, fecha_inicio, fecha_fin)
SELECT '2026-II', 2026, '2026-07-01', '2026-12-31'
WHERE NOT EXISTS (
  SELECT 1
  FROM periodos
  WHERE nombre = '2026-II' AND anio = 2026
);

INSERT INTO periodos (nombre, anio, fecha_inicio, fecha_fin)
SELECT '2027-I', 2027, '2027-01-01', '2026-06-30'
WHERE NOT EXISTS (
  SELECT 1
  FROM periodos
  WHERE nombre = '2027-I' AND anio = 2027
);

SELECT id INTO @periodo_2026_ii
FROM periodos
WHERE nombre = '2026-II' AND anio = 2026
ORDER BY id
LIMIT 1;

SELECT id INTO @periodo_2027_i
FROM periodos
WHERE nombre = '2027-I' AND anio = 2027
ORDER BY id
LIMIT 1;

-- Inscripciones para cinco estudiantes en el periodo_2026_ii.
-- 3 quedan sin inscripciones.
INSERT INTO inscripcion (
  estudiante_id, programa_id, periodo_id, fecha_inscripcion, estado
)
SELECT
  e.id,
  p.id,
  @periodo_2026_ii,
  '2026-08-15',
  'activa'
FROM (
  SELECT '200800' AS documento, 'TEC-COC-001' AS codigo
  UNION ALL SELECT '200500', 'TEC-CON-001'
  UNION ALL SELECT '200600', 'TEC-DES-001'
  UNION ALL SELECT '200700', 'TEC-GH-001'
  UNION ALL SELECT '300300', 'CUR-EXC-001'
) AS seed
JOIN estudiantes AS e
  ON e.documento = seed.documento
JOIN programas AS p
  ON p.codigo = seed.codigo
WHERE NOT EXISTS (
  SELECT 1
  FROM inscripcion AS i
  WHERE i.estudiante_id = e.id
    AND i.programa_id = p.id
    AND i.periodo_id = @periodo_2026_ii
);

-- Inscripciones para tres estudiantes en el periodo_2026_ii.
-- 5 quedan sin inscripciones.
INSERT INTO inscripcion (
  estudiante_id, programa_id, periodo_id, fecha_inscripcion, estado
)
SELECT
  e.id,
  p.id,
  @periodo_2027_i,
  '2027-01-20',
  'activa'
FROM (
  SELECT '200100' AS documento, 'TEC-COC-001' AS codigo
  UNION ALL SELECT '300700', 'TEC-CON-001'
  UNION ALL SELECT '500900', 'CUR-EXC-001'
) AS seed
JOIN estudiantes AS e
  ON e.documento = seed.documento
JOIN programas AS p
  ON p.codigo = seed.codigo
WHERE NOT EXISTS (
  SELECT 1
  FROM inscripcion AS i
  WHERE i.estudiante_id = e.id
    AND i.programa_id = p.id
    AND i.periodo_id = @periodo_2026_ii
);


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

-- Estudiantes que aún no tienen inscripciones en periodo_2026_ii
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
AND i.periodo = @periodo_2026_ii
ORDER BY e.primer_apellido, e.primer_nombre;

-- Estudiantes que aún no tienen inscripciones en periodo_2027_i
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
AND i.periodo = @periodo_2027_i
ORDER BY e.primer_apellido, e.primer_nombre;

-- Inscripciones por curso e instructor en cada periodo
SELECT
  pe.nombre AS periodo,
  pe.anio AS anio_periodo,
  p.codigo AS codigo_curso,
  p.nombre AS curso,
  CONCAT_WS(' ', m.primer_nombre, m.segundo_nombre,
            m.primer_apellido, m.segundo_apellido) AS instructor,
  COUNT(i.id) AS total_inscripciones,
  COUNT(CASE WHEN i.estado = 'activa' THEN i.id END) AS inscripciones_activas,
  COUNT(CASE WHEN i.estado = 'pendiente_por_pago' THEN i.id END)
    AS pendientes_de_pago
FROM programas AS p
JOIN maestros AS m
  ON m.id = p.maestro_id
CROSS JOIN periodos AS pe
LEFT JOIN inscripcion AS i
  ON i.programa_id = p.id
  AND i.periodo_id = pe.id
GROUP BY
  pe.id, pe.nombre, pe.anio,
  p.id, p.codigo, p.nombre,
  m.id, m.primer_nombre, m.segundo_nombre,
  m.primer_apellido, m.segundo_apellido
ORDER BY pe.anio, pe.nombre, p.nombre;

-- Inscripciones que requieren seguimiento administrativo
SELECT
  i.id AS inscripcion_id,
  CONCAT_WS(' ', e.primer_nombre, e.segundo_nombre,
            e.primer_apellido, e.segundo_apellido) AS estudiante,
  p.nombre AS curso,
  CONCAT_WS(' ', m.primer_nombre, m.segundo_nombre,
            m.primer_apellido, m.segundo_apellido) AS instructor,
  pe.nombre AS periodo,
  i.fecha_inscripcion,
  i.estado
FROM inscripcion AS i
JOIN estudiantes AS e
  ON e.id = i.estudiante_id
JOIN programas AS p
  ON p.id = i.programa_id
JOIN maestros AS m
  ON m.id = p.maestro_id
JOIN periodos AS pe
  ON pe.id = i.periodo_id
WHERE i.estado IN ('creada', 'reservada', 'pendiente_por_pago')
ORDER BY i.estado, i.fecha_inscripcion;

-- Cantidad de estudiantes por curso y periodo
SELECT
  pe.nombre AS periodo,
  pe.anio AS anio_periodo,
  p.codigo AS codigo_curso,
  p.nombre AS curso,
  COUNT(DISTINCT i.estudiante_id) AS estudiantes_con_inscripcion,
  COUNT(DISTINCT CASE
    WHEN i.estado = 'activa' THEN i.estudiante_id
  END) AS estudiantes_activos
FROM periodos AS pe
CROSS JOIN programas AS p
LEFT JOIN inscripcion AS i
  ON i.periodo_id = pe.id
  AND i.programa_id = p.id
GROUP BY
  pe.id, pe.nombre, pe.anio,
  p.id, p.codigo, p.nombre
ORDER BY pe.anio, pe.nombre, p.nombre;