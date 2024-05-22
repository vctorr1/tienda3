import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tienda3/paginas/provider/app.dart';
import 'package:tienda3/paginas/provider/user.dart';
import 'package:tienda3/paginas/services/order.dart';
import 'package:tienda3/widgets/custom_text.dart';
import 'package:tienda3/widgets/loading.dart';
import 'package:uuid/uuid.dart';
import 'package:tienda3/paginas/model/producto_carrito.dart';

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

    Future<void> _handlePayment() async {
      if (userProvider.userModel.totalCartPrice == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('El carrito está vacío')),
        );
        return;
      }

      final String userId = userProvider.userModel.id;
      if (userId.isEmpty) {
        print('Error: userId está vacío');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: userId está vacío')),
        );
        return;
      }

      final String orderId = Uuid().v4();
      final String description = "Pedido de prueba";
      final String status = "Pendiente";
      final int totalPrice = userProvider.userModel.totalCartPrice;
      final List<CartItemModel> cartItems = userProvider.userModel.cart;

      appProvider.changeIsLoading();

      try {
        await _orderServices.createOrder(
          userId: userId,
          id: orderId,
          description: description,
          status: status,
          cart: cartItems,
          totalPrice: totalPrice,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pedido creado con éxito')),
        );

        userProvider.clearCart();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear el pedido')),
        );
      } finally {
        appProvider.changeIsLoading();
      }
    }

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
                          child: imageUrl.isNotEmpty
                              ? Image.network(
                                  imageUrl,
                                  height: 120,
                                  width: 140,
                                  fit: BoxFit.fill,
                                )
                              : Placeholder(
                                  fallbackWidth: 140,
                                  fallbackHeight: 120,
                                ),
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
                                    ScaffoldMessenger.of(context).showSnackBar(
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
                onPressed: () async {
                  if (userProvider.userModel.totalCartPrice == 0) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            child: Container(
                              height: 200,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          'Tu carrito está vacío',
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                    return;
                  }
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          child: Container(
                            height: 200,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Serás cobrado ${userProvider.userModel.totalCartPrice / 100}€ al momento de la entrega.',
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    width: 320.0,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        await _handlePayment();
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "Aceptar",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFF1BC0C5)),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 320.0,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "Rechazar",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
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
