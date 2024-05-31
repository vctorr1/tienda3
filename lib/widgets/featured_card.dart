import 'package:flutter/material.dart';
import 'package:tienda3/paginas/helpers/common.dart';
import 'package:tienda3/paginas/model/producto.dart';
import 'package:tienda3/paginas/view/detalles_producto.dart';
import 'package:tienda3/widgets/loading.dart';
import 'package:transparent_image/transparent_image.dart';

class FeaturedCard extends StatelessWidget {
  final ProductModel product; // Parámetro obligatorio

  const FeaturedCard({
    Key? key,
    required this.product, // Uso de `required`
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: InkWell(
        onTap: () {
          // Navegación al detalle del producto
          changeScreen(
            context,
            ProductDetails(product: product),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                offset: Offset(0, 9),
                blurRadius: 14,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10), // Bordes redondeados
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Loading(), // Indicador de carga
                  ),
                ),
                _productImage(), // Método para obtener la imagen del producto
                _productDescription(), // Método para descripción del producto
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _productImage() {
    if (product.pictures == null || product.pictures.isEmpty) {
      return Container(
        color: Colors.grey.shade200,
        width: 200,
        height: 220,
        child: Center(
          child: Text("No hay imagen"), // Mensaje cuando no hay imagen
        ),
      );
    }

    return Center(
      child: FadeInImage.memoryNetwork(
        placeholder: kTransparentImage,
        image: product.pictures!.first,
        fit: BoxFit.cover,
        height: 220,
        width: 200,
      ),
    );
  }

  Widget _productDescription() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text:
                    '${product.name ?? "Producto desconocido"} \n', // Manejo de valores nulos
                style: TextStyle(fontSize: 18),
              ),
              TextSpan(
                text: '${product.price / 100}€ \n',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
