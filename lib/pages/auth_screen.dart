import 'package:emezen/model/enums.dart';
import 'package:emezen/pages/login_form.dart';
import 'package:emezen/pages/register_form.dart';
import 'package:emezen/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

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
          child: Consumer<AuthProvider>(
            builder: (context, authProvider, child) => SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Selector<AuthProvider, AuthMethod>(
                selector: (_, authProvider) => authProvider.authMethod,
                builder: (_, authMethod, __) => authMethod == AuthMethod.login
                    ? const LoginForm()
                    : const RegisterForm(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
