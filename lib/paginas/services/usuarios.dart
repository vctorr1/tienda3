import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tienda3/paginas/model/producto_carrito.dart';
import 'package:tienda3/paginas/model/user_model.dart';

class UserServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collection = "users";

  Future<void> createUser(Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collection).doc(data["uid"]).set(data);
      print("USER WAS CREATED");
    } catch (e) {
      print('ERROR: ${e.toString()}');
    }
  }

  Future<UserModel> getUserById(String id) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection(collection).doc(id).get();

      if (doc.exists && doc.data() != null) {
        return UserModel.fromSnapshot(doc);
      } else {
        throw Exception("User not found");
      }
    } catch (e) {
      print("ERROR: ${e.toString()}");
      throw Exception("User not found"); // Lanzar excepción para manejo fuera
    }
  }

  Future<void> addToCart({
    required String userId,
    required CartItemModel cartItem,
  }) async {
    await _firestore.collection(collection).doc(userId).update({
      "cart": FieldValue.arrayUnion([cartItem.toMap()]),
    });
  }

  Future<void> removeFromCart({
    required String userId,
    required CartItemModel cartItem,
  }) async {
    await _firestore.collection(collection).doc(userId).update({
      "cart": FieldValue.arrayRemove([cartItem.toMap()]),
    });
  }
}
