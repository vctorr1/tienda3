import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tienda3/main.dart';
import 'package:tienda3/paginas/inicio.dart';

class DetallesProducto extends StatefulWidget {
  //Variables para la pagina de producto
  final nombre_producto_detalle;
  final nuevo_precio_producto_detalle;
  final precio_producto_detalle;
  final foto_producto_detalle;

  const DetallesProducto({
    super.key,
    this.nombre_producto_detalle,
    this.nuevo_precio_producto_detalle,
    this.precio_producto_detalle,
    this.foto_producto_detalle,
  });

  @override
  State<DetallesProducto> createState() => _EstadoProductos();
}

class _EstadoProductos extends State<DetallesProducto> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //Elevacion de la barra superior sobre el fondo
        elevation: 0.1,
        backgroundColor: Colors.red,
        title: InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: ((context) => HomePage())));
            },
            child: Text('Múdez', style: TextStyle(color: Colors.white))),
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

      //Cuerpo de la pagina
      body: ListView(
        children: <Widget>[
          Container(
            height: 300,
            child: GridTile(
              child: Container(
                color: Colors.white70,
                child: Image.asset(widget.foto_producto_detalle),
              ),
              footer: Container(
                color: Colors.white70,
                child: ListTile(
                  leading: Text(widget.nombre_producto_detalle,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0)),
                  title: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          "${widget.nuevo_precio_producto_detalle}€",
                          style: TextStyle(
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "${widget.precio_producto_detalle}€",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                              fontSize: 16.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          //Detalles del producto
          Row(
            children: <Widget>[
              //Boton de colores
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Color"),
                            content: Text("Elige tu color"),
                            actions: <Widget>[
                              MaterialButton(
                                //Boton de cerrar
                                onPressed: () {
                                  Navigator.of(context).pop(context);
                                },
                                child: Text("Cerrar"),
                              )
                            ],
                          );
                        });
                  },
                  color: Colors.white,
                  textColor: Colors.grey,
                  elevation: 0.2,
                  child: Row(
                    children: <Widget>[
                      Expanded(child: Text("Colores")),
                      Expanded(child: Icon(Icons.arrow_drop_down))
                    ],
                  ),
                ),
              ),

              //Cantidad
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Cantidad"),
                            content: Text("Elige las unidades"),
                            actions: <Widget>[
                              MaterialButton(
                                //Boton de cerrar
                                onPressed: () {
                                  Navigator.of(context).pop(context);
                                },
                                child: Text("Cerrar"),
                              )
                            ],
                          );
                        });
                  },
                  color: Colors.white,
                  textColor: Colors.grey,
                  elevation: 0.2,
                  child: Row(
                    children: <Widget>[
                      Expanded(child: Text("Uds")),
                      Expanded(child: Icon(Icons.arrow_drop_down))
                    ],
                  ),
                ),
              ),

              //Tallas
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Talla"),
                            content: Text("Elige tu talla"),
                            actions: <Widget>[
                              MaterialButton(
                                //Boton de cerrar
                                onPressed: () {
                                  Navigator.of(context).pop(context);
                                },
                                child: Text("Cerrar"),
                              )
                            ],
                          );
                        });
                  },
                  color: Colors.white,
                  textColor: Colors.grey,
                  elevation: 0.2,
                  child: Row(
                    children: <Widget>[
                      Expanded(child: Text("Tallas")),
                      Expanded(child: Icon(Icons.arrow_drop_down))
                    ],
                  ),
                ),
              ),
            ],
          ),
          //Boton de comprar
          Row(
            children: <Widget>[
              Expanded(
                child: MaterialButton(
                    onPressed: () {},
                    color: Colors.red,
                    textColor: Colors.white,
                    elevation: 0.2,
                    child: Text("Comprar Ahora")),
              ),

              //Boton de agregar al carrito
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.add_shopping_cart,
                  color: Colors.red,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.favorite_border,
                  color: Colors.red,
                ),
              ),
            ],
          ),

          Divider(),

          //Detalles del producto
          ListTile(
            title: Text("Detalles del producto"),
            subtitle: Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."),
          ),

          Divider(),

          //Nombre del producto en los detalles
          Row(children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 5, 5, 5),
              child: Text(
                "Nombre del producto",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: Text(widget.nombre_producto_detalle),
            )
          ]),

          //EDITAR MAS ADELANTE
          Row(children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 5, 5, 5),
              child: Text(
                "Marca/provisional",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: Text("marca/provisional"),
            )
          ]),

          //EDITAR MAS ADELANTE
          Row(children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 5, 5, 5),
              child: Text(
                "Provisional",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: Text("Provisional"),
            )
          ]),

          Divider(),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Productos similares")),

          //Productos recomendados
          Container(
            height: 360,
            child: ProductosSimilares(),
          )
        ],
      ),
    );
  }
}

//Productos similares/recomendados
class ProductosSimilares extends StatefulWidget {
  const ProductosSimilares({super.key});

  @override
  State<ProductosSimilares> createState() => _EstadoProductoSimilares();
}

class _EstadoProductoSimilares extends State<ProductosSimilares> {
  var lista_productos = [
    {
      "nombre": "Collar multicolor",
      "foto":
          "imagenes/productos/quenta/Archicos_quenta_nuevos_collar_multicolor_cereza.jpg",
      "precio_antiguo": 30,
      "precio": 15,
    },
    {
      "nombre": "Collar",
      "foto":
          "imagenes/productos/quenta/Archicos_quenta_nuevos_collar_multicolor_cereza.jpg",
      "precio_antiguo": 30,
      "precio": 15,
    },
    {
      "nombre": "Collar",
      "foto":
          "imagenes/productos/quenta/Archicos_quenta_nuevos_collar_multicolor_cereza.jpg",
      "precio_antiguo": 30,
      "precio": 15,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: lista_productos.length,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (BuildContext context, int index) {
        return ProdIndividualSimilar(
          nombre_producto: lista_productos[index]["nombre"],
          foto_producto: lista_productos[index]["foto"],
          precio_antiguo: lista_productos[index]["precio_antiguo"],
          precio: lista_productos[index]["precio"],
        );
      },
    );
  }
}

class ProdIndividualSimilar extends StatelessWidget {
  //Variables del producto
  final nombre_producto;
  final foto_producto;
  final precio_antiguo;
  final precio;

  const ProdIndividualSimilar({
    super.key,
    this.nombre_producto,
    this.foto_producto,
    this.precio_antiguo,
    this.precio,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Hero(
        tag: Text("hero 1"),
        child: Material(
          child: InkWell(
            //Usamos función de flecha para acortar el código a escribir, context es la ruta actuasl del widget en la pagina, push indica que vamos a poner algo encima
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => DetallesProducto(
                      //Parametros para el constructor de la pagina de producto
                      nombre_producto_detalle: nombre_producto,
                      nuevo_precio_producto_detalle: precio,
                      precio_producto_detalle: precio_antiguo,
                      foto_producto_detalle: foto_producto,
                    ))),
            child: GridTile(
              footer: Container(
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          nombre_producto,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      Text(
                        "$precio€",
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      )
                    ],
                  )),
              child: Image.asset(
                foto_producto,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
