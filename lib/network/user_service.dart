import 'package:emezen/network/base_service.dart';

class UserService extends BaseService {
  UserService() {
    dio.options.baseUrl = '${dio.options.baseUrl}/users';
  }
}
