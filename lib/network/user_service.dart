import 'package:dio/dio.dart';
import 'package:emezen/network/base_service.dart';
import 'package:emezen/model/user.dart';

class UserService extends BaseService {
  UserService() {
    dio.options.baseUrl = '${dio.options.baseUrl}/user';
  }

  Future<User?> getUser({required String id, required String token}) async {
    try {
      final response = await dio.get('/get/$id',
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200) {
        return User.fromJson(response.data['message']);
      }
    } on DioError catch (e) {
      handleNetworkError(e);
    }
    return null;
  }
}
