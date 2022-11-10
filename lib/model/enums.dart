import 'package:emezen/model/enums.dart';

enum AuthMethod { login, register }

enum UserWrapperType { userData, credentials, userDataWithCredentials }

enum MainPages {
  home,
  profile,
  newProduct,
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
