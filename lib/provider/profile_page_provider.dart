import 'package:emezen/model/enums.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ProfilePageProvider extends ChangeNotifier {
  bool _isDisposed = false;
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

  ProfilePageProvider() {
    _actualTab = ProfileTabs.about;

    _aboutController = TextEditingController();
    _contactEmailController = TextEditingController();
    _phoneNumberController = TextEditingController();
  }

  void changeTab(ProfileTabs tab) {
    if (_actualTab == tab) return;
    _actualTab = tab;
    if (!_isDisposed) notifyListeners();
  }

  void changeEditingProfile() {
    _isEditingProfile = !_isEditingProfile;
    if (!_isDisposed) notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}