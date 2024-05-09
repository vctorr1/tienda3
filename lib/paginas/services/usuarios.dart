import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tienda3/paginas/model/producto_carrito.dart';
import 'package:tienda3/paginas/model/user_model.dart';

class UserServices {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Cambio a FirebaseFirestore
  final String collection = "users";

  // Crear usuario con manejo de errores
  Future<void> createUser(Map<String, dynamic> data) async {
    try {
      await _firestore
          .collection(collection)
          .doc(data["uid"])
          .set(data); // Uso de `doc` y `set`
      print("USER WAS CREATED");
    } catch (e) {
      print('ERROR: ${e.toString()}');
    }
  }

  // Obtener usuario por ID
  Future<UserModel> getUserById(String id) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection(collection).doc(id).get();

      // Comprobación de existencia del documento y datos
      if (doc.exists && doc.data() != null) {
        var data = doc.data()
            as Map<String, dynamic>; // Asegúrate de que `data` es un `Map`

        // Uso de `debugPrint` para depuración, evitando repeticiones
        debugPrint("==========NAME is ${data['name']}=============");

        return UserModel.fromSnapshot(doc); // Devuelve el modelo de usuario
      } else {
        throw Exception("User not found");
      }
    } catch (e) {
      print("ERROR: ${e.toString()}");
      rethrow; // Lanza de nuevo la excepción para manejo por el llamador
    }
  }

  // Añadir al carrito
  Future<void> addToCart({
    required String userId,
    required CartItemModel cartItem,
  }) async {
    await _firestore.collection(collection).doc(userId).update({
      "cart": FieldValue.arrayUnion([cartItem.toMap()]), // Uso de `update`
    });
  }

  // Eliminar del carrito
  Future<void> removeFromCart({
    required String userId,
    required CartItemModel cartItem,
  }) async {
    await _firestore.collection(collection).doc(userId).update({
      "cart": FieldValue.arrayRemove([cartItem.toMap()]), // Uso de `update`
    });
  }
}
