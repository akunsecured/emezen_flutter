import 'package:emezen/model/enums.dart';
import 'package:emezen/model/product.dart';
import 'package:emezen/model/search_filter.dart';
import 'package:emezen/network/auth_service.dart';
import 'package:emezen/network/product_service.dart';
import 'package:emezen/provider/provider_base.dart';
import 'package:emezen/util/errors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductProvider extends ProviderBase {
  final ProductService _productService;

  final SearchFilter _searchFilter = SearchFilter();

  final List<Product> _products = [];
  final List<Product> _filteredProducts = [];

  String? _searchTitle;
  double? _priceFrom;
  double? _priceTo;

  List<Product> get products => _products;

  List<Product> get filteredProducts => _filteredProducts;

  List<ProductCategories> get categories => ProductCategories.values;

  ProductProvider(this._productService, AuthService authService,
      SharedPreferences sharedPreferences)
      : super(authService, sharedPreferences);

  void setTitle(String? value) {
    if (value == null || value.isEmpty) {
      _searchTitle = null;
    } else {
      _searchTitle = value;
    }
  }

  void setPriceFrom(String? value) {
    if (value == null || value.isEmpty) {
      _priceFrom = null;
    } else {
      _priceFrom = double.parse(value);
    }
  }

  void setPriceTo(String? value) {
    if (value == null || value.isEmpty) {
      _priceTo = null;
    } else {
      _priceTo = double.parse(value);
    }
  }

  bool containsCategoryFilter(int category) =>
      _searchFilter.categories.contains(category);

  void addOrRemoveCategoryFilter(int category) {
    if (containsCategoryFilter(category)) {
      _searchFilter.categories.remove(category);
    } else {
      _searchFilter.categories.add(category);
    }

    if (!isDisposed) notifyListeners();
  }

  void setNameFilter(String value) {
    _searchFilter.name = value.trim().toLowerCase();

    if (!isDisposed) notifyListeners();
  }

  Future<String?> createProduct(
      Product product, List<PlatformFile> images) async {
    changeLoadingStatus();

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

    changeLoadingStatus();
    return result;
  }

  Future<void> getAllProducts() async {
    _products.clear();
    changeLoadingStatus();

    try {
      String? token = await isLoggedIn();
      if (token != null) {
        _searchFilter.name = _searchTitle;
        _searchFilter.priceFrom = _priceFrom;
        _searchFilter.priceTo = _priceTo;

        List<Product> products =
            await _productService.getAllProducts(_searchFilter, token);
        _products.addAll(products);
      }
    } on ApiError catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Error: ${e.message}");
    }

    changeLoadingStatus();
    return;
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
}
