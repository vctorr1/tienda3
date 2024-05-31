import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tienda3/paginas/model/producto.dart';

class ProductServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collection = "productos";

  // Obtener todos los productos
  Future<List<ProductModel>> getProducts() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection(collection).get();
      List<ProductModel> products = [];
      for (var doc in querySnapshot.docs) {
        products.add(ProductModel.fromSnapshot(doc));
      }
      return products;
    } catch (e) {
      print("Error consiguiendo productos: ${e.toString()}");
      return [];
    }
  }

  // Obtener todas las categorías
  Future<List<String>> getCategories() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection(collection).get();
      Set<String> categories = Set();
      for (var doc in querySnapshot.docs) {
        categories
            .add(doc['categoria']); // Asegúrate de que el campo es correcto
      }
      return categories.toList();
    } catch (e) {
      print("Error consiguiendo categorías: ${e.toString()}");
      return [];
    }
  }

  // Buscar productos por nombre
  Future<List<ProductModel>> searchProducts({String productName = ""}) async {
    QuerySnapshot snapshot = await _firestore
        .collection(collection)
        .where('nombre', isGreaterThanOrEqualTo: productName)
        .where('nombre', isLessThanOrEqualTo: productName + '\uf8ff')
        .get();
    return snapshot.docs.map((doc) => ProductModel.fromSnapshot(doc)).toList();
  }
}
