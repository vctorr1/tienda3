import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tienda3/paginas/provider/product.dart';
import 'package:tienda3/widgets/custom_text.dart';
import 'package:tienda3/widgets/product_card.dart';

class CategoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: CustomText(text: "Categorías"),
      ),
      body: ListView.builder(
        itemCount: productProvider.categories.length,
        itemBuilder: (context, index) {
          final category = productProvider.categories[index];
          final products = productProvider.getProductsByCategory(category);

          return ExpansionTile(
            title: CustomText(text: category),
            children: products
                .map((product) => ProductCard(product: product))
                .toList(),
          );
        },
      ),
    );
  }
}
