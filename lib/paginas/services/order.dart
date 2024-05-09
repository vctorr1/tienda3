import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tienda3/paginas/model/producto_carrito.dart';
import 'package:tienda3/paginas/model/order.dart';

class OrderServices {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Correcto uso
  final String collection = "orders";

  Future<void> createOrder({
    required String userId,
    required String id,
    required String description,
    required String status,
    required List<CartItemModel> cart,
    required int totalPrice,
  }) async {
    try {
      // Convertimos la lista de CartItemModel a List<Map<String, dynamic>>
      List<Map<String, dynamic>> convertedCart =
          cart.map((item) => item.toMap() as Map<String, dynamic>).toList();

      await _firestore.collection(collection).doc(id).set({
        "userId": userId,
        "id": id,
        "cart": convertedCart,
        "total": totalPrice,
        "createdAt": DateTime.now().millisecondsSinceEpoch,
        "description": description,
        "status": status,
      });
    } catch (e) {
      print('Error creating order: ${e.toString()}'); // Manejo de errores
    }
  }

  Future<List<OrderModel>> getUserOrders({required String userId}) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(collection)
          .where("userId", isEqualTo: userId)
          .get();

      List<OrderModel> orders = [];
      for (var doc in querySnapshot.docs) {
        orders.add(OrderModel.fromSnapshot(doc));
      }
      return orders;
    } catch (e) {
      print('Error getting user orders: ${e.toString()}');
      return [];
    }
  }
}
