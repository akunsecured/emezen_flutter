import 'package:emezen/network/auth_service.dart';
import 'package:emezen/network/product_service.dart';
import 'package:emezen/network/user_service.dart';
import 'package:emezen/pages/app_wrapper.dart';
import 'package:emezen/provider/auth_provider.dart';
import 'package:emezen/provider/cart_provider.dart';
import 'package:emezen/provider/product_provider.dart';
import 'package:emezen/style/app_theme.dart';
import 'package:emezen/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  ResponsiveGridBreakpoints.value =
      ResponsiveGridBreakpoints(sm: Constants.mobilWidth.toDouble());
  runApp(EmezenApp(
    sharedPreferences: sharedPreferences,
  ));
}

class EmezenApp extends StatefulWidget {
  final SharedPreferences sharedPreferences;

  const EmezenApp({Key? key, required this.sharedPreferences})
      : super(key: key);

  @override
  State<EmezenApp> createState() => _EmezenAppState();
}

class _EmezenAppState extends State<EmezenApp> {
  late final AuthService _authService;
  late final UserService _userService;
  late final ProductService _productService;

  late final AuthProvider _authProvider;
  late final CartProvider _cartProvider;
  late final ProductProvider _productProvider;

  @override
  void initState() {
    super.initState();
    _authService = AuthService();
    _userService = UserService();
    _productService = ProductService();

    _authProvider = AuthProvider(
        authService: _authService,
        userService: _userService,
        sharedPreferences: widget.sharedPreferences);
    _cartProvider = CartProvider(_productService);
    _productProvider = ProductProvider(
        _productService, _authService, widget.sharedPreferences);
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Emezen',
        theme: ThemeData(
            primarySwatch: AppTheme.primarySwatch,
            appBarTheme:
                AppBarTheme(color: AppTheme.appBarColor, centerTitle: true)),
        home: MultiProvider(
          providers: [
            Provider<AuthService>(create: (_) => _authService),
            Provider<UserService>(create: (_) => _userService),
            Provider<ProductService>(create: (_) => _productService),
            ChangeNotifierProvider<AuthProvider>(create: (_) => _authProvider),
            ChangeNotifierProvider<CartProvider>(create: (_) => _cartProvider),
            ChangeNotifierProvider<ProductProvider>(
                create: (_) => _productProvider),
          ],
          child: const AppWrapper(),
        ),
      );
}
