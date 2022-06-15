import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:filmler_uygulamasi/authentication_client.dart';
import 'package:filmler_uygulamasi/validator.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final _emailFocusNode = FocusNode();

  final _passwordFocusNode = FocusNode();

  final _authClient = AuthenticationClient();

  bool _isProgress = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _emailFocusNode.unfocus();
        _passwordFocusNode.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.network(
                      "https://assets9.lottiefiles.com/datafiles/0BYCsvMJc8EIEvp/data.json"),
                  TextFormField(
                    controller: _emailController,
                    focusNode: _emailFocusNode,
                    validator: Validator.email,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter your email',
                      label: Text('Email'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    focusNode: _passwordFocusNode,
                    validator: Validator.password,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter your password',
                      label: Text('Password'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _isProgress
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: double.maxFinite,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _isProgress = true;
                                });
                                final User? user = await _authClient.loginUser(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                );
                                setState(() {
                                  _isProgress = false;
                                });
                                Map<String, dynamic> map;
                                Hive.box("loginAndUserData").put(
                                    "data",
                                    map = {
                                      "lastLogin": DateTime.now(),
                                      "userEmail": FirebaseAuth
                                          .instance.currentUser!.email
                                    });
                                if (user != null) {
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, "/categories", (route) => false,
                                      arguments: user);
                                }
                              }
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                'Sign In',
                                style: TextStyle(fontSize: 22.0),
                              ),
                            ),
                          ),
                        ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/registerPage");
                    },
                    child: const Text(
                      'Don\'t have an account? Click here to register',
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
