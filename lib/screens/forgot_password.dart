import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  Future<void> _resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );
      Get.snackbar(
        'Password Reset Email Sent',
        'Check your email for a password reset link.',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 5),
      );
      // Navigate to login screen or any other screen after sending reset email
      Get.offNamed('/login');
    } catch (e) {
      // Handle any errors that occur during the password reset process
      print('Error during password reset: $e');
      Get.snackbar(
        'Error',
        'Failed to send password reset email. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 5),
        backgroundColor: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _resetPassword,
              child: Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}
