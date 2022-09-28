import 'package:flutter/material.dart';

import '../model/user.dart';
import '../network/api_service.dart';
import '../widgets/bordered_text_field.dart';

class LoginForm extends StatefulWidget {
  final ApiService _apiService;

  const LoginForm(this._apiService, {Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late TextEditingController _emailController, _passwordController;

  @override
  void initState() {
    super.initState();

    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16, bottom: 32),
          child: const Text(
            'Sign in',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        BorderedTextField(
            _emailController, 'Email address', TextInputType.emailAddress),
        BorderedTextField(
            _passwordController, 'Password', TextInputType.visiblePassword),
        Container(
          margin: EdgeInsets.only(top: 32, bottom: 16),
          child: ElevatedButton(
            child: Text('Sign in'),
            onPressed: () async {
              var token = await widget._apiService.login(UserCredentials(
                  email: _emailController.text,
                  password: _passwordController.text));
              print(token);
            },
          ),
        )
      ],
    );
  }
}
