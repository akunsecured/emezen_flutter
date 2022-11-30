import 'package:emezen/model/enums.dart';
import 'package:emezen/network/auth_service.dart';
import 'package:emezen/provider/provider_base.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePageProvider extends ProviderBase {
  final AuthService _authService;

  bool _isEditingProfile = false;

  bool get isEditingProfile => _isEditingProfile;

  late ProfileTabs _actualTab;

  ProfileTabs get actualTab => _actualTab;

  late final TextEditingController _aboutController,
      _contactEmailController,
      _phoneNumberController;

  TextEditingController get aboutController => _aboutController;

  TextEditingController get contactEmailController => _contactEmailController;

  TextEditingController get phoneNumberController => _phoneNumberController;

  ProfilePageProvider(this._authService, SharedPreferences sharedPreferences)
      : super(_authService, sharedPreferences) {
    _actualTab = ProfileTabs.about;

    _aboutController = TextEditingController();
    _contactEmailController = TextEditingController();
    _phoneNumberController = TextEditingController();
  }

  void changeTab(ProfileTabs tab) {
    if (_actualTab == tab) return;
    _actualTab = tab;
    if (!isDisposed) notifyListeners();
  }

  void changeEditingProfile() {
    _isEditingProfile = !_isEditingProfile;
    if (!isDisposed) notifyListeners();
  }

// TODO: implement edit and delete profile
}
