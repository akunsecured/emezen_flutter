import 'package:flutter/material.dart';

enum AuthMethod { login, register }

enum UserWrapperType { userData, credentials, userDataWithCredentials }

enum MainPages {
  home,
  profile,
  newProduct,
  product,
}

enum ProfileTabs {
  about,
  shop,
}

extension ProfileTabsExtension on ProfileTabs {
  String get value {
    switch (this) {
      case ProfileTabs.about:
        return 'About';
      case ProfileTabs.shop:
        return 'Shop';
      default:
        return '';
    }
  }
}

enum ProductCategories {
  artsCrafts,
  books,
  electronics,
  fashion,
}

extension ProductCategoriesExtension on ProductCategories {
  String get text {
    switch (this) {
      case ProductCategories.artsCrafts:
        return 'Arts & Crafts';
      case ProductCategories.books:
        return 'Books';
      case ProductCategories.electronics:
        return 'Electronics';
      case ProductCategories.fashion:
        return 'Fashion';
      default:
        return 'Unknown';
    }
  }
}

enum DeleteType {
  product,
  profile,
}

enum ProductDetailsMode {
  edit,
  preview,
}

extension ProductDetailsModeExtension on ProductDetailsMode {
  String getText() {
    switch (this) {
      case ProductDetailsMode.edit:
        return 'Edit';
      case ProductDetailsMode.preview:
        return 'Preview';
      default:
        return '';
    }
  }

  IconData getIcon() {
    switch (this) {
      case ProductDetailsMode.edit:
        return Icons.edit;
      case ProductDetailsMode.preview:
        return Icons.visibility_outlined;
      default:
        return Icons.question_mark;
    }
  }
}

enum TextFormatters {
  header1,
  header2,
  header3,
  bold,
  italic,
  underlined,
}
