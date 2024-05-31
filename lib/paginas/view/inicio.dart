import 'package:tienda3/paginas/helpers/common.dart';
import 'package:tienda3/paginas/helpers/style.dart';
import 'package:tienda3/paginas/provider/product.dart';
import 'package:tienda3/paginas/provider/user.dart';
import 'package:tienda3/paginas/view/product_search.dart';
import 'package:tienda3/paginas/services/product.dart';
import 'package:tienda3/widgets/custom_text.dart';
import 'package:tienda3/widgets/featured_products.dart';
import 'package:tienda3/widgets/product_card.dart';
import 'package:tienda3/widgets/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

import 'categorias.dart';

import 'carrito.dart';
import 'order.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _key = GlobalKey<ScaffoldState>();
  ProductServices _productServices = ProductServices();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      key: _key,
      backgroundColor: white,
      endDrawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.black),
              accountName: CustomText(
                text: userProvider.userModel?.name ?? "Nombre cargando...",
                color: white,
                weight: FontWeight.bold,
                size: 18,
              ),
              accountEmail: CustomText(
                text: userProvider.userModel?.email ?? "Email cargando...",
                color: white,
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CategoryPage()),
                );
              },
              leading: Icon(Icons.category),
              title: CustomText(text: "Categorías"),
            ),
            ListTile(
              onTap: () async {
                await userProvider.getOrders();
                changeScreen(context, OrdersScreen());
              },
              leading: Icon(Icons.bookmark_border),
              title: CustomText(text: "Mis pedidos"),
            ),
            ListTile(
              onTap: () {
                userProvider.signOut();
              },
              leading: Icon(Icons.exit_to_app),
              title: CustomText(text: "Cerrar sesión"),
            ),
            ListTile(
              onTap: () {},
              leading: Icon(Icons.help),
              title: CustomText(text: "Sobre nosotros"),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
//           Custom App bar
            Stack(
              children: <Widget>[
                Positioned(
                  top: 10,
                  right: 20,
                  child: Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                          onTap: () {
                            _key.currentState!.openEndDrawer();
                          },
                          child: Icon(Icons.menu))),
                ),
                Positioned(
                  top: 10,
                  right: 60,
                  child: Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                          onTap: () {
                            changeScreen(context, CartScreen());
                          },
                          child: Icon(Icons.shopping_cart))),
                ),
                Positioned(
                  top: 10,
                  right: 100,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Mi perfil")),
                        );
                      },
                      child: Icon(Icons
                          .person), // Solo un ejemplo para el contenido del GestureDetector
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'MÚDEZ',
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.black.withOpacity(0.6),
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),

//          Search Text field
//            Search(),

            Container(
              decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20))),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 8, left: 8, right: 8, bottom: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.search,
                      color: black,
                    ),
                    title: TextField(
                      textInputAction: TextInputAction.search,
                      onSubmitted: (pattern) async {
                        await productProvider.search(productName: pattern);
                        changeScreen(context, ProductSearchScreen());
                      },
                      decoration: InputDecoration(
                        hintText: "¿Qué buscas?",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),

//            featured products
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Container(
                      alignment: Alignment.centerLeft,
                      child: new Text('Productos Destacados')),
                ),
              ],
            ),
            FeaturedProducts(),

//          recent products
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Container(
                      alignment: Alignment.centerLeft,
                      child: new Text('Productos Recientes')),
                ),
              ],
            ),

            Column(
              children: productProvider.products
                  .map((item) => GestureDetector(
                        child: ProductCard(
                          product: item,
                        ),
                      ))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }
}
//Row(
//mainAxisAlignment: MainAxisAlignment.end,
//children: <Widget>[
//GestureDetector(
//onTap: (){
//key.currentState.openDrawer();
//},
//child: Icon(Icons.menu))
//],
//),