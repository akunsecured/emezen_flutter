import 'dart:async';

import 'package:emezen/model/enums.dart';
import 'package:emezen/model/user.dart';
import 'package:emezen/model/wrapped_token.dart';
import 'package:emezen/network/auth_service.dart';
import 'package:emezen/network/user_service.dart';
import 'package:emezen/provider/provider_base.dart';
import 'package:emezen/util/errors.dart';
import 'package:emezen/util/utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:jwt_io/jwt_io.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ProviderBase {
  late final AuthService _authService;
  late final UserService _userService;
  late final SharedPreferences _sharedPreferences;

  AuthMethod _authMethod = AuthMethod.login;

  AuthMethod get authMethod => _authMethod;

  final StreamController<User?> _userController = StreamController();

  Stream<User?> get userStream => _userController.stream;

  User? _currentUser;

  User? get currentUser {
    if (_currentUser != null) return _currentUser;

    User? user;
    getCurrentUser().then((u) {
      user = u;
    });
    return user;
  }

  AuthProvider(
      {required AuthService authService,
      required UserService userService,
      required SharedPreferences sharedPreferences})
      : super(authService, sharedPreferences) {
    _authService = authService;
    _userService = userService;
    _sharedPreferences = sharedPreferences;

    isLoggedIn();
  }

  void changeAuthMethod(AuthMethod method) {
    _authMethod = method;
    if (!isDisposed) notifyListeners();
  }

  Future<bool> submit(UserWrapper userWrapper) async {
    changeLoadingStatus();

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
      Utils.showMessage('Error: ${e.message}');
    }

    if (success) {
      _userController
          .add(User.fromJson(JwtToken.payload(tokens!.accessToken)['user']));
    }

    changeLoadingStatus();
    return success;
  }

  Future<bool> _saveWrappedToken(WrappedToken tokens) async {
    bool accessSuccess =
        await _sharedPreferences.setString('access_token', tokens.accessToken);
    bool refreshSuccess = await _sharedPreferences.setString(
        'refresh_token', tokens.refreshToken);
    return accessSuccess && refreshSuccess;
  }

  @override
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

    _currentUser = User.fromJson(JwtToken.payload(accessToken!)['user']);
    _userController.add(_currentUser);
    return accessToken;
  }

  Future<User?> getCurrentUser() async {
    _currentUser = null;

    await Future.delayed(const Duration(milliseconds: 250));
    changeLoadingStatus();

    try {
      String? token = await isLoggedIn();
      if (token != null) {
        _currentUser = await _authService.getCurrentUser(token);
      }
    } on ApiError catch (e) {
      Utils.showMessage('Error: ${e.message}');
    }

    changeLoadingStatus();
    return _currentUser;
  }

  Future<bool> deleteUser() async {
    bool success = false;

    try {
      String? token = await isLoggedIn();
      if (token != null) {
        success = await _authService.deleteUser(token);

        if (success) {
          await removeAccessToken();
          await removeRefreshToken();
          _userController.add(null);

          Utils.showMessage('Profile successfully deleted', false);
        }
      }
    } on ApiError catch (e) {
      Utils.showMessage('Error: ${e.message}');
    }

    return success;
  }

  Future<void> logout() async {
    changeLoadingStatus();

    await removeAccessToken();
    await removeRefreshToken();

    _userController.add(null);

    changeLoadingStatus();
  }

  Future<User?> getUser(String id) async {
    try {
      String? token = await isLoggedIn();
      if (token != null) {
        return await _userService.getUser(id: id, token: token);
      }
    } on ApiError catch (e) {
      Utils.showMessage('Error: ${e.message}');
    }

    return null;
  }

  Future<bool?> uploadProfilePicture(String id, PlatformFile image) async {
    try {
      String? token = await isLoggedIn();
      if (token != null) {
        return await _userService.uploadProfilePicture(
            id: id, token: token, image: image);
      }
    } on ApiError catch (e) {
      Utils.showMessage('Error: ${e.message}');
    }

    return null;
  }

  @override
  void dispose() {
    _userController.close();
    super.dispose();
  }
}
