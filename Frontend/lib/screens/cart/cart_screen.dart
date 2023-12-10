import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sosc/screens/home/home_screen.dart';
import '../../Provider/provider.dart';
import '../../constants.dart';
import '../../models/Cart.dart';
import 'components/cart_card.dart';
import 'components/check_out_card.dart';

class CartScreen extends StatefulWidget {
  static String routeName = "/cart";

  const CartScreen({super.key, required this.pid});
  final String pid;

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController bid = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(builder: (context, products, _) {
      return Scaffold(
        appBar: AppBar(
          title: Column(
            children: [
              const Text(
                "Your Cart",
                style: TextStyle(color: Colors.black),
              ),
              Text(
                "${products.products.length} items",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: [
              CartCard(
                cart: Cart(
                  numOfItem: 1,
                  product: products.products.first,
                ),
              ),
              // input tag
              const SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.number,
                onChanged: (value) {},
                validator: (value) {
                  if (products.products.first.current > int.parse(value!)) {
                    return "error";
                  }
                },
                controller: bid,
                decoration: const InputDecoration(
                  labelText: "Bid amount",
                  hintText: "Enter Bid amount",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        bottomNavigationBar: GestureDetector(
            onTap: () async {
              if (int.parse(bid.text) < int.parse(widget.pid)) {
                const snackBar = SnackBar(
                  content: Text('Bid amount is less than current auction'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }else{
                SharedPreferences prefs = await SharedPreferences.getInstance();
              final response = await http.post(Uri.parse(GET_DASH_DATA),
                  headers: {
                    'Authorization': 'Bearer ${prefs.getString('access')}'
                  },
                  body: {
                    'type': "1",
                    "new_amount": bid.text,
                    "pid": widget.pid
                  });
              if (response.statusCode == 200) {
                Navigator.pushNamed(context, HomeScreen.routeName);
              }
              }
              
            },
            child: const CheckoutCard()),
      );
    });
  }
}
