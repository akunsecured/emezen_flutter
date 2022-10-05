import 'package:emezen/network/base_service.dart';

class ProductService extends BaseService {
  ProductService() {
    dio.options.baseUrl = '${dio.options.baseUrl}/products';
  }
}