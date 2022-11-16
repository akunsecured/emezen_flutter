class Validation {
  static RegExp emailRegExp = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  static RegExp passwordRegExp = RegExp(
      r'^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[*.!@$%^&(){}[]:;<>,.?/~_+-=|\]).{8,64}$');
  static RegExp numUntil999RegExp = RegExp(r'^\d{1,3}');
  static RegExp priceRegExp = RegExp(r'^\d{1,3}(\.\d{0,2})?');

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
    if (value != null && value.isNotEmpty && value.length < 8) {
      if (value.length < 8) {
        return 'Password should be at least 8 characters';
      }
      if (value.length > 64) {
        return 'Password should be at most 64 characters';
      }
    }
    return null;
  }

  static String? validatePartOfName(String? value, {bool isNeeded = true}) {
    if (isNeeded && (value == null || value.isEmpty)) {
      return 'This field must be filled';
    }
    if (value != null && value.isNotEmpty) {
      if (value.length > 50) {
        return 'This field cannot be longer than 50 characters';
      }
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
    if (value != null && value.isNotEmpty) {
      int? parsedNum = int.tryParse(value);
      if (parsedNum == null) {
        return 'Bad format for a number';
      }
      if (value.length != 11) {
        return 'Phone number must be 11 characters';
      }
    }
    return null;
  }

  static String? validateAge(String? value, {bool isNeeded = true}) {
    if (isNeeded && (value == null || value.isEmpty)) {
      return 'Age must be filled';
    }
    if (value != null && value.isNotEmpty) {
      int? parsedNum = int.tryParse(value);
      if (parsedNum == null) {
        return 'Bad format for a number';
      }
      if (parsedNum < 13) {
        return 'The number which was given for the age is too low';
      }
      if (parsedNum > 100) {
        return 'The number which was given for the age is too high';
      }
    }
    return null;
  }

  static String? validatePrice(String? value, {bool isNeeded = true}) {
    if (isNeeded && (value == null || value.isEmpty)) {
      return 'Price must be filled';
    }
    if (value != null && value.isNotEmpty) {
      double? parsedNum = double.tryParse(value);
      if (parsedNum == null) {
        return 'Bad format for a number';
      }
      if (parsedNum < 0.01 || parsedNum > 999.99) {
        return 'Price must be between 0.01 and 999.99';
      }
    }
    return null;
  }

  static String? validateQuantity(String? value, {bool isNeeded = true}) {
    if (isNeeded && (value == null || value.isEmpty)) {
      return 'Quantity must be filled';
    }
    if (value != null && value.isNotEmpty) {
      int? parsedNum = int.tryParse(value);
      if (parsedNum == null) {
        return 'Bad format for a number';
      }
      if (parsedNum < 1 || parsedNum > 100) {
        return 'Quantity must be between 1 and 100';
      }
    }
    return null;
  }

  static String? validateDetails(String? value, {bool isNeeded = true}) {
    if (isNeeded && (value == null || value.isEmpty)) {
      return 'Details must be filled';
    }
    if (value != null && value.isNotEmpty) {
      if (value.length > 500) {
        return 'Details cannot be longer than 500 characters';
      }
    }
    return null;
  }
}
