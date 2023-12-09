import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChange;

  const CustomBottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onTabChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 1.0),
      child: GNav(
        activeColor: Colors.white,
        gap: 8.0,
        curve: Curves.easeInOut,
        color: Colors.white,
        duration: Duration(milliseconds: 500),
        tabs: [
          GButton(
            icon: Icons.home,
            text: 'Home',
            iconColor: Colors.blue[100],
          ),
          GButton(
            icon: Icons.search,
            text: 'Search',
            iconColor: Colors.blue[100],
          ),
          GButton(
            icon: Icons.library_music,
            text: 'Playlists',
            iconColor: Colors.blue[100],
          ),
          GButton(
            icon: Icons.person,
            text: 'Profile',
            iconColor: Colors.blue[100],
          ),
        ],
        selectedIndex: selectedIndex,
        onTabChange: onTabChange,
      ),
    );
  }
}
