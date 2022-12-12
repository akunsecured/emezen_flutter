import 'package:dio/dio.dart';
import 'package:emezen/model/product.dart';
import 'package:emezen/model/product_observer.dart';
import 'package:emezen/model/search_filter.dart';
import 'package:emezen/network/base_service.dart';
import 'package:file_picker/file_picker.dart';

class ProductService extends BaseService {
  ProductService() {
    dio.options.baseUrl = '${dio.options.baseUrl}/product';
  }

  Future<String?> createProduct(Product product, String token) async {
    try {
      final response = await dio.post('/create',
          data: product.toJson(),
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 200) {
        return response.data["message"];
      }
    } on DioError catch (e) {
      handleNetworkError(e);
    }
    return null;
  }

  Future<bool?> uploadProductPictures(
      {required String productId,
      required List<PlatformFile> images,
      required String token,
      int uploadedImages = 0}) async {
    try {
      FormData formData = FormData();

      for (int i = uploadedImages; i < images.length + uploadedImages; i++) {
        String fileName = "$productId-$i.png";
        formData.files.add(MapEntry('product_pictures',
            MultipartFile.fromBytes(images[i].bytes!, filename: fileName)));
      }

      final response = await dio.post('/image/$productId',
          data: formData,
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200) {
        return response.data['message'];
      }
    } on DioError catch (e) {
      handleNetworkError(e);
    }
    return false;
  }

  Future<List<Product>> getAllProducts(
      SearchFilter searchFilter, String token) async {
    try {
      Map<String, dynamic> queryParameters = {};

      if (searchFilter.name != null) {
        queryParameters['name'] = searchFilter.name;
      }
      if (searchFilter.priceFrom != null) {
        queryParameters['price_from'] = searchFilter.priceFrom;
      }
      if (searchFilter.priceTo != null) {
        queryParameters['price_to'] = searchFilter.priceTo;
      }
      if (searchFilter.categories.isNotEmpty) {
        queryParameters['categories'] = searchFilter.categories.join(',');
      }

      final response = await dio.get('/get_all',
          queryParameters: queryParameters,
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 200) {
        List<Product> products = [];
        if (response.data['message'] != null) {
          for (var element in response.data['message']) {
            products.add(Product.fromJson(element));
          }
        }
        return products;
      }
    } on DioError catch (e) {
      handleNetworkError(e);
    }
    return [];
  }

  Future<Product?> getProduct(String id, String token) async {
    try {
      final response = await dio.get('/get/$id',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 200) {
        return Product.fromJson(response.data["message"]);
      }
    } on DioError catch (e) {
      handleNetworkError(e);
    }
    return null;
  }

  Future<List<Product>> getAllProductsOfUser(String id, String token) async {
    try {
      final response = await dio.get('/get_all/$id',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 200) {
        List<Product> products = [];
        if (response.data['message'] != null) {
          for (var element in response.data['message']) {
            products.add(Product.fromJson(element));
          }
        }
        return products;
      }
    } on DioError catch (e) {
      handleNetworkError(e);
    }
    return [];
  }

  Future<bool> buyProducts(
      Map<String, int> productsWithCount, String token) async {
    try {
      final response = await dio.post('/buy',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
          data: productsWithCount);
      if (response.statusCode == 200) {
        return true;
      }
    } on DioError catch (e) {
      handleNetworkError(e);
    }
    return false;
  }

  Future<bool> editProduct(Product product, String token) async {
    try {
      final response = await dio.put(
        '/update/${product.id}',
        data: product.toJson(),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        return true;
      }
    } on DioError catch (e) {
      handleNetworkError(e);
    }
    return false;
  }

  Future<bool> deleteProduct(String id, String token) async {
    try {
      final response = await dio.delete(
        '/delete/$id',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        return true;
      }
    } on DioError catch (e) {
      handleNetworkError(e);
    }
    return false;
  }

  Future<ProductObserver?> getProductObserver(String token) async {
    try {
      final response = await dio.get(
        '/observer',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        if (response.data["message"] == null) {
          return null;
        }
        return ProductObserver.fromJson(response.data["message"]);
      }
    } on DioError catch (e) {
      handleNetworkError(e);
    }
    return null;
  }

  Future<ProductObserver?> updateProductObserver(
      ProductObserver productObserver, String token) async {
    try {
      final response = await dio.put(
        '/observer',
        data: productObserver.toJson(),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        return ProductObserver.fromJson(response.data["message"]);
      }
    } on DioError catch (e) {
      handleNetworkError(e);
    }
    return null;
  }
}
