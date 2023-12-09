import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:mood_tunes/models/text_fields_.dart';
import 'package:mood_tunes/screens/home.dart';
import 'package:mood_tunes/user_controller.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  CustomTextFieldBuilder textFieldBuilder = CustomTextFieldBuilder();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          child: Column(
            children: [
              Container(
                height: size.height * 0.24,
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColorDark,
                      Theme.of(context).primaryColorLight,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MoodTunes',
                      style: Theme.of(context).textTheme.headline2?.copyWith(
                            color: Theme.of(context).hintColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      'Signup',
                      style: Theme.of(context).textTheme.headline3?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Welcome to MoodTunes',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              textFieldBuilder.buildTextField("Username", _usernameController),
              textFieldBuilder.buildTextField("Email", _emailController),
              textFieldBuilder.buildTextField("Password", _passwordController,
                  isPassword: true),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _handleSignUp,
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (!_isLoading)
                      Icon(
                        Icons.person_add,
                        size: 30,
                        color: Colors.white,
                      ),
                    if (_isLoading)
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    if (!_isLoading)
                      Positioned(
                        left: 40,
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: _isLoading ? null : _showLoginScreen,
                child: Text(
                  "Already registered? Login here",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleSignUp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      await _auth.currentUser
          ?.updateDisplayName(_usernameController.text.trim());

      Get.find<UserController>().setUser(_auth.currentUser);

      Get.off(HomeScreen());
    } catch (e) {
      print("Error during sign up: $e");
      if (e.toString() ==
          '[firebase_auth/email-already-in-use] The email address is already in use by another account.') {
        Get.snackbar(
          'Error',
          'User already registered',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Some error occurred',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showLoginScreen() {
    Get.toNamed('/login');
  }
}
