import 'package:emezen/model/enums.dart';
import 'package:emezen/model/user.dart';
import 'package:emezen/provider/auth_provider.dart';
import 'package:emezen/provider/cart_provider.dart';
import 'package:emezen/util/validation.dart';
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
  final GlobalKey<FormState> _loginFormKey = GlobalKey();

  late TextEditingController _emailController, _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _loginFormKey,
      child: Column(
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
            _emailController,
            'Email address',
            TextInputType.emailAddress,
            validateFun: Validation.validateEmail,
          ),
          BorderedTextField(
            _passwordController,
            'Password',
            TextInputType.visiblePassword,
            passwordText: true,
            validateFun: Validation.validatePassword,
          ),
          Container(
            width: double.infinity,
            margin:
                const EdgeInsets.only(top: 32, bottom: 16, left: 12, right: 12),
            child: Consumer<AuthProvider>(
                builder: (context, authProvider, child) =>
                    Selector<AuthProvider, bool>(
                      selector: (_, authProvider) => authProvider.isLoading,
                      builder: (_, isLoading, __) => LoadingSupportButton(
                          isLoading: isLoading,
                          text: 'Login',
                          onPressed: () async {
                            if (_loginFormKey.currentState?.validate() ??
                                false) {
                              Provider.of<CartProvider>(context, listen: false)
                                  .cart
                                  .clear();
                              await Provider.of<AuthProvider>(context,
                                      listen: false)
                                  .submit(UserWrapper(
                                      userCredentials: UserCredentials(
                                          email: _emailController.text,
                                          password: _passwordController.text),
                                      type: UserWrapperType.credentials));
                            }
                          }),
                    )),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Stack(
              children: [
                const Divider(),
                Center(
                    child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  color: Colors.white,
                  child: const Text(
                    'New to Emezon?',
                  ),
                ))
              ],
            ),
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.grey.shade200),
              onPressed: () {
                Provider.of<AuthProvider>(context, listen: false)
                    .changeAuthMethod(AuthMethod.register);
              },
              child: const Text('Register'),
            ),
          )
        ],
      ),
    );
  }
}
