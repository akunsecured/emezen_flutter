import 'package:emezen/model/enums.dart';

class PageWithArgs {
  MainPages page;
  Map<String, dynamic> args;

  PageWithArgs({required this.page, this.args = const {}});
}
