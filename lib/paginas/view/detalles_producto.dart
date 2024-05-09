import 'package:tienda3/paginas/helpers/common.dart';
import 'package:tienda3/paginas/helpers/style.dart';
import 'package:tienda3/paginas/model/poducto.dart';
import 'package:tienda3/paginas/provider/app.dart';
import 'package:tienda3/paginas/provider/user.dart';
import 'package:tienda3/paginas/view/carrito.dart';
import 'package:tienda3/widgets/custom_text.dart';
import 'package:tienda3/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class ProductDetails extends StatefulWidget {
  final ProductModel product;

  const ProductDetails({Key? key, required this.product}) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  late String _color;
  late String _size;
  final OrderServices _orderServices = OrderServices();

  @override
  void initState() {
    super.initState();
    _color = widget.product.colors.first; // Acceder al primer elemento
    _size = widget.product.sizes.first; // Acceder al primer elemento
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Loading(), // Indicador de carga
                  ),
                ),
                Center(
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: widget.product.picture, // Imagen del producto
                    fit: BoxFit.fill,
                    height: 400,
                    width: double.infinity,
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.black.withOpacity(0.5),
                          Colors.black.withOpacity(0.07),
                          Colors.black.withOpacity(0.05),
                          Colors.black.withOpacity(0.025),
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  child: InkWell(
                    onTap: () {
                      changeScreen(context, CartScreen());
                    },
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.shopping_cart),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 120,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context); // Cerrar la pantalla
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(35),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(2, 5),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(0),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: CustomText(
                              text: "Select a Color",
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: DropdownButton<String>(
                                value: _color,
                                style: TextStyle(color: Colors.white),
                                items: widget.product.colors.map((value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: CustomText(
                                      text: value,
                                      color: Colors.red,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _color = value ?? _color; // Manejo de posibles valores nulos
                                  });
                                }),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(0),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: CustomText(
                              text: "Select a Size",
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: DropdownButton<String>(
                                value: _size,
                                style: TextStyle(color: Colors.white),
                                items: widget.product.sizes.map((value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: CustomText(
                                      text: value,
                                      color: Colors.red,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _size = value ?? _size; // Manejo de posibles valores nulos
                                  });
                                }),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Description:\nLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry standard dummy text ever since the 1500s  Lorem Ipsum has been the industry standard dummy text ever since the 1500s ',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(9),
                      child: ElevatedButton(
                        onPressed: () async {
                          appProvider.changeIsLoading(); // Manejo de estado
                          bool success = await userProvider.addToCart(
                            product: widget.product,
                            color: _color,
                            size: _size,
                          );
                          if (success) {
                            _scaffoldKey.currentState?.showSnackBar(
                              SnackBar(content: Text("Added to Cart!")),
                            );
                            await userProvider.reloadUserModel(); // Asegurar recarga del modelo
                            appProvider.changeIsLoading();
                          } else {
                            _scaffoldKey.currentState?.showSnackBar(
                              SnackBar(content: Text("Not added to Cart!")),
                            );
                            appProvider.changeIsLoading();
                          }
                        },
                        child: appProvider.isLoading
                            ? Loading() // Mostrar indicador de carga si está cargando
                            : CustomText(
                                text: "Add to Cart",
                                size: 20,
                                weight: FontWeight.bold,
                              ),
                      ),
                    ),
                    SizedBox(height: 20), // Espacio adicional al final
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
