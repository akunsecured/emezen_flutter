import 'package:dio/dio.dart';
import 'package:emezen/network/base_service.dart';
import 'package:emezen/model/user.dart';
import 'package:file_picker/file_picker.dart';

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

  Future<bool?> uploadProfilePicture(
      {required String id,
      required String token,
      required PlatformFile image}) async {
    try {
      String fileName = "$id.png";

      FormData formData = FormData.fromMap({
        'profile_picture':
            MultipartFile.fromBytes(image.bytes!, filename: fileName),
      });

      final response = await dio.post('/image/upload',
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
}
