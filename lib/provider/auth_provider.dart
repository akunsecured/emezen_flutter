import 'package:emezen/model/enums.dart';
import 'package:emezen/model/user.dart';
import 'package:emezen/network/auth_service.dart';
import 'package:emezen/util/errors.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;

  bool _isDisposed = false;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  AuthProvider(this._authService);

  void _changeLoadingStatus() {
    _isLoading = !_isLoading;
    if (!_isDisposed) notifyListeners();
  }

  Future<bool> submit(UserWrapper userWrapper) async {
    _changeLoadingStatus();

    String? token;
    try {
      if (userWrapper.type == UserWrapperType.userDataWithCredentials) {
        token = await _authService.register(userWrapper);
      }
      if (userWrapper.type == UserWrapperType.credentials) {
        token = await _authService.login(userWrapper.userCredentials!);
      }
    } on ApiError catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Error: ${e.message}");

      _changeLoadingStatus();
      return false;
    }

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (token != null) sharedPreferences.setString("token", token);

    _changeLoadingStatus();
    return true;
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
