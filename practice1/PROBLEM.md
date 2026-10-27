# Ejercicio de diseño de base de datos

Una tienda de tecnología en Bogotá requiere diseñar una BD que permita registrar las ventas de una empresa. Especíﬁcamente, esta empresa necesita llevar un control de proveedores, clientes, productos y ventas.

Un proveedor se modela con NIT, nombre, dirección, teléfono y página web. Un cliente también se modela con NIT, nombre y dirección, pero puede tener varios teléfonos de contacto. De cada dirección, nos interesa su calle, número, barrio  y ciudad. Tanto para los proveedores como los clientes, el NIT es un valor único (equivalente al DNI).

De los productos, sabemos que tienen un código único, nombre, precio actual, stock y nombre del proveedor que los comercializa. Además, se organizan en categorías, y cada producto se clasiﬁca solamente en una de ellas, pero sin embargo una categoría clasiﬁca varios productos. 

De ellas nos interesa saber su id, nombre y descripción.

Sabemos que un producto es comercializado por varios proveedores, pero que un proveedor provee un solo producto.

Por razones de contabilidad, se debe registrar la información de cada venta , las cuales tienen un número de factura (que es único), fecha, cliente, descuento y monto ﬁnal. A su vez, sabemos que una venta se compone de varios productos, y por eso nos interesa el precio al momento de la venta del producto, la cantidad vendida y el monto total por él. Tenga en cuenta que un producto puede estar en varias ventas, pero que podemos tener un producto que no haya sido vendido. Adicionalmente, sabemos que cada cliente puede realizar varias ventas, y en una venta solamente participa un cliente.
