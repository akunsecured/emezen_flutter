class Validation {
  static RegExp emailRegExp = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  static RegExp passwordRegExp = RegExp(
      r'^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[*.!@$%^&(){}[]:;<>,.?/~_+-=|\]).{8,64}$');

  static String? validateEmail(String? value, {bool isNeeded = true}) {
    if (isNeeded && (value == null || value.isEmpty)) {
      return 'Email must be filled';
    }
    if (value != null && value.isNotEmpty && !emailRegExp.hasMatch(value)) {
      return 'Email is badly formatted';
    }
    return null;
  }

  static String? validatePassword(String? value, {bool isNeeded = true}) {
    if (isNeeded && (value == null || value.isEmpty)) {
      return 'Password must be filled';
    }
    if (value != null && value.isNotEmpty && value.length < 6) {
      return 'Password should be at least 6 characters';
    }
    return null;
  }

  static String? validateName(String? value, {bool isNeeded = true}) {
    if (isNeeded && (value == null || value.isEmpty)) {
      return 'Name must be filled';
    }
    if (value != null && value.isNotEmpty && value.length < 2) {
      return 'Name should be at least 2 characters';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String? matchWith) {
    if (value == null || value.isEmpty) {
      return 'Confirm password must be filled';
    }
    if (value != matchWith) return 'Passwords do not match';
    return null;
  }

  static String? validatePhoneNumber(String? value, {bool isNeeded = true}) {
    if (isNeeded && (value == null || value.isEmpty)) {
      return 'Phone number must be filled';
    }
    if (value != null && value.isNotEmpty && value.length != 11) {
      return 'Phone number must be 11 characters';
    }
    return null;
  }
}
