import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../database/database_helper.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;
  String _searchQuery = '';

  List<Product> get products {
    if (_searchQuery.isEmpty) {
      return _products;
    }
    return _products
        .where((product) =>
        product.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  bool get isLoading => _isLoading;

  String get searchQuery => _searchQuery;

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _products = await DatabaseHelper.instance.readAllProducts();
    } catch (e) {
      debugPrint('Error loading products: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      final newProduct = await DatabaseHelper.instance.create(product);
      _products.insert(0, newProduct);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding product: $e');
      rethrow;
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      await DatabaseHelper.instance.update(product);
      final index = _products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _products[index] = product;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating product: $e');
      rethrow;
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      await DatabaseHelper.instance.delete(id);
      _products.removeWhere((product) => product.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting product: $e');
      rethrow;
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  double get totalInventoryValue {
    return _products.fold(0, (sum, product) => sum + (product.price * product.quantity));
  }

  int get totalProducts => _products.length;

  int get totalItems => _products.fold(0, (sum, product) => sum + product.quantity);
}