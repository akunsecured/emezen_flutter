import 'package:emezen/model/user.dart';
import 'package:emezen/network/api_service.dart';
import 'package:emezen/widgets/bordered_text_field.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late ApiService _apiService;

  late TextEditingController _firstNameController,
      _lastNameController,
      _ageController,
      _emailController,
      _passwordController,
      _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();

    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _ageController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.only(top: 16, bottom: 32),
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
              BorderedTextField(_emailController, 'Email address',
                  TextInputType.emailAddress),
              BorderedTextField(_passwordController, 'Password',
                  TextInputType.visiblePassword),
              BorderedTextField(_confirmPasswordController, 'Confirm password',
                  TextInputType.visiblePassword),
              Container(
                margin: EdgeInsets.only(top: 32, bottom: 16),
                child: ElevatedButton(
                  child: Text('Register'),
                  onPressed: () async {
                    var token = await _apiService.register(
                        UserDataWithCredentials(
                            user: User(
                                firstName: _firstNameController.text,
                                lastName: _lastNameController.text,
                                age: int.parse(_ageController.text)),
                            userCredentials: UserCredentials(
                                email: _emailController.text,
                                password: _passwordController.text)));
                    print(token);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}