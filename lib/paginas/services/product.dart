import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tienda3/paginas/model/poducto.dart'; // Asegúrate de que la importación sea correcta

class ProductServices {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Correcto uso de FirebaseFirestore
  final String collection = "products"; // Convierte a `final`

  // Obtener todos los productos
  Future<List<ProductModel>> getProducts() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection(collection).get(); // Uso de `get()`

      List<ProductModel> products = [];
      for (var doc in querySnapshot.docs) {
        // Cambiar de `documents` a `docs`
        products.add(ProductModel.fromSnapshot(
            doc)); // Asegurarse de que `ProductModel.fromSnapshot` esté correcto
      }
      return products;
    } catch (e) {
      print("Error getting products: ${e.toString()}"); // Manejo de errores
      return [];
    }
  }

  // Buscar productos por nombre
  Future<List<ProductModel>> searchProducts(
      {required String productName}) async {
    try {
      // Asegurarse de que `productName` no sea nulo
      if (productName.isEmpty) {
        return [];
      }

      // Convierte la primera letra a mayúscula para la búsqueda
      String searchKey =
          productName[0].toUpperCase() + productName.substring(1);

      QuerySnapshot querySnapshot = await _firestore
          .collection(collection)
          .orderBy("name") // Asegúrate de que "name" esté indexado en Firestore
          .startAt([searchKey]).endAt([searchKey + '\uf8ff']).get();

      List<ProductModel> products = [];
      for (var doc in querySnapshot.docs) {
        products.add(ProductModel.fromSnapshot(doc));
      }
      return products;
    } catch (e) {
      print("Error searching products: ${e.toString()}");
      return [];
    }
  }
}
