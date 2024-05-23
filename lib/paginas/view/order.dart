import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tienda3/paginas/helpers/style.dart';
import 'package:tienda3/paginas/model/order.dart';
import 'package:tienda3/paginas/model/producto_carrito.dart';
import 'package:tienda3/paginas/provider/user.dart';
import 'package:tienda3/widgets/custom_text.dart';
import 'package:tienda3/widgets/loading.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    if (userProvider.orders.isEmpty) {
      // Mostrar mensaje cuando no hay pedidos
      return Scaffold(
        appBar: _buildAppBar(context),
        body: Center(
          child: CustomText(
            text: "No hay pedidos",
            size: 18,
            color: Colors.grey,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: _buildAppBar(context),
      body: ListView.builder(
        itemCount: userProvider.orders.length,
        itemBuilder: (_, index) {
          final OrderModel order = userProvider.orders[index];
          return _buildOrderTile(order);
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.black),
      backgroundColor: Colors.white,
      elevation: 0.0,
      title: CustomText(text: "Pedidos", size: 20, weight: FontWeight.bold),
      leading: IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildOrderTile(OrderModel order) {
    // Convertir el carrito de mapas a una lista de CartItemModel
    List<CartItemModel> cartItems = order.cart.map<CartItemModel>((item) {
      return CartItemModel.fromMap(item);
    }).toList();

    return ExpansionTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CustomText(
            text: "${order.total / 100}€",
            weight: FontWeight.bold,
          ),
          CustomText(
            text: order.description,
            weight: FontWeight.w500,
          ),
          CustomText(
            text: "Creado en ${_formatDate(order.createdAt)}",
          ),
        ],
      ),
      trailing: CustomText(
        text: order.status,
        color: _getStatusColor(order.status),
        weight: FontWeight.bold,
      ),
      children: _buildOrderItems(cartItems),
    );
  }

  List<Widget> _buildOrderItems(List<CartItemModel> cartItems) {
    return cartItems.map((cartItem) {
      return ListTile(
        leading: cartItem.image.isNotEmpty
            ? Image.network(cartItem.image,
                width: 50, height: 50, fit: BoxFit.cover)
            : Placeholder(fallbackWidth: 50, fallbackHeight: 50),
        title: CustomText(
          text: cartItem.name,
          weight: FontWeight.w500,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CustomText(
              text: "${cartItem.price / 100}€",
            ),
            CustomText(
              text: "Tamaño: ${cartItem.size}, Color: ${cartItem.color}",
            ),
          ],
        ),
      );
    }).toList();
  }

  String _formatDate(int milliseconds) {
    final date = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    return "${date.day}/${date.month}/${date.year}";
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "completado":
        return Colors.green;
      case "pendiente":
        return Colors.orange;
      case "cancelado":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
