import 'package:emezen/model/product.dart';
import 'package:flutter/foundation.dart';

class ProductPageProvider extends ChangeNotifier {
  bool _isDisposed = false;

  final Product _product;

  Product get product => _product;

  final List<String> _images = [];

  List<String> get images => _images;

  int _selectedImageIndex = 0;

  int get selectedImageIndex => _selectedImageIndex;

  ProductPageProvider(this._product) {
    _images.addAll(_product.images.map((image) => image.toString()));
  }

  void setSelectedImageIndex(int index) {
    _selectedImageIndex = index;

    if (!_isDisposed) notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
