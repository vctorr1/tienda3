import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:another_carousel_pro/another_carousel_pro.dart';

//Imports de Firebase

//Imports de carpeta componentes
import 'package:tienda3/widgets/listview_horizontal.dart';
import 'package:tienda3/paginas/db/auth_service.dart';
import 'package:tienda3/widgets/poductos.dart';
import 'package:tienda3/paginas/carrito.dart';
import 'package:tienda3/paginas/auth/login_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override //creamos un estado para la pagina de inicio
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    //Widget para el carrusel de productos
    Widget carrusel_imagen = new Container(
      height: 200,
      child: AnotherCarousel(
        boxFit: BoxFit.cover,
        images: [
          AssetImage(
              'imagenes/productos/quenta/Archicos_quenta_nuevos_collar_multicolor_cereza.jpg'),
          AssetImage(
              'imagenes/productos/quenta/Archicos_quenta_nuevos_L_nell.jpg'),
          AssetImage(
              'imagenes/productos/quenta/Archicos_quenta_nuevos_margarita_nell.jpg'),
          AssetImage(
              'imagenes/productos/quenta/Archicos_quenta_nuevos_mari_collar_caras.jpg'),
          AssetImage(
              'imagenes/productos/quenta/Archicos_quenta_nuevos_maria_corazon.jpg'),
          AssetImage(
              'imagenes/productos/quenta/Archicos_quenta_nuevos_maria_estrellas.jpg'),
        ],
        animationCurve: Curves.fastOutSlowIn,
        animationDuration: Duration(milliseconds: 1000),
        indicatorBgPadding: 6,
        dotBgColor: Colors.transparent,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
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
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Carrito()));
            },
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          //Creamos lista de widgets
          children: <Widget>[
            //Cabecera
            UserAccountsDrawerHeader(
              accountName: Text('nombre ejemplo'),
              accountEmail: Text('ejemplo@email.com'),
              //Foto de perfil
              currentAccountPicture: GestureDetector(
                child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                ),
              ),
              decoration: BoxDecoration(color: Colors.red),
            ),

            //Cuerpo
            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text('Inicio'),
                leading: Icon(Icons.home),
              ),
            ),

            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text('Perfil'),
                leading: Icon(Icons.person),
              ),
            ),

            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text('Pedidos'),
                leading: Icon(Icons.shopping_basket),
              ),
            ),

            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Carrito()));
              },
              child: ListTile(
                title: Text('Carrito'),
                leading: Icon(Icons.shopping_cart),
              ),
            ),

            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text('Categorías'),
                leading: Icon(Icons.dashboard),
              ),
            ),

            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text('Favoritos'),
                leading: Icon(Icons.favorite),
              ),
            ),

            //Separacion entre categorias
            Divider(),

            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text('Opciones'),
                leading: Icon(Icons.settings, color: Colors.blue),
              ),
            ),

            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text('Sobre mí'),
                leading: Icon(Icons.help, color: Colors.red),
              ),
            ),

            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text('Otros trabajos'),
                leading: Icon(Icons.brush, color: Colors.red),
              ),
            ),

            InkWell(
              onTap: () async {
                await auth.signout();
                goToLogin(context);
              },
              child: ListTile(
                title: Text('Cerrar sesión'),
                leading: Icon(Icons.brush, color: Colors.red),
              ),
            ),
          ],
        ),
      ),

      //Cerpo para colocar el carrusel
      body: ListView(
        children: [
          carrusel_imagen,
          //Padding para alejar el texto de los bordes
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text('Categorias'),
          ),

          //Lista horizontal llamada desde componentes
          ListaHorizontal(),

          Padding(
            padding: const EdgeInsets.all(8),
            child: Text('Productos Recientes'),
          ),

          //Cuerpo de productos recientes
          Container(
            height: 320,
            child: Productos(),
          )
        ],
      ),
    );
  }

  goToLogin(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
}
