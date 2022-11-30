import 'package:emezen/model/product.dart';
import 'package:emezen/network/auth_service.dart';
import 'package:emezen/network/product_service.dart';
import 'package:emezen/provider/provider_base.dart';
import 'package:emezen/util/errors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductProvider extends ProviderBase {
  final ProductService _productService;

  bool _isDisposed = false;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  ProductProvider(this._productService, AuthService authService,
      SharedPreferences sharedPreferences)
      : super(authService, sharedPreferences);

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
      String? token = await isLoggedIn();
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
      String? token = await isLoggedIn();
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
      String? token = await isLoggedIn();
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
      String? token = await isLoggedIn();
      if (token != null) {
        products = await _productService.getAllProductsOfUser(id, token);
      }
    } on ApiError catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Error: ${e.message}");
    }

    return products;
  }

  Future<bool> deleteProduct(String id) async {
    bool success = false;

    try {
      String? token = await isLoggedIn();
      if (token != null) {
        success = await _productService.deleteProduct(id, token);
      }
    } on ApiError catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Error: ${e.message}");
    }

    return success;
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
