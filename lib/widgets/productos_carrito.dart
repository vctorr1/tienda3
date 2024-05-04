import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProductosCarrito extends StatefulWidget {
  const ProductosCarrito({super.key});

  @override
  State<ProductosCarrito> createState() => _ProductosCarritoState();
}

class _ProductosCarritoState extends State<ProductosCarrito> {
  var productos_carro = [
    {
      "nombre": "Collar multicolor",
      "foto":
          "imagenes/productos/quenta/Archicos_quenta_nuevos_collar_multicolor_cereza.jpg",
      "precio": 15,
      "tamano": "L",
      "color": "cereza",
      "cantidad": 1
    },
    {
      "nombre": "Collar multicolor",
      "foto":
          "imagenes/productos/quenta/Archicos_quenta_nuevos_collar_multicolor_cereza.jpg",
      "precio": 15,
      "tamano": "L",
      "color": "cereza",
      "cantidad": 1
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: productos_carro.length,
      itemBuilder: (context, index) {
        return ProdCarritoIndividual(
          carrito_nombre_producto: productos_carro[index]["nombre"],
          carrito_foto_producto: productos_carro[index]["foto"],
          carrito_tamano_producto: productos_carro[index]["tamano"],
          carrito_precio: productos_carro[index]["precio"],
          carrito_color_producto: productos_carro[index]["color"],
          carrito_cantidad_producto: productos_carro[index]["cantidad"],
        );
      },
    );
  }
}

class ProdCarritoIndividual extends StatelessWidget {
  //Variables
  final carrito_nombre_producto;
  final carrito_foto_producto;
  final carrito_tamano_producto;
  final carrito_precio;
  final carrito_color_producto;
  final carrito_cantidad_producto;

  const ProdCarritoIndividual({
    super.key,
    this.carrito_nombre_producto,
    this.carrito_foto_producto,
    this.carrito_tamano_producto,
    this.carrito_precio,
    this.carrito_color_producto,
    this.carrito_cantidad_producto,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        //Si hay problemas con las imagenes del carrito, anadir limites de tamano a la imagen
        leading: Image.asset(
          carrito_foto_producto,
          fit: BoxFit.fill,
        ),
        title: Text(carrito_nombre_producto),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //Celdas dentro de columna para formato
            Row(
              children: <Widget>[
                //Tamaño
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: Text(
                    "Tamaño: ",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text(
                    carrito_tamano_producto,
                    style: TextStyle(color: Colors.red),
                  ),
                ),

                //Color
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: Text(
                    "Color: ",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text(
                    carrito_color_producto,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),

            //Precio provisional
            Container(
              alignment: Alignment.bottomLeft,
              child: Text(
                carrito_precio.toString() + "€",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            ),

            Container(
              alignment: Alignment.centerRight,
              child: Column(children: <Widget>[
                IconButton(onPressed: () {}, icon: Icon(Icons.arrow_drop_up)),
                Text(carrito_cantidad_producto.toString()),
                IconButton(onPressed: () {}, icon: Icon(Icons.arrow_drop_down))
              ]),
            ),
          ],
        ),
        //trailing: Column(children: <Widget>[
        //  IconButton(onPressed: () {}, icon: Icon(Icons.arrow_drop_up)),
        //  Text("1"),
        //  IconButton(onPressed: () {}, icon: Icon(Icons.arrow_drop_down))
        //]),
      ),
    );
  }
}
