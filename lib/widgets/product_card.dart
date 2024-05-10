import 'package:flutter/material.dart';
import 'package:tienda3/paginas/helpers/common.dart';
import 'package:tienda3/paginas/helpers/style.dart';
import 'package:tienda3/paginas/model/producto.dart';
import 'package:tienda3/paginas/view/detalles_producto.dart';
import 'package:tienda3/widgets/custom_text.dart';
import 'package:transparent_image/transparent_image.dart';

import 'loading.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          changeScreen(
            context,
            ProductDetails(product: product),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                offset: Offset(-2, -1),
                blurRadius: 5,
              ),
            ],
          ),
          child: Row(
            children: <Widget>[
              _productImage(
                  product.pictures.first), // Uso de método para obtener imagen
              const SizedBox(width: 10),
              _productDescription(), // Método para descripción del producto
            ],
          ),
        ),
      ),
    );
  }

  Widget _productImage(String? picture) {
    if (picture == null || picture.isEmpty) {
      return Container(
        width: 120,
        height: 140,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: CustomText(text: "Sin Imagen"), // Manejo de imagen nula
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: FadeInImage.memoryNetwork(
        placeholder: kTransparentImage, // Imagen transparente mientras carga
        image: picture,
        height: 140,
        width: 120,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _productDescription() {
    return Expanded(
      // Uso de Expanded para distribuir el espacio
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '${product.name} \n',
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            TextSpan(
              text: 'by: ${product.brand} \n\n\n\n',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            TextSpan(
              text: '\$${product.price / 100} \t',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: product.sale ? 'OFERTA ' : "",
              style: TextStyle(
                fontSize: 18,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
