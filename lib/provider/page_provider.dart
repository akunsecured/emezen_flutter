import 'package:emezen/model/enums.dart';
import 'package:emezen/model/page_with_args.dart';
import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';

class PageProvider extends ChangeNotifier {
  bool _isDisposed = false;

  late PageWithArgs _actualPage;

  PageWithArgs get actualPage => _actualPage;

  PageProvider() {
    _actualPage = PageWithArgs(page: Page.home);
  }

  void changePage(Page page, {Map<String, dynamic> args = const {}}) {
    if (page == _actualPage.page &&
        const MapEquality().equals(args, _actualPage.args)) return;
    _actualPage = PageWithArgs(page: page, args: args);
    if (!_isDisposed) notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
