class CartItemModel {
  static const ID = "id";
  static const NAME = "nombre";
  static const IMAGE = "imagen";
  static const PRODUCT_ID = "productId";
  static const PRICE = "precio";
  static const SIZE = "tallas";
  static const COLOR = "color";

  String _id = "";
  String _name = "";
  String _image = "";
  String _productId = "";
  String _size = "";
  String _color = "";
  int _price = 0;

  //  getters
  String get id => _id;

  String get name => _name;

  String get image => _image;

  String get productId => _productId;

  String get size => _size;

  String get color => _color;

  int get price => _price;

  CartItemModel.fromMap(Map data) {
    _id = data[ID];
    _name = data[NAME];
    _image = data[IMAGE];
    _productId = data[PRODUCT_ID];
    _price = data[PRICE];
    _size = data[SIZE];
    _color = data[COLOR];
  }

  Map toMap() => {
        ID: _id,
        IMAGE: _image,
        NAME: _name,
        PRODUCT_ID: _productId,
        PRICE: _price,
        SIZE: _size,
        COLOR: _color
      };
}
