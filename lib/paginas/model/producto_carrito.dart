class CartItemModel {
  static const ID = "id";
  static const NAME = "nombre";
  static const IMAGE =
      "imagenes"; // Cambia a 'imagenes' para coincidir con Firestore
  static const PRODUCT_ID = "productId";
  static const PRICE = "precio";
  static const SIZE = "tallas"; // Cambia a 'tallas'
  static const COLOR = "color"; // Cambia a 'color'

  String _id;
  String _name;
  String _image;
  String _productId;
  String _size;
  String _color;
  int _price;

  // Getters
  String get id => _id;
  String get name => _name;
  String get image => _image;
  String get productId => _productId;
  String get size => _size;
  String get color => _color;
  int get price => _price;

  CartItemModel.fromMap(Map<String, dynamic> data)
      : _id = data[ID] ?? "",
        _name = data[NAME] ?? "",
        _image = (data[IMAGE] is List && (data[IMAGE] as List).isNotEmpty)
            ? (data[IMAGE] as List)
                .first
                .toString() // Usa la primera imagen del array
            : "", // Valor predeterminado
        _productId = data[PRODUCT_ID] ?? "",
        _price = (data[PRICE] ?? 0) as int, // Asegura que es un int
        _size = data[SIZE] ?? "",
        _color = data[COLOR] ?? "";

  Map<String, dynamic> toMap() => {
        ID: _id,
        NAME: _name,
        IMAGE: _image,
        PRODUCT_ID: _productId,
        PRICE: _price,
        SIZE: _size,
        COLOR: _color,
      };
}
