import 'package:emezen/model/enums.dart';
import 'package:emezen/model/user.dart';
import 'package:emezen/network/api_service.dart';
import 'package:emezen/provider/auth_provider.dart';
import 'package:emezen/widgets/bordered_text_field.dart';
import 'package:emezen/widgets/loading_support_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

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

  void _navigateBack() => Navigator.pop(context);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 16, bottom: 32),
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
          width: double.infinity,
          margin:
              const EdgeInsets.only(top: 32, bottom: 16, left: 12, right: 12),
          child: ChangeNotifierProvider(
              create: (_) =>
                  AuthProvider(Provider.of<ApiService>(context, listen: false)),
              builder: (context, child) => Selector<AuthProvider, bool>(
                    selector: (_, authProvider) => authProvider.isLoading,
                    builder: (_, isLoading, __) => LoadingSupportButton(
                        isLoading: isLoading,
                        text: 'Login',
                        onPressed: () async {
                          bool success = await Provider.of<AuthProvider>(
                                  context,
                                  listen: false)
                              .submit(UserWrapper(
                                  userCredentials: UserCredentials(
                                      email: _emailController.text,
                                      password: _passwordController.text),
                                  type: UserWrapperType.credentials));
                          if (success) _navigateBack();
                        }),
                  )),
        ),
      ],
    );
  }
}
