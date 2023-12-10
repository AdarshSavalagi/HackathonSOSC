import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Provider/provider.dart';
import '/components/product_card.dart';
import '/models/Product.dart';

import '../details/details_screen.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  static String routeName = "/products";

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(builder: (context, products, _) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Products"),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              itemCount: products.products.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 0.7,
                mainAxisSpacing: 20,
                crossAxisSpacing: 16,
              ),
              itemBuilder: (context, index) => ProductCard(
                product: products.products[index],
                onPress: () => Navigator.pushNamed(
                  context,
                  DetailsScreen.routeName,
                  arguments: ProductDetailsArguments(
                      product: products.products[index]),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
