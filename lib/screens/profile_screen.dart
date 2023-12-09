import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mood_tunes/screens/display_playlist.dart';
import 'package:mood_tunes/screens/home.dart';
import 'package:mood_tunes/screens/navbar.dart';
import 'package:mood_tunes/screens/search_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User _user;
  int _selectedIndex = 3;
  @override
  void initState() {
    super.initState();
    _getUser();
  }

  Future<void> _getUser() async {
    await Firebase.initializeApp();
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      _user = user!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavBar(
          selectedIndex: _selectedIndex,
          onTabChange: (index) {
            // setState(() {
            _selectedIndex = index;
            // });
            if (index == 0) {
              Get.to(HomeScreen());
            } else if (index == 1) {
              Get.offAll(() => SearchSongScreen(),
                  transition: Transition.rightToLeft,
                  duration: Duration(milliseconds: 500));
            } else if (index == 2) {
              Get.offAll(
                () => DisplayPlaylistScreen(),
                transition: Transition.rightToLeft,
                duration: Duration(milliseconds: 500),
              );

              // Get.to()
            } else if (index == 3) {
              // Get.offAll(
              //   () => ProfileScreen(),
              //   transition: Transition.rightToLeft,
              //   duration: Duration(milliseconds: 500),
              // );
              // Get.to()
            }
          }),
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey,
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/man_people.svg', // replace with your own SVG asset path
                  width: 60,
                  height: 60,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              _user.displayName ?? 'No Name',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(height: 10),
            Text(
              _user.email ?? 'No Email',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            SizedBox(height: 20),
            // Add more widgets or customize the layout as needed
          ],
        ),
      ),
    );
  }
}
