import 'package:emezen/model/enums.dart';
import 'package:emezen/network/api_service.dart';
import 'package:emezen/pages/login_form.dart';
import 'package:emezen/pages/register_form.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  final AuthMethod _authMethod;

  const AuthScreen(this._authMethod, {Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late ApiService _apiService;

  @override
  void initState() {
    super.initState();

    _apiService = ApiService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Container(
          height: AppBar().preferredSize.height,
          padding: const EdgeInsets.all(12),
          child: const Image(
            image: AssetImage('assets/images/emezen-logo-dark.png'),
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          width: 400,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black38, width: 2.0),
              borderRadius: const BorderRadius.all(Radius.circular(12))),
          child: widget._authMethod == AuthMethod.login
              ? LoginForm(_apiService)
              : RegisterForm(_apiService),
        ),
      ),
    );
  }
}
