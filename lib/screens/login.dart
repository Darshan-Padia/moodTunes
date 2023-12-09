import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mood_tunes/screens/forgot_password.dart';
import 'package:mood_tunes/screens/sign_up.dart';
import 'package:mood_tunes/models/text_fields_.dart';
import 'package:mood_tunes/user_controller.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  CustomTextFieldBuilder textFieldBuilder = CustomTextFieldBuilder();

  bool _isLoading = false;
  String _errorMessage = '';

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
                      'Sign in to your\nAccount',
                      style: Theme.of(context).textTheme.headline3?.copyWith(
                            color: Theme.of(context).hintColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      'MoodTunes',
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              textFieldBuilder.buildTextField("Email", _emailController),
              textFieldBuilder.buildTextField("Password", _passwordController,
                  isPassword: true),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _handleLogin,
                style: ElevatedButton.styleFrom(
                  primary:
                      Theme.of(context).colorScheme.primary, // Background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (!_isLoading) // Show icon only when not loading
                      Icon(
                        Icons.login,
                        size: 30,
                        color: Colors.white,
                      ),
                    AnimatedSize(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: _isLoading
                          ? SizedBox(
                              width: 30,
                              height: 30,
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : SizedBox.shrink(),
                    ),
                    if (!_isLoading) // Show text only when not loading
                      Positioned(
                        left: 40,
                        child: Text(
                          "Login",
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
              if (_errorMessage.isNotEmpty)
                GestureDetector(
                  onTap: _isLoading ? null : _showForgotPasswordScreen,
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              GestureDetector(
                onTap: _isLoading ? null : _showSignUpScreen,
                child: Text(
                  "Not registered? Sign up here",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      Get.find<UserController>().setUser(_auth.currentUser);

      Get.offNamed('/home');
    } catch (e) {
      print("Error during login: $e");
      Get.snackbar(
        'Login Failed',
        'Wrong email or password. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
      );
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showForgotPasswordScreen() {
    Get.to(ForgotPasswordScreen(), transition: Transition.fadeIn);
  }

  void _showSignUpScreen() {
    Get.to(SignUpScreen(), transition: Transition.fadeIn);
  }
}
