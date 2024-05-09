import 'package:cloud_firestore/cloud_firestore.dart';
import 'producto_carrito.dart';

class UserModel {
  static const ID = "uid";
  static const NAME =
      "usuario"; // Cambió de 'name' a 'nombre' para ser consistente
  static const EMAIL = "email";
  static const STRIPE_ID = "stripeId";
  static const CART = "cart";

  String _name = "";
  String _email = "";
  String _id = "";
  String _stripeId = "";
  int _priceSum = 0;

//  getters
  String get name => _name;
  String get email => _email;
  String get id => _id;
  String get stripeId => _stripeId;

// public variables
  late List<CartItemModel> cart;
  late int totalCartPrice;

  UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data()
        as Map<String, dynamic>; // Asegúrate de que data es un Map

    _name = data[NAME] ?? "";
    _email = data[EMAIL] ?? "";
    _id = data[ID] ?? "";
    _stripeId = data[STRIPE_ID] ?? "";

    cart = _convertCartItems(data[CART] ?? []); // Manejo de valores nulos
    totalCartPrice =
        getTotalPrice(cart: cart); // Asegúrate de usar 'cart' correctamente
  }

  List<CartItemModel> _convertCartItems(List cart) {
    List<CartItemModel> convertedCart = [];
    for (var cartItem in cart) {
      // Asegúrate de usar 'var' para elementos del loop
      if (cartItem is Map<String, dynamic>) {
        // Asegúrate de que es un Map con tipo correcto
        convertedCart.add(CartItemModel.fromMap(cartItem));
      }
    }
    return convertedCart;
  }

  int getTotalPrice({required List<CartItemModel> cart}) {
    _priceSum = 0; // Reiniciar _priceSum para evitar acumulación
    for (var cartItem in cart) {
      _priceSum += cartItem.price; // Asegúrate de que es un int
    }

    return _priceSum;
  }
}
