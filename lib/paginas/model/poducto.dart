import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  static const ID = "id";
  static const NAME = "nombre"; // Corregido de "nmbre"
  static const PICTURE = "imagen";
  static const PRICE = "precio";
  static const DESCRIPTION = "descripcion";
  static const CATEGORY = "categoria";
  static const FEATURED = "featured";
  static const QUANTITY = "cantidad";
  static const BRAND = "marca";
  static const SALE = "sale";
  static const SIZES = "tallas";
  static const COLORS = "color";

  String _id = "";
  String _name = "";
  String _picture = "";
  String _description = "";
  String _category = "";
  String _brand = "";
  int _quantity = 0;
  int _price = 0;
  bool _sale = false;
  bool _featured = false;
  List _colors = [];
  List _sizes = [];

  String get id => _id;
  String get name => _name;
  String get picture => _picture;
  String get brand => _brand;
  String get category => _category;
  String get description => _description;
  int get quantity => _quantity;
  int get price => _price;
  bool get featured => _featured;
  bool get sale => _sale;
  List get colors => _colors;
  List get sizes => _sizes;

  ProductModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data =
        snapshot.data() as Map<String, dynamic>; // Asegura que data es un Map

    _id = data[ID] ?? "";
    _brand = data[BRAND] ?? "";
    _sale = data[SALE] ?? false;
    _description = data[DESCRIPTION] ?? " "; // Manejo de valores nulos
    _featured = data[FEATURED] ?? false;
    _price =
        (data[PRICE] ?? 0).floor(); // Manejo de valores nulos y asegurar int
    _category = data[CATEGORY] ?? "";
    _colors = data[COLORS] ?? [];
    _sizes = data[SIZES] ?? [];
    _name = data[NAME] ?? "";
    _picture = data[PICTURE] ?? "";
  }
}
