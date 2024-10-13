import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/product_model.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';

class CoursesViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final AuthService _authService = AuthService();
  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;

  Future<void> loadUserData() async {
    _currentUser = _authService.getCurrentUser();
    notifyListeners();
  }
  List<Product> _allProducts = []; // Holds all products fetched from the API
  List<Product> _filteredProducts = []; // Holds filtered products to display
  List<String> _categories = []; // Holds fetched categories

  bool _isLoading = false;
  bool _hasMore = true;
  int _page = 1;
  int _limit = 10;

  int _selectedTabIndex = 0; // Track selected tab ("All", "Popular", "New")
  String _searchQuery = ''; // Track the search query
  // Expose the search query as a getter
  String get searchQuery => _searchQuery;

  // State fields for filtering
  String _selectedCategory = '';
  double _minPrice = 0;
  double _maxPrice = 15000;
  String _selectedDuration = ''; // For display purposes only
  bool isFiltered = false; // Track if a filter is applied

  // Expose filtered products and loading state
  List<Product> get products => _filteredProducts;
  bool get isLoading => _isLoading;
  List<String> get categories => _categories;

  // Expose selectedCategory, minPrice, maxPrice, and selectedDuration for UI
  String get selectedCategory => _selectedCategory;
  double get minPrice => _minPrice;
  double get maxPrice => _maxPrice;
  String get selectedDuration => _selectedDuration; // Getter for selectedDuration (display only)

  // Fetch products from the API with or without filters
  Future<void> fetchProducts({bool resetPage = false, bool applyFilter = false}) async {
    if (_isLoading || !_hasMore) return;

    if (resetPage) {
      _page = 1;
      _allProducts.clear();
      _filteredProducts.clear();
      _hasMore = true;
    }

    _isLoading = true;
    notifyListeners();

    try {
      List<Product> newProducts;

      // Print debug information for filter status and current prices
      // print('Applying filters? $applyFilter');
      // print('Min Price: $_minPrice');
      // print('Max Price: $_maxPrice');
      // print('Selected Category: $_selectedCategory');

      // Instead of fetching products in batches, fetch all products at once
      if (applyFilter && (isFiltered || _selectedCategory.isNotEmpty || _minPrice > 0)) {
      //  print('Fetching all products for filtering...');

        // Fetch all products without pagination
        newProducts = await _apiService.fetchAllProducts(); // Assuming this fetches the entire product list

       // print('Fetched ${newProducts.length} products for filtering');

        // Apply local filtering on all fetched products
        _filteredProducts = newProducts.where((product) {
          bool matchesCategory = _selectedCategory.isEmpty || product.category == _selectedCategory;
          bool matchesPrice = product.price >= _minPrice && product.price <= _maxPrice;
        //  print('Product Price: ${product.price}, Category: ${product.category}');
          //print('Matches Price? $matchesPrice, Matches Category? $matchesCategory');
          return matchesCategory && matchesPrice;
        }).toList();

       // print('Products after filtering: ${_filteredProducts.length}');

        if (_filteredProducts.isEmpty) {
         // print('No products match the applied filter.');
          Fluttertoast.showToast(msg: 'No products match the applied filter.');

        }

      } else {
        //print('Fetching all products...');
        newProducts = await _apiService.fetchAllProducts(); // Fetching all products at once

        // If no filters are applied, show all products
        _allProducts.addAll(newProducts);
        _filteredProducts = List.from(_allProducts);
      }

    } catch (e) {
    //  print('Error fetching products: $e');
      Fluttertoast.showToast(msg: 'Error fetching products: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Fetch product categories from the API
  Future<void> fetchCategories() async {
    try {
      _categories = await _apiService.fetchCategories();
      notifyListeners();  // Notify listeners when categories are fetched
    } catch (e) {
      //print('Failed to fetch categories: $e');
      Fluttertoast.showToast(msg: 'Failed to fetch categories: $e');
    }
  }

  // Apply filters based on category and price
  void applyFilters() async {
    isFiltered = true;
    //print('Filters applied: Category = $_selectedCategory, Min Price = $_minPrice, Max Price = $_maxPrice');

    // Fetch all products to apply filters locally
    List<Product> allProducts = await _apiService.fetchAllProducts();

    _allProducts.clear(); // Clear any previously fetched products
    _allProducts.addAll(allProducts); // Add all fetched products

    // Apply the filters locally after fetching all products
    _filteredProducts = _allProducts.where((product) {
      bool matchesCategory = _selectedCategory.isEmpty || product.category == _selectedCategory;
      bool matchesPrice = product.price >= _minPrice && product.price <= _maxPrice;
      return matchesCategory && matchesPrice;
    }).toList();

   // print('Products after filtering: ${_filteredProducts.length}');
    _searchQuery = '';
    notifyListeners(); // Notify the UI to refresh
  }


  // Clear filters and reset state
  void clearFilters() {
    isFiltered = false;
    _selectedCategory = '';
    _searchQuery = '';
    _minPrice = 0;
    _maxPrice = 15000;
    _filteredProducts = List.from(_allProducts);
    notifyListeners();
  }

  // Clear all product state when navigating away from the course page
  void clearAllFilters() {
    clearFilters();
    _allProducts.clear();
    _filteredProducts.clear();
    _searchQuery = '';  // Clear the search query when tab is changed
    _page = 1;
    _hasMore = true;
    isFiltered = false;
  }

  // Set filter properties
  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setPriceRange(double min, double max) {
    _minPrice = min;
    _maxPrice = max;
    //print('Price range updated: Min Price = $min, Max Price = $max');
    notifyListeners();
  }

  // Set the selected duration (for display purposes only)
  void setSelectedDuration(String duration) {
    _selectedDuration = duration; // This is purely for display purposes
    notifyListeners();
  }
  // Search products by title or category (case-insensitive)
  void searchProducts(String query) {
    _searchQuery = query.toLowerCase();
    //print('Searching for: $_searchQuery');

    _filteredProducts = _allProducts.where((product) {
      bool matchesTitle = product.title.toLowerCase().contains(_searchQuery);
      bool matchesCategory = product.category.toLowerCase().contains(_searchQuery);
      return matchesTitle || matchesCategory;
    }).toList();

   // print('Products found: ${_filteredProducts.length}');
    notifyListeners(); // Notify listeners to update the UI
  }
  // Set the selected tab index
  void setSelectedTabIndex(int tabIndex) {
    _selectedTabIndex = tabIndex;
    notifyListeners();
  }

  // Filter products by rating for All, Popular, and New tabs
  void filterProductsByRating(int tabIndex, {bool isNewFetch = false}) {
    if (!isNewFetch) {
      _allProducts.clear();
      _page = 1;
      _hasMore = true;
      fetchProducts();
    }

    if (tabIndex == 0) {
      _filteredProducts = List.from(_allProducts);
    } else if (tabIndex == 1) {
      _filteredProducts = _allProducts.where((product) => product.rating > 4).toList();
    } else if (tabIndex == 2) {
      _filteredProducts = _allProducts.where((product) => product.rating < 3).toList();
    }

    notifyListeners();
  }
}
