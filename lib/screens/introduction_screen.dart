import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroductionScreen extends StatelessWidget {
  const IntroductionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Introduction'),
      ),
      body: Column(
        children: [
          // Your introduction screen content with images and text
          // You can use PageView or any other widget for multiple screens
          // For simplicity, I'll use a single screen
          Image.asset(
              'assets/images/mood_tunes_logo.png'), // Replace with your image
          Text('Welcome to MoodTunes!'),
          // Add other widgets for additional screens

          // Skip and Next buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  _setIntroductionComplete();
                  Get.offNamed('/home'); // Navigate to your home screen
                },
                child: Text('Skip'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the next screen or perform any other action
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Function to set introduction completion status in shared preferences
  Future<void> _setIntroductionComplete() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('intro_complete', true);
  }
}
