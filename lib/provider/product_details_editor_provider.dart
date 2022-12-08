import 'package:emezen/model/enums.dart';
import 'package:flutter/material.dart';

class ProductDetailsEditorProvider extends ChangeNotifier {
  bool _isDisposed = false;

  ProductDetailsMode _actualTab = ProductDetailsMode.edit;

  ProductDetailsEditorProvider();

  ProductDetailsMode get actualTab => _actualTab;

  final TextEditingController _productDetailsController =
      TextEditingController();

  TextEditingController get productDetailsController =>
      _productDetailsController;

  void changeTab(ProductDetailsMode tab) {
    if (_actualTab == tab) return;
    _actualTab = tab;
    if (!_isDisposed) notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;

    super.dispose();
  }
}
