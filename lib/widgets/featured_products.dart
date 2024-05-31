import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tienda3/paginas/provider/product.dart';
import 'featured_card.dart';

class FeaturedProducts extends StatefulWidget {
  @override
  _FeaturedProductsState createState() => _FeaturedProductsState();
}

class _FeaturedProductsState extends State<FeaturedProducts> {
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    // Asegurarse de que la lista de productos no sea nula
    if (productProvider.products.isEmpty) {
      return Center(
        child: Text("No hay productos"), // Mensaje si no hay productos
      );
    }

    return Container(
      height: 230,
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // Desplazamiento horizontal
        itemCount: productProvider.products.length,
        itemBuilder: (context, index) {
          final product = productProvider.products[index]; // Producto actual
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: FeaturedCard(
                product: product), // Tarjeta del producto destacado
          );
        },
      ),
    );
  }
}
