import 'package:emezen/model/enums.dart';
import 'package:emezen/model/product.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class CreateEditProductProvider extends ChangeNotifier {
  bool _isDisposed = false;

  final String _sellerId;

  late final TextEditingController _nameController,
      _priceController,
      _detailsController,
      _quantityController;

  CreateEditProductProvider(this._sellerId) {
    _nameController = TextEditingController();
    _priceController = TextEditingController();
    _detailsController = TextEditingController();
    _quantityController = TextEditingController();
  }

  TextEditingController get nameController => _nameController;
  TextEditingController get priceController => _priceController;
  TextEditingController get detailsController => _detailsController;
  TextEditingController get quantityController => _quantityController;

  ProductCategories _selectedCategory = ProductCategories.values[0];

  ProductCategories get selectedCategory => _selectedCategory;
  void setSelectedCategory(ProductCategories? category) {
    _selectedCategory = category ?? ProductCategories.values[0];

    if (!_isDisposed) notifyListeners();
  }

  List<PlatformFile> images = [];
  List<String> imageUrls = [];

  Product getProduct() => Product(
    name: _nameController.text,
    sellerId: _sellerId,
    price: double.parse(_priceController.text),
    details: _detailsController.text,
    quantity: int.parse(_quantityController.text),
    category: _selectedCategory
  );

  void setImages(List<PlatformFile> images) {
    this.images = images;

    if (!_isDisposed) notifyListeners();
  }

  void removeImage(PlatformFile image) {
    images.remove(image);

    if (!_isDisposed) notifyListeners();
  }

  void clear() {
    _nameController.clear();
    _priceController.clear();
    _detailsController.clear();
    _quantityController.clear();

    images.clear();

    if (!_isDisposed) notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}