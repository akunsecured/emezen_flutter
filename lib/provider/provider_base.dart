import 'package:emezen/network/auth_service.dart';
import 'package:emezen/util/errors.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jwt_io/jwt_io.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ProviderBase extends ChangeNotifier {
  final AuthService _authService;
  final SharedPreferences _sharedPreferences;

  bool _isDisposed = false;
  bool get isDisposed => _isDisposed;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ProviderBase(this._authService, this._sharedPreferences);

  void changeLoadingStatus() {
    _isLoading = !_isLoading;
    if (!_isDisposed) notifyListeners();
  }

  String? getAccessToken() {
    return _sharedPreferences.getString('access_token');
  }

  String? getRefreshToken() {
    return _sharedPreferences.getString('refresh_token');
  }

  Future<bool> removeAccessToken() async {
    return await _sharedPreferences.remove('access_token');
  }

  Future<bool> removeRefreshToken() async {
    return await _sharedPreferences.remove('refresh_token');
  }

  Future<bool> saveAccessToken(String token) async {
    return await _sharedPreferences.setString('access_token', token);
  }

  Future<String?> refreshAccessToken(String token) async {
    try {
      String? accessToken = await _authService.refreshAccessToken(token);
      await saveAccessToken(accessToken!);
      return accessToken;
    } on ApiError catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Error: ${e.message}");
    }
    return null;
  }

  Future<String?> isLoggedIn({String? accessToken}) async {
    accessToken ??= getAccessToken();

    if (accessToken == null) return null;

    if (JwtToken.isExpired(accessToken)) {
      await removeAccessToken();

      String? refreshToken = getRefreshToken();

      if (refreshToken == null || JwtToken.isExpired(refreshToken)) {
        await removeRefreshToken();
        return null;
      }

      accessToken = await refreshAccessToken(refreshToken);
    }

    return accessToken;
  }

  Future<String?> getCurrentUserId() async {
    String? token = await isLoggedIn();

    if (token != null) {
      Map<String, dynamic> tokenPayload = JwtToken.payload(token);
      return tokenPayload['userId'];
    }

    return null;
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}