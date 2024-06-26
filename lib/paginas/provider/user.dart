import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:tienda3/paginas/model/producto_carrito.dart';
import 'package:tienda3/paginas/model/order.dart';
import 'package:tienda3/paginas/model/producto.dart';
import 'package:tienda3/paginas/model/user_model.dart';
import 'package:tienda3/paginas/services/usuarios.dart';
import 'package:tienda3/paginas/services/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class UserProvider with ChangeNotifier {
  FirebaseAuth _auth;
  User? _user; // Usar variable opcional para manejar valores nulos
  Status _status = Status.Uninitialized;
  final UserServices _userServices = UserServices();
  final OrderServices _orderServices = OrderServices();
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Añadir esta línea

  late UserModel _userModel; // Se inicializa más adelante

  // Getters
  UserModel get userModel => _userModel;
  Status get status => _status;
  User? get user => _user; // Usar variable opcional para manejar valores nulos

  // Public variables
  List<OrderModel> orders = [];

  UserProvider.initialize() : _auth = FirebaseAuth.instance {
    _auth
        .authStateChanges()
        .listen(_onStateChanged); // Escuchar cambios en la autenticación
  }

  Future<void> loadUser() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('usuarios').doc(currentUser.uid).get();
      _userModel = UserModel.fromSnapshot(userDoc);
      notifyListeners();
    }
  }

  Future<bool> signIn(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();

      var result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _user = result.user;
      if (_user != null) {
        _userModel = await _userServices.getUserById(_user!.uid);
        notifyListeners();
      }

      _status = Status.Authenticated;
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  Future<bool> signUp(String name, String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();

      var result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      _user = result.user;
      if (_user != null) {
        print("Crear usuario");
        await _userServices.createUser({
          'usuario': name,
          'email': email,
          'id': _user!.uid,
          'stripeId': '',
        });

        _userModel = await _userServices.getUserById(_user!.uid);
        notifyListeners();
      }

      _status = Status.Authenticated;
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  Future<void> resetPassword({required String email}) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e); // Lanzar una excepción para manejo fuera
    }
  }

  Future<void> _onStateChanged(User? user) async {
    if (user == null) {
      _status = Status.Unauthenticated;
    } else {
      _user = user;
      _userModel = await _userServices.getUserById(user.uid);
      _status = Status.Authenticated;
    }
    notifyListeners();
  }

  Future<bool> addToCart({
    required ProductModel product,
    required String size,
    required String color,
  }) async {
    try {
      if (_user == null) {
        // No hay usuario autenticado, no se puede agregar al carrito
        return false;
      }
      var uuid = Uuid();
      String cartItemId = uuid.v4();

      CartItemModel item = CartItemModel.fromMap({
        "id": cartItemId,
        "nombre": product.name,
        "imagenes": product.pictures,
        "productId": product.id,
        "precio": product.price,
        "tallas": size,
        "color": color,
      });

      await _userServices.addToCart(
        userId: _user!.uid,
        cartItem: item,
      );

      return true;
    } catch (e) {
      print("El error ${e.toString()}");
      return false;
    }
  }

  Future<bool> removeFromCart({
    required CartItemModel cartItem,
  }) async {
    try {
      if (_user == null) {
        // No hay usuario autenticado, no se puede eliminar del carrito
        return false;
      }
      await _userServices.removeFromCart(
        userId: _user!.uid,
        cartItem: cartItem,
      );
      return true;
    } catch (e) {
      print("El error ${e.toString()}");
      return false;
    }
  }

  Future<void> getOrders() async {
    if (_user != null) {
      orders = await _orderServices.getUserOrders(
        userId: _user!.uid,
      );
      notifyListeners();
    }
  }

  Future<void> reloadUserModel() async {
    if (_user != null) {
      _userModel = await _userServices.getUserById(_user!.uid);
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future<void> clearCart() async {
    if (_userModel.cart.isNotEmpty) {
      _userModel.cart.clear();
      await _firestore.collection('usuarios').doc(_user!.uid).update({
        'carrito': [],
      });
      notifyListeners();
    }
  }
}
