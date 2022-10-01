import 'package:dio/dio.dart';

abstract class ApiService {
  late final Dio dio;

  ApiService() {
    dio = Dio(BaseOptions(
      baseUrl: 'http://localhost:8080/api/v1'
    ));
  }
}