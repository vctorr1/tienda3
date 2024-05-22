import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tienda3/paginas/helpers/style.dart';
import 'package:tienda3/paginas/model/order.dart';
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

  ListTile _buildOrderTile(OrderModel order) {
    return ListTile(
      leading: CustomText(
        text: "${order.total / 100}€",
        weight: FontWeight.bold,
      ),
      title: CustomText(
        text: order.description,
        weight: FontWeight.w500,
      ),
      subtitle: CustomText(
        text: "Creado en ${_formatDate(order.createdAt)}",
      ),
      trailing: CustomText(
        text: order.status,
        color: _getStatusColor(order.status),
        weight: FontWeight.bold,
      ),
    );
  }

  String _formatDate(int milliseconds) {
    final date = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    return "${date.day}/${date.month}/${date.year}";
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "Completado":
        return Colors.green;
      case "Pendiente":
        return Colors.orange;
      case "Cancelado":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
