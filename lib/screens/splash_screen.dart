import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _checkIfFirstTime();
  }

  void _checkIfFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool seen = prefs.getBool('seen') ?? false;

    if (!seen) {
      // If the introduction has not been seen, show the introduction screens
      _showIntroductionScreens();
    } else {
      // If the introduction has been seen, check authentication status
      _checkAuthenticationStatus();
    }
  }

  void _checkAuthenticationStatus() async {
    User? user = _auth.currentUser;

    if (user != null) {
      // If the user is authenticated, navigate to the home screen
      _navigateToHome();
    } else {
      // If the user is not authenticated, show a regular splash screen
      _showSignUpScreen();
    }
  }

  _showSignUpScreen() {
    Get.offAllNamed('/signup');
  }

  void _showIntroductionScreens() {
    // Use Get.to() to navigate to the introduction screens
    Get.to(() => IntroductionScreen(
          key: introKey,
          pages: [
            PageViewModel(
              title: "Welcome to Our App",
              body: "Get started and explore the amazing features.",
              image: Center(
                child: Image.asset("assets/images/mood_tunes_logo.png"),
              ),
            ),
            PageViewModel(
              title: "Discover New Things",
              body: "Find new ways to do amazing things.",
              image: Center(
                child: Image.asset("assets/images/mood_tunes_logo.png"),
              ),
            ),
            PageViewModel(
              title: "Get Started Now",
              body: "Start your journey now and have fun.",
              image: Center(
                child: Image.asset("assets/images/mood_tunes_logo.png"),
              ),
            ),
          ],
          onDone: () => _onIntroEnd(context),
          showSkipButton: true,
          skip: const Text("Skip"),
          next: const Icon(Icons.arrow_forward),
          done: const Text("Get Started"),
          dotsDecorator: DotsDecorator(
            size: const Size(10.0, 10.0),
            color: Colors.grey,
            activeColor: Colors.deepPurple,
            activeSize: const Size(20.0, 10.0),
          ),
        ));
  }

  void _showRegularSplashScreen() {
    // Delay for 2 seconds before navigating to the home screen
    Future.delayed(Duration(seconds: 2), () {
      _navigateToHome();
    });
  }

  void _onIntroEnd(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen', true);
    _checkAuthenticationStatus();
  }

  void _navigateToHome() {
    // printing in debug console to check if the navigation works
    print("Navigating to home screen...");
    debugPrint('Navigating to home screen...');
    Get.offAllNamed('/home'); // Use Get.offAllNamed to clear the stack
  }

  @override
  Widget build(BuildContext context) {
    // You can customize the splash screen UI here if needed
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // or any other splash screen UI
      ),
    );
  }
}
