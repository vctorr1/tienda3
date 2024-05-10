import 'package:flutter/material.dart';
import 'package:tienda3/paginas/helpers/common.dart';
import 'package:tienda3/paginas/helpers/style.dart';
import 'package:tienda3/paginas/model/producto.dart';
import 'package:tienda3/paginas/provider/app.dart';
import 'package:tienda3/paginas/provider/user.dart';
import 'package:tienda3/paginas/view/carrito.dart';
import 'package:tienda3/widgets/custom_text.dart';
import 'package:tienda3/widgets/loading.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class ProductDetails extends StatefulWidget {
  final ProductModel product;

  const ProductDetails({Key? key, required this.product}) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  late String _color;
  late String _size;

  @override
  void initState() {
    super.initState();
    // Manejo de valores nulos o listas vacías
    _color =
        widget.product.colors.isNotEmpty ? widget.product.colors.first : "";
    _size = widget.product.sizes.isNotEmpty ? widget.product.sizes.first : "";
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
                      child: Loading(),
                    ),
                  ),
                  Center(
                    child: FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: widget.product.pictures.first,
                      fit: BoxFit.cover,
                      height: 400,
                      width: double.infinity,
                    ),
                  ),
                  Positioned(
                    top: 120,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(
                              context); // Cerrar el detalle del producto
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
                  ),
                  Positioned(
                    right: 0,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: () {
                          changeScreen(context,
                              CartScreen()); // Cambio a la pantalla del carrito
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
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          children: <Widget>[
                            CustomText(
                              text: "Select a Color",
                              color: Colors.white,
                            ),
                            DropdownButton<String>(
                              value: _color,
                              style: TextStyle(color: Colors.white),
                              items: widget.product.colors.map((color) {
                                return DropdownMenuItem<String>(
                                  value:
                                      color, // Asegúrate de que el valor es `String`
                                  child: CustomText(
                                    text: color,
                                    color: Colors.red,
                                  ),
                                );
                              }).toList(), // Asegúrate de retornar `List<DropdownMenuItem<String>>`
                              onChanged: (String? value) {
                                setState(() {
                                  _color = value ??
                                      _color; // Manejo de valores nulos
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          children: <Widget>[
                            CustomText(
                              text: "Select a Size",
                              color: Colors.white,
                            ),
                            DropdownButton<String>(
                              value: _size,
                              style: TextStyle(color: Colors.white),
                              items: widget.product.sizes.map((size) {
                                return DropdownMenuItem<String>(
                                  value:
                                      size, // Asegúrate de que el valor es `String`
                                  child: CustomText(
                                    text: size,
                                    color: Colors.red,
                                  ),
                                );
                              }).toList(), // Asegúrate de retornar `List<DropdownMenuItem<String>>`
                              onChanged: (String? value) {
                                setState(() {
                                  _size =
                                      value ?? _size; // Manejo de valores nulos
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Description:\n${widget.product.description}.',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(9),
                        child: ElevatedButton(
                          onPressed: () async {
                            appProvider.changeIsLoading(); // Cambio de estado
                            bool success = await userProvider.addToCart(
                              product: widget.product,
                              color: _color,
                              size: _size,
                            );
                            if (success) {
                              _scaffoldKey.currentState?.showSnackBar(
                                SnackBar(content: Text("Added to Cart!")),
                              );
                              await userProvider
                                  .reloadUserModel(); // Recargar modelo
                              appProvider.changeIsLoading();
                            } else {
                              _scaffoldKey.currentState?.showSnackBar(
                                SnackBar(content: Text("Not added to Cart!")),
                              );
                              appProvider.changeIsLoading();
                            }
                          },
                          child: appProvider.isLoading
                              ? Loading() // Mostrar indicador de carga
                              : CustomText(
                                  text: "Add to Cart",
                                  size: 20,
                                  weight: FontWeight.bold,
                                ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
