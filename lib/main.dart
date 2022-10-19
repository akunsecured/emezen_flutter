import 'package:emezen/network/auth_service.dart';
import 'package:emezen/network/user_service.dart';
import 'package:emezen/pages/app_wrapper.dart';
import 'package:emezen/provider/auth_provider.dart';
import 'package:emezen/style/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
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
  late final AuthProvider _authProvider;

  @override
  void initState() {
    super.initState();
    _authService = AuthService();
    _userService = UserService();
    _authProvider = AuthProvider(
        authService: _authService,
        userService: _userService,
        sharedPreferences: widget.sharedPreferences);
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Emezen',
    theme: ThemeData(
        primarySwatch: AppTheme.primarySwatch,
        appBarTheme: AppBarTheme(
            color: AppTheme.appBarColor, centerTitle: true)),
    home: MultiProvider(
          providers: [
            Provider<AuthService>(create: (_) => _authService),
            Provider<UserService>(create: (_) => _userService),
            ChangeNotifierProvider<AuthProvider>(create: (_) => _authProvider),
          ],
          child: const AppWrapper(),
        ),
  );
}
