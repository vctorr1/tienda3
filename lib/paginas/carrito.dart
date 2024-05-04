import 'package:flutter/material.dart';
import 'package:tienda3/widgets/productos_carrito.dart';

class Carrito extends StatefulWidget {
  const Carrito({super.key});

  @override
  State<Carrito> createState() => _CarritoState();
}

class _CarritoState extends State<Carrito> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //Elevacion de la barra superior sobre el fondo
        elevation: 0.1,
        backgroundColor: Colors.red,
        title: Text('Múdez', style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
            onPressed: () {},
          )
        ],
      ),

      //Contenido de la pagina
      body: ProductosCarrito(),

      bottomNavigationBar: Container(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Expanded(
                child: ListTile(
              title: Text("Total:"),
              //CAMBIAR MAS ADELANTE/ VALOR TEMPORAL
              subtitle: Text("100€"),
            )),
            Expanded(
                child: MaterialButton(
              onPressed: () {},
              color: Colors.red,
              textColor: Colors.white,
              child: Text("Pagar"),
            ))
          ],
        ),
      ),
    );
  }
}
