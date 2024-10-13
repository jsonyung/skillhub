import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ApiService {
  final String baseUrl = 'https://dummyjson.com/products';

  // Fetch products with pagination (limit and skip)
  Future<List<Product>> fetchProducts(int limit, int skip) async {
    final response = await http.get(Uri.parse('$baseUrl?limit=$limit&skip=$skip'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      //print('Fetched Products: ${data['products']}'); // Print fetched products
      List<Product> products = (data['products'] as List)
          .map((productJson) => Product.fromJson(productJson))
          .toList();
      return products;
    } else {
      //print('Failed to load products. Status code: ${response.statusCode}');
      throw Exception('Failed to load products');
    }
  }

  // Fetch all products at once (no pagination, all products)
  Future<List<Product>> fetchAllProducts() async {
    final response = await http.get(Uri.parse('$baseUrl?limit=0'));  // Set limit=0 to fetch all products

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
     // print('Fetched All Products: ${data['products']}'); // Print fetched products
      List<Product> products = (data['products'] as List)
          .map((productJson) => Product.fromJson(productJson))
          .toList();
      return products;
    } else {
     // print('Failed to load all products. Status code: ${response.statusCode}');
      throw Exception('Failed to load all products');
    }
  }

  // Fetch categories from the 'category-list' API
  Future<List<String>> fetchCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/category-list'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
     // print('Fetched Categories: $data'); // Print fetched categories for debugging
      return List<String>.from(data); // Return the list of categories directly as strings
    } else {
     // print('Failed to load categories. Status code: ${response.statusCode}');
      throw Exception('Failed to load categories');
    }
  }

  // Fetch filtered products by category and price range
  Future<List<Product>> fetchFilteredProducts({
    String? category,
    double? minPrice,
    double? maxPrice,
    int limit = 10,
    int skip = 0,
  }) async {
    String url = '$baseUrl?limit=$limit&skip=$skip';

    // Append category filter if provided
    if (category != null && category.isNotEmpty) {
      url += '&category=$category';
    }

    // Append price filter if provided
    if (minPrice != null) {
      url += '&price_gte=$minPrice'; // Assuming API supports price_gte (greater than or equal)
    }
    if (maxPrice != null) {
      url += '&price_lte=$maxPrice'; // Assuming API supports price_lte (less than or equal)
    }

   // print('Fetching filtered products with URL: $url'); // Print the request URL

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
     // print('Fetched Filtered Products: ${data['products']}'); // Print fetched filtered products
      List<Product> products = (data['products'] as List)
          .map((productJson) => Product.fromJson(productJson))
          .toList();
      return products;
    } else {
    //  print('Failed to load filtered products. Status code: ${response.statusCode}');
      throw Exception('Failed to load filtered products');
    }
  }
}
