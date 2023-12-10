import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Provider/provider.dart';
import '/screens/home/components/front_picture.dart';
import 'components/categories.dart';
import 'components/home_header.dart';
import 'components/popular_product.dart';
import 'components/special_offers.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";

  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    try {
      await productProvider.fetchAndSetProducts();
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : const Column(
                  children: [
                    HomeHeader(),
                    NewsCards(
                      title: 'BIGGEST FESTIVAL SALES',
                      
                      date: '12/12/2023',
                    ),
                    Categories(),
                    SpecialOffers(),
                    SizedBox(height: 20),
                    PopularProducts(),
                    SizedBox(height: 20),
                  ],
                ),
        ),
      ),
    );
  }
}
