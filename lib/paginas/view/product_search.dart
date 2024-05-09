import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tienda3/paginas/helpers/common.dart';
import 'package:tienda3/paginas/helpers/style.dart';
import 'package:tienda3/paginas/provider/product.dart';
import 'package:tienda3/paginas/view/detalles_producto.dart';
import 'package:tienda3/widgets/custom_text.dart';
import 'package:tienda3/widgets/product_card.dart';

class ProductSearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(
          context, productProvider), // Método para construir el cuerpo
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(
          color: Colors.black), // Constante para reducir memoria
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          Navigator.pop(context); // Cierra la pantalla
        },
      ),
      title: const CustomText(
        text: "Products",
        size: 20,
        weight: FontWeight.bold, // Peso de fuente para mayor visibilidad
      ),
      elevation: 0.0,
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.shopping_cart),
          onPressed: () {
            // Acción para el carrito de compras
          },
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, ProductProvider productProvider) {
    if (productProvider.productsSearched.isEmpty) {
      return _noProductsFound(); // Mostrar mensaje cuando no hay productos
    }

    return ListView.builder(
      itemCount: productProvider.productsSearched.length,
      itemBuilder: (context, index) {
        final product = productProvider.productsSearched[index];
        return GestureDetector(
          onTap: () {
            changeScreen(
              context,
              ProductDetails(product: product),
            );
          },
          child: ProductCard(product: product), // Tarjeta de producto
        );
      },
    );
  }

  Widget _noProductsFound() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center, // Alineación central
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.search,
              color: Colors.grey, // Icono de búsqueda
              size: 30,
            ),
          ],
        ),
        const SizedBox(height: 15), // Espacio entre elementos
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CustomText(
              text: "No products found", // Mensaje si no hay productos
              color: Colors.grey,
              weight: FontWeight.w300,
              size: 22,
            ),
          ],
        ),
      ],
    );
  }
}
