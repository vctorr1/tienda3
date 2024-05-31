import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  static const ID = "id";
  static const NAME = "nombre";
  static const PICTURE = "imagenes";
  static const PRICE = "precio";
  static const DESCRIPTION = "descripcion";
  static const CATEGORY = "categoria";
  static const FEATURED = "featured";
  static const QUANTITY = "cantidad";
  static const BRAND = "marca";
  static const SALE = "oferta";
  static const SIZES = "tallas";
  static const COLORS = "color";

  late String _id; // Marcado como `late`
  late String _name;
  late List<String> _pictures; // Cambiado a `List<String>`
  late String _description;
  late String _category;
  late String _brand;
  late int _quantity;
  late int _price;
  late bool _sale;
  late bool _featured;
  late List<String> _colors; // Asegurado como `List<String>`
  late List<String> _sizes;

  // Getters para acceder a los atributos
  String get id => _id;
  String get name => _name;
  List<String> get pictures => _pictures;
  String get description => _description;
  String get category => _category;
  String get brand => _brand;
  int get quantity => _quantity;
  int get price => _price;
  bool get sale => _sale;
  bool get featured => _featured;
  List<String> get colors => _colors;
  List<String> get sizes => _sizes;

  // Constructor desde un documento de Firestore
  ProductModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    _id = data[ID] ?? "";
    _name = data[NAME] ?? "";
    _pictures = List<String>.from(data[PICTURE] ?? []);
    _description = data[DESCRIPTION] ?? "";
    _category = data[CATEGORY] ?? "";
    _brand = data[BRAND] ?? "";
    _quantity = (data[QUANTITY] ?? 0);
    _price = (data[PRICE] ?? 0).floor();
    _sale = (data[SALE] ?? false);
    _featured = (data[FEATURED] ?? false);
    _colors = List<String>.from(data[COLORS] ?? []);
    _sizes = List<String>.from(data[SIZES] ?? []);
  }
}
