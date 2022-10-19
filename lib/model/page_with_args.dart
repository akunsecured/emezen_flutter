import 'package:emezen/model/enums.dart' as enums;

class PageWithArgs {
  enums.Page page;
  Map<String, dynamic> args;

  PageWithArgs({required this.page, this.args = const {}});
}
