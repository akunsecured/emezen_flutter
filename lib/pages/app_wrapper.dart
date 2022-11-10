import 'package:emezen/model/user.dart';
import 'package:emezen/network/product_service.dart';
import 'package:emezen/pages/auth_screen.dart';
import 'package:emezen/pages/app_screen.dart';
import 'package:emezen/provider/auth_provider.dart';
import 'package:emezen/provider/main_page_provider.dart';
import 'package:emezen/provider/product_provider.dart';
import 'package:emezen/provider/profile_page_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppWrapper extends StatefulWidget {
  const AppWrapper({Key? key}) : super(key: key);

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  late final AuthProvider _authProvider;

  @override
  void initState() {
    super.initState();
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) => StreamBuilder(
      stream: _authProvider.userStream,
      builder: (context, AsyncSnapshot<User?> snapshot) {
        User? user = snapshot.data;

        if (user != null) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => MainPageProvider()),
              ChangeNotifierProvider(create: (_) => ProfilePageProvider()),
              ChangeNotifierProvider(
                  create: (_) => ProductProvider(_authProvider,
                      Provider.of<ProductService>(context, listen: false)))
            ],
            child: AppScreen(user: user),
          );
        }

        return const AuthScreen();
      });
}
