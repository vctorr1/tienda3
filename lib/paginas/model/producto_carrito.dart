class CartItemModel {
  static const ID = "id";
  static const NAME = "nombre";
  static const IMAGE = "imagenes"; // Campo de imagen
  static const PRODUCT_ID = "productId";
  static const PRICE = "precio";
  static const SIZE = "tallas"; // Tamaño del producto
  static const COLOR = "color"; // Color del producto

  // Campos de la clase
  final String _id;
  final String _name;
  final String _image;
  final String _productId;
  final String _size;
  final String _color;
  final int _price;

  // Getters
  String get id => _id;
  String get name => _name;
  String get image => _image;
  String get productId => _productId;
  String get size => _size;
  String get color => _color;
  int get price => _price;

  // Constructor desde un Map
  CartItemModel.fromMap(Map<String, dynamic> data)
      : _id = data[ID] ?? "",
        _name = data[NAME] ?? "",
        _image = (data[IMAGE] is String) // Si el campo es una cadena
            ? data[IMAGE]
            : (data[IMAGE] is List && (data[IMAGE] as List).isNotEmpty)
                ? (data[IMAGE] as List)[0].toString() // Si es una lista
                : "", // Predeterminado si no hay imagen
        _productId = data[PRODUCT_ID] ?? "",
        _price = (data[PRICE] ?? 0).toInt(), // Conversión segura a int
        _size = data[SIZE] ?? "",
        _color = data[COLOR] ?? "";

  // Mapeo de objeto a Map para almacenamiento
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
