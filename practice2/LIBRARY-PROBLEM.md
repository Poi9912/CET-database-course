# Ejercicio de diseño de base de datos

Nos piden ayuda para modelar el sistema de una biblioteca, brindándonos la siguiente información.
Los libros son escritos por autores de los cuales conocemos su nombre, su nacionalidad y su fecha de
nacimiento. Los nombres de los autores no pueden repetirse. Además, sabemos que los libros cuentan
con un título único, el idioma y su número de páginas. Adicionalmente, sabemos que cada libro tiene
ediciones, de las cuales sabemos el año y el ISBN (que no puede repetirse).
La biblioteca realiza préstamos de distintas ediciones a usuarios. De cada préstamo, sabemos el número de la copia del libro prestado y el precio del alquiler, mientras que de los usuarios sabemos su DNI, su nombre y apellido y su domicilio. También queremos registrar la fecha del préstamo y la fecha de devolución de las transacciones realizadas.

Tenga en cuenta la siguiente información adicional:
•	Un autor escribe muchos libros y un libro puede ser escrito por muchos autores.
•	Un libro puede tener muchas ediciones.
•	Una edición tiene muchas copias, pero cada copia pertenece a una edición.
•	Una copia pudo haber sido prestada a muchos usuarios y muchos usuarios pueden haber pedido la misma copia en momentos distintos.
•	En algunos casos un libro puede hacer referencia a otro libro, pero solo a uno, lo mismo en el caso inverso.
•	Las copias tienen un número único dentro de cada edición, pero el mismo puede repetirse dentro de otras ediciones.
