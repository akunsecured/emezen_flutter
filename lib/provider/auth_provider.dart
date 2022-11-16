import 'dart:async';

import 'package:emezen/model/enums.dart';
import 'package:emezen/model/user.dart';
import 'package:emezen/model/wrapped_token.dart';
import 'package:emezen/network/auth_service.dart';
import 'package:emezen/network/user_service.dart';
import 'package:emezen/util/errors.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jwt_io/jwt_io.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  late final AuthService _authService;
  late final UserService _userService;
  late final SharedPreferences _sharedPreferences;

  bool _isDisposed = false;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String get ping => "pong";

  AuthMethod _authMethod = AuthMethod.login;
  AuthMethod get authMethod => _authMethod;

  final StreamController<User?> _userController = StreamController();
  Stream<User?> get userStream => _userController.stream;

  User? _currentUser;
  User? get currentUser {
    if (_currentUser != null) return _currentUser;

    User? user;
    getCurrentUser().then((usr) {
      user = usr;
    });
    return user;
  }

  AuthProvider(
      {required AuthService authService,
      required UserService userService,
      required SharedPreferences sharedPreferences}) {
    _authService = authService;
    _userService = userService;
    _sharedPreferences = sharedPreferences;

    isLoggedIn();
  }

  void _changeLoadingStatus() {
    _isLoading = !_isLoading;
    if (!_isDisposed) notifyListeners();
  }

  void changeAuthMethod(AuthMethod method) {
    _authMethod = method;
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

    if (success) {
      _userController
          .add(User.fromJson(JwtToken.payload(tokens!.accessToken)['user']));
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

  Future<String?> _refreshAccessToken(String token) async {
    try {
      String? accessToken = await _authService.refreshAccessToken(token);
      await _saveAccessToken(accessToken!);
      return accessToken;
    } on ApiError catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Error: ${e.message}");
    }
    return null;
  }

  Future<String?> isLoggedIn({String? accessToken}) async {
    accessToken ??= await getAccessToken();

    if (accessToken == null) return null;

    if (JwtToken.isExpired(accessToken)) {
      await _removeAccessToken();

      String? refreshToken = await _getRefreshToken();

      if (refreshToken == null || JwtToken.isExpired(refreshToken)) {
        await _removeRefreshToken();
        return null;
      }

      accessToken = await _refreshAccessToken(accessToken);
    }

    _currentUser = User.fromJson(JwtToken.payload(accessToken!)['user']);
    _userController.add(_currentUser);
    return accessToken;
  }

  Future<User?> getCurrentUser() async {
    try {
      String? token = await isLoggedIn();
      if (token != null) {
        _currentUser = await _authService.getCurrentUser(token);
        return _currentUser;
      }
    } on ApiError catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Error: ${e.message}");
    }

    return null;
  }

  Future<void> logout() async {
    _changeLoadingStatus();

    await _removeAccessToken();
    await _removeRefreshToken();

    _userController.add(null);

    _changeLoadingStatus();
  }

  Future<User?> getUser(String id) async {
    try {
      String? token = await isLoggedIn();
      if (token != null) {
        return await _userService.getUser(id: id, token: token);
      }
    } on ApiError catch (e) {
      Fluttertoast.showToast(msg: "Error: ${e.message}");
    }

    return null;
  }

  Future<String?> getCurrentUserId() async {
    String? token = await isLoggedIn();
    if (token != null) {

    }
  }

  @override
  void dispose() {
    _userController.close();
    _isDisposed = true;
    super.dispose();
  }
}
