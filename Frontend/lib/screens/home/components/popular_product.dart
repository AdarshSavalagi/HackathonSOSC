import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Provider/provider.dart';
import '../../../components/product_card.dart';
import '../../../models/Product.dart';
import '../../details/details_screen.dart';
import '../../products/products_screen.dart';
import 'section_title.dart';

class PopularProducts extends StatelessWidget {
  const PopularProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(builder: (context, products, _) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SectionTitle(
              title: "Popular Products",
              press: () {
                Navigator.pushNamed(context, ProductsScreen.routeName);
              },
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ...List.generate(
                  products.products.length,
                  (index) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: ProductCard(
                          product: products.products[index],
                          onPress: () => Navigator.push(context,   MaterialPageRoute(builder: (context) =>  DetailsScreen(product:products.products[index])),),
                        ),
                      );
                    })])),
        ],
      );
    });
  }
}
