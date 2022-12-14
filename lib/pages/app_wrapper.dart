import 'package:emezen/model/user.dart';
import 'package:emezen/pages/auth_screen.dart';
import 'package:emezen/pages/app_screen.dart';
import 'package:emezen/provider/auth_provider.dart';
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
          return AppScreen(user: user);
        }

        return const AuthScreen();
      });
}
