import 'package:emezen/model/enums.dart';
import 'package:emezen/model/product.dart';
import 'package:emezen/network/product_service.dart';
import 'package:emezen/util/errors.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CartProvider extends ChangeNotifier {
  late final ProductService _productService;

  bool _isDisposed = false;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  final Map<Product, int> _cart = {};

  Map<Product, int> get cart => _cart;

  CartProvider(this._productService);

  void _changeLoadingStatus() {
    _isLoading = !_isLoading;
    if (_isDisposed) notifyListeners();
  }

  Future<void> checkout(String token) async {
    if (_cart.isEmpty) {
      Fluttertoast.showToast(msg: 'Shopping cart is empty!');
      return;
    }

    _changeLoadingStatus();

    try {
      bool success = await _productService.buyProducts(
          _cart.map((product, quantity) => MapEntry(product.id!, quantity)), token);
      if (success) {
        Fluttertoast.showToast(msg: "Successful purchase");
        clearCart();
      }
    } on ApiError catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Error: ${e.message}");
    }

    _changeLoadingStatus();
  }

  void addToCart(Product product) {
    _cart[product] = 1;
    if (!_isDisposed) notifyListeners();
  }

  void removeFromCart(Product product) {
    _cart.removeWhere((element, quantity) => element.id == product.id);
    if (!_isDisposed) notifyListeners();
  }

  void increaseQuantity(Product product) {
    _cart[product] = (_cart[product] ?? 0) + 1;
    if (!_isDisposed) notifyListeners();
  }

  void reduceQuantity(Product product) {
    _cart[product] = _cart[product]! - 1;
    if (!_isDisposed) notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    if (!_isDisposed) notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
