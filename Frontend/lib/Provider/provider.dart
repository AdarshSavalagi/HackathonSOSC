import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sosc/constants.dart';

import '../models/Product.dart';

class ProductService {
  static Future<List<Product>> fetchProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.get(
      Uri.parse(GET_DASH_DATA),
      headers: {'Authorization': 'Bearer ${prefs.getString('access')}'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['products'];
      print(data);
      List<Product> products = data.map((json) => Product.fromJson(json)).toList();
      return products;
    } else {
      print('data:  ${response.body}');
      throw Exception('Failed to load products');
    }
  }
}

class ProductProvider extends ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  Future<void> fetchAndSetProducts() async {
    try {
      _isLoading = true;
      notifyListeners();

      List<Product> fetchedProducts = await ProductService.fetchProducts();
      _products = fetchedProducts;
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      throw error;
    }
  }
}
