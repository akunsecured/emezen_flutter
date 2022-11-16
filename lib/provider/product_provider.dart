import 'package:emezen/model/product.dart';
import 'package:emezen/network/product_service.dart';
import 'package:emezen/provider/auth_provider.dart';
import 'package:emezen/util/errors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductProvider extends ChangeNotifier {
  final AuthProvider _authProvider;
  final ProductService _productService;

  bool _isDisposed = false;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  ProductProvider(this._authProvider, this._productService);

  void _changeLoadingStatus() {
    _isLoading = !_isLoading;
    if (!_isDisposed) notifyListeners();
  }

  Future<String?> createProduct(
      Product product, List<PlatformFile> images) async {
    _changeLoadingStatus();

    String? result;
    String? productId;
    try {
      String? token = await _authProvider.isLoggedIn();
      if (token != null) {
        productId = await _productService.createProduct(product, token);
        if (productId != null) {
          if (images.isNotEmpty) {
            bool? uploadPictureResponse =
                await _productService.uploadProductPictures(
                    productId: productId, images: images, token: token);
            if (uploadPictureResponse != null && uploadPictureResponse) {
              result = 'Successfully created product with ID $productId';
            } else {
              result =
                  'Product with ID $productId is created but no images were uploaded';
            }
          }
        }
      }
    } on ApiError catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Error: ${e.message}");
    }

    _changeLoadingStatus();
    return result;
  }

  Future<List<Product>> getAllProducts() async {
    List<Product> products = [];

    try {
      String? token = await _authProvider.isLoggedIn();
      if (token != null) {
        products = await _productService.getAllProducts(token);
      }
    } on ApiError catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Error: ${e.message}");
    }

    return products;
  }

  Future<Product?> getProduct(String id) async {
    try {
      String? token = await _authProvider.isLoggedIn();
      if (token != null) {
        return await _productService.getProduct(id, token);
      }
    } on ApiError catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Error: ${e.message}");
    }

    return null;
  }

  Future<List<Product>> getAllProductsOfUser(String id) async {
    List<Product> products = [];

    try {
      String? token = await _authProvider.isLoggedIn();
      if (token != null) {
        products = await _productService.getAllProductsOfUser(id, token);
      }
    } on ApiError catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Error: ${e.message}");
    }

    return products;
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
