import 'package:emezen/model/enums.dart';
import 'package:emezen/model/user.dart';
import 'package:emezen/provider/auth_provider.dart';
import 'package:emezen/widgets/bordered_text_field.dart';
import 'package:emezen/widgets/loading_support_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  late TextEditingController _firstNameController,
      _lastNameController,
      _ageController,
      _emailController,
      _passwordController,
      _confirmPasswordController;

  @override
  void initState() {
    super.initState();

    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _ageController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

    print(Provider.of<AuthProvider>(context, listen: false).ping);
  }

  void _navigateBack() {}

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 16, bottom: 32),
          child: const Text(
            'Create account',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: BorderedTextField(
                  _firstNameController, 'First name', TextInputType.name),
            ),
            Expanded(
              child: BorderedTextField(
                  _lastNameController, 'Last name', TextInputType.name),
            ),
          ],
        ),
        BorderedTextField(_ageController, 'Age', TextInputType.number),
        BorderedTextField(
            _emailController, 'Email address', TextInputType.emailAddress),
        BorderedTextField(
          _passwordController,
          'Password',
          TextInputType.visiblePassword,
          passwordText: true,
        ),
        BorderedTextField(
          _confirmPasswordController,
          'Confirm password',
          TextInputType.visiblePassword,
          passwordText: true,
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
                text: 'Register',
                onPressed: () async {
                  bool success =
                      await Provider.of<AuthProvider>(context, listen: false)
                          .submit(UserWrapper(
                              user: User(
                                  firstName: _firstNameController.text,
                                  lastName: _lastNameController.text,
                                  age: int.parse(_ageController.text)),
                              userCredentials: UserCredentials(
                                  email: _emailController.text,
                                  password: _passwordController.text),
                              type: UserWrapperType.userDataWithCredentials));
                  if (success) _navigateBack();
                },
              ),
            ),
          ),
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
                  'Already have an account?',
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
                  .changeAuthMethod(AuthMethod.login);
            },
            child: const Text('Sign in'),
          ),
        )
      ],
    );
  }
}
