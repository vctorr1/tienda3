import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tienda3/paginas/provider/app.dart';
import 'package:tienda3/paginas/provider/user.dart';
import 'package:tienda3/paginas/services/order.dart';
import 'package:tienda3/widgets/custom_text.dart';
import 'package:tienda3/widgets/loading.dart';
import 'package:uuid/uuid.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  final OrderServices _orderServices = OrderServices();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: CustomText(text: "Carrito"),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: appProvider.isLoading
          ? Loading()
          : ListView.builder(
              itemCount: userProvider.userModel.cart.length,
              itemBuilder: (_, index) {
                final cartItem = userProvider.userModel.cart[index];
                final imageUrl = cartItem.image;

                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.2),
                          offset: Offset(3, 2),
                          blurRadius: 30,
                        ),
                      ],
                    ),
                    child: Row(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            topLeft: Radius.circular(20),
                          ),
                          child: imageUrl
                                  .isNotEmpty // Verificar si la URL no está vacía
                              ? Image.network(
                                  imageUrl,
                                  height: 120,
                                  width: 140,
                                  fit: BoxFit.fill,
                                )
                              : Placeholder(
                                  fallbackWidth: 140,
                                  fallbackHeight:
                                      120), // Placeholder si no hay imagen
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "${cartItem.name}\n",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "${cartItem.price / 100}€ \n\n",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  appProvider.changeIsLoading();
                                  bool success =
                                      await userProvider.removeFromCart(
                                    cartItem: cartItem,
                                  );
                                  if (success) {
                                    await userProvider.reloadUserModel();
                                    _scaffoldKey.currentState?.showSnackBar(
                                      SnackBar(
                                          content:
                                              Text("Eliminado del carrito")),
                                    );
                                    appProvider.changeIsLoading();
                                  } else {
                                    appProvider.changeIsLoading();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: Container(
        height: 70,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Total: ",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: "${userProvider.userModel.totalCartPrice / 100}€",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                onPressed: () {
                  if (userProvider.userModel.totalCartPrice == 0) {
                    // Mostrar diálogo si el carrito está vacío
                  } else {
                    // Mostrar diálogo para continuar
                  }
                },
                child: CustomText(
                  text: "Pagar",
                  size: 20,
                  color: Colors.white,
                  weight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
