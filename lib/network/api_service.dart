import 'package:dio/dio.dart';
import 'package:emezen/model/user.dart';

class ApiService {
  Dio dio = Dio(BaseOptions(
    baseUrl: 'http://localhost:8080/api/v1',
    headers: {
      'content-type': 'application/json',
      'Access-Control-Allow-Origin': 'true'
    },
  ));

  Future<String?> register(
      UserDataWithCredentials userDataWithCredentials) async {
    try {
      final response = await dio.post('/auth/register',
          data: userDataWithCredentials.toJson());
      if (response.statusCode == 200) {
        return response.data.toString();
      }
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }

  Future<String?> login(UserCredentials userCredentials) async {
    try {
      final response =
          await dio.post('/auth/login', data: userCredentials.toJson());
      if (response.statusCode == 200) {
        return response.data.toString();
      }
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }
}
