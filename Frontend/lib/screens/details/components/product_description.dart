import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants.dart';
import '../../../models/Product.dart';

class ProductDescription extends StatefulWidget {
  const ProductDescription({
    Key? key,
    required this.product,
    this.pressOnSeeMore, required this.time,
  }) : super(key: key);

  final Product product;
  final GestureTapCallback? pressOnSeeMore;
  final String time;
  @override
  State<ProductDescription> createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            widget.product.name,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal:20.0,vertical: 5),
          child: Text('Minimum Bid: \$ ${widget.product.bidding}',style: const TextStyle(fontWeight: FontWeight.w300,fontSize: 15),),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal:20.0,vertical: 3),
          child: Text('Current Bid: \$ ${widget.product.current}',style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal:20.0,vertical: 3),
          child: Text('Bidding Ends in: ${widget.time}',style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15,  color: kPrimaryColor),),
        ),

        Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 64,
          ),
          child: Text(
            widget.product.description,
            maxLines: 3,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 12,
          ),
          child: GestureDetector(
            onTap: () {},
            child: const Row(
              children: [
                Text(
                  "See More Detail",
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: kPrimaryColor),
                ),
                SizedBox(width: 5),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: kPrimaryColor,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
