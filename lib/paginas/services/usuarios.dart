import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tienda3/paginas/model/producto_carrito.dart';
import 'package:tienda3/paginas/model/user_model.dart';

class UserServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collection = "usuarios";

  Future<void> createUser(Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collection).doc(data["id"]).set(data);
      print("Usuario creado");
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }

  Future<UserModel> getUserById(String id) async {
    if (id == null || id.isEmpty) {
      throw Exception("El usuario no puede estar vacío");
    }

    try {
      DocumentSnapshot doc =
          await _firestore.collection(collection).doc(id).get();

      if (doc.exists && doc.data() != null) {
        return UserModel.fromSnapshot(doc);
      } else {
        throw Exception("Usuario no encontrado");
      }
    } catch (e) {
      print("Error: ${e.toString()}");

      throw Exception(
          "Usuario no encontrado"); // Lanzar una excepción para manejo fuera
    }
  }

  Future<void> addToCart({
    required String userId,
    required CartItemModel cartItem,
  }) async {
    await _firestore.collection(collection).doc(userId).update({
      "carrito": FieldValue.arrayUnion([cartItem.toMap()]),
    });
  }

  Future<void> removeFromCart({
    required String userId,
    required CartItemModel cartItem,
  }) async {
    await _firestore.collection(collection).doc(userId).update({
      "carrito": FieldValue.arrayRemove([cartItem.toMap()]),
    });
  }
}
