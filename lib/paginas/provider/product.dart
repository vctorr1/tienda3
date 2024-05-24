import 'package:tienda3/paginas/model/producto.dart';
import 'package:tienda3/paginas/services/product.dart';
import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  ProductServices _productServices = ProductServices();
  List<ProductModel> products = [];
  List<ProductModel> productsSearched = [];
  List<String> categories = [];

  ProductProvider.initialize() {
    loadProducts();
    loadCategories();
  }

  loadProducts() async {
    products = await _productServices.getProducts();
    notifyListeners();
  }

  loadCategories() async {
    categories = await _productServices.getCategories();
    notifyListeners();
  }

  List<ProductModel> getProductsByCategory(String category) {
    return products.where((product) => product.category == category).toList();
  }

  Future search({String productName = ""}) async {
    // Convertir a minúsculas para hacer la búsqueda insensible a mayúsculas
    String lowerCaseName = productName.toLowerCase();

    // Realizar búsqueda insensible a mayúsculas
    productsSearched = products.where((product) {
      return product.name.toLowerCase().contains(lowerCaseName);
    }).toList();

    notifyListeners();
  }
}
