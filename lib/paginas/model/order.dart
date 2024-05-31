import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  static const ID = "id";
  static const DESCRIPTION = "descripcion";
  static const CART = "cart";
  static const USER_ID = "userId";
  static const TOTAL = "total";
  static const STATUS = "status";
  static const CREATED_AT = "createdAt";

  late final String _id;
  late final String _description;
  late final String _userId;
  late final String _status;
  late final int _createdAt;
  late final int _total;

  // Getters para acceder a las propiedades privadas
  String get id => _id;
  String get description => _description;
  String get userId => _userId;
  String get status => _status;
  int get total => _total;
  int get createdAt => _createdAt;

  // Variable pública para almacenar el carrito
  late final List<dynamic> cart;

  OrderModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data =
        snapshot.data() as Map<String, dynamic>; // Asegúrate de que es un Map

    _id = data[ID] ?? ""; // Uso de `??` para manejar valores nulos
    _description = data[DESCRIPTION] ?? "";
    _total = data[TOTAL] ?? 0; // Asegúrate de que sea del tipo correcto
    _status = data[STATUS] ?? "";
    _userId = data[USER_ID] ?? "";
    _createdAt = data[CREATED_AT] ?? 0;
    cart = data[CART] ?? []; // Asegúrate de inicializar las listas
  }
}
