import 'package:emezen/model/enums.dart';
import 'package:emezen/model/user.dart';
import 'package:emezen/model/wrapped_token.dart';
import 'package:emezen/network/auth_service.dart';
import 'package:emezen/util/errors.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jwt_io/jwt_io.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  late final AuthService _authService;
  late final SharedPreferences _sharedPreferences;

  bool _isDisposed = false;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String get ping => "pong";

  AuthProvider(
      {required AuthService authService,
      required SharedPreferences sharedPreferences}) {
    _authService = authService;
    _sharedPreferences = sharedPreferences;
  }

  void _changeLoadingStatus() {
    _isLoading = !_isLoading;
    if (!_isDisposed) notifyListeners();
  }

  Future<bool> submit(UserWrapper userWrapper) async {
    _changeLoadingStatus();

    WrappedToken? tokens;
    bool success = false;

    try {
      if (userWrapper.type == UserWrapperType.userDataWithCredentials) {
        tokens = await _authService.register(userWrapper);
        success = await _saveWrappedToken(tokens!);
      }
      if (userWrapper.type == UserWrapperType.credentials) {
        tokens = await _authService.login(userWrapper.userCredentials!);
        success = await _saveWrappedToken(tokens!);
      }
    } on ApiError catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Error: ${e.message}");
    }

    _changeLoadingStatus();
    return success;
  }

  Future<bool> _saveAccessToken(String token) async {
    return await _sharedPreferences.setString('access_token', token);
  }

  Future<bool> _saveWrappedToken(WrappedToken tokens) async {
    bool accessSuccess =
        await _sharedPreferences.setString('access_token', tokens.accessToken);
    bool refreshSuccess = await _sharedPreferences.setString(
        'refresh_token', tokens.refreshToken);
    return accessSuccess && refreshSuccess;
  }

  Future<String?> getAccessToken() async {
    return _sharedPreferences.getString('access_token');
  }

  Future<String?> _getRefreshToken() async {
    return _sharedPreferences.getString('refresh_token');
  }

  Future<bool> _removeAccessToken() async {
    return await _sharedPreferences.remove('access_token');
  }

  Future<bool> _removeRefreshToken() async {
    return await _sharedPreferences.remove('refresh_token');
  }

  Future<void> _refreshAccessToken(String token) async {
    try {
      String? accessToken = await _authService.refreshAccessToken(token);
      await _saveAccessToken(accessToken!);
    } on ApiError catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Error: ${e.message}");
    }
  }

  Future<bool> isLoggedIn({String? accessToken}) async {
    accessToken ??= await getAccessToken();

    if (accessToken == null) return false;

    if (JwtToken.isExpired(accessToken)) {
      await _removeAccessToken();

      String? refreshToken = await _getRefreshToken();

      if (refreshToken == null || JwtToken.isExpired(refreshToken)) {
        await _removeRefreshToken();
        return false;
      }

      await _refreshAccessToken(accessToken);
      return true;
    }

    return true;
  }

  Future<User?> getCurrentUser() async {
    _changeLoadingStatus();

    try {
      String? token = await getAccessToken();
      if (await isLoggedIn(accessToken: token)) {
        return await _authService.getCurrentUser(token!);
      }
    } on ApiError catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Error: ${e.message}");
    }

    _changeLoadingStatus();
    return null;
  }

  Future<void> logout() async {
    _changeLoadingStatus();

    await _removeAccessToken();
    await _removeRefreshToken();

    _changeLoadingStatus();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
