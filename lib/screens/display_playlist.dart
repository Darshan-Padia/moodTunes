import 'dart:ui';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mood_tunes/firebase_firestore_db.dart'; // Import your Firestore database class
import 'package:mood_tunes/models/song_model.dart';
import 'package:mood_tunes/screens/home.dart';
import 'package:mood_tunes/screens/navbar.dart';
import 'package:mood_tunes/screens/playlist_song_screen.dart';
import 'package:mood_tunes/screens/profile_screen.dart';
import 'package:mood_tunes/screens/search_screen.dart'; // Replace with your actual song model

class DisplayPlaylistScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDb _firebaseDb = FirebaseDb();
  int _selectedIndex = 2;
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
              Get.offAll(HomeScreen());
            } else if (index == 1) {
              Get.offAll(() => SearchSongScreen(),
                  transition: Transition.rightToLeft,
                  duration: Duration(milliseconds: 500));
            } else if (index == 2) {
              // Get.offAll(
              //   () => DisplayPlaylistScreen(),
              //   transition: Transition.rightToLeft,
              //   duration: Duration(milliseconds: 500),
              // );

              // Get.to()
            } else if (index == 3) {
              Get.offAll(
                () => ProfileScreen(),
                transition: Transition.rightToLeft,
                duration: Duration(milliseconds: 500),
              );
              // Get.to()
            }
          }),
      appBar: AppBar(
        title: Text('Your Playlists'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: MediaQuery.of(context).size.height *
                0.3, // 1/3rd of the screen height
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.blueGrey,
                  Colors.black87,
                ], // Adjust gradient colors as needed
              ),
            ),
            child: Center(
              child: Text(
                'Your Playlists', // Optional: Add a title or any content for the gradient area
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: StreamBuilder<List<Map<String, String>>>(
                stream: _firebaseDb.getPlaylistsStream(getCurrentUserUid()),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    List<Map<String, String>> playlists = snapshot.data ?? [];
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Two cards in each row
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      itemCount: playlists.length,
                      itemBuilder: (context, index) {
                        return PlaylistCard(
                          playlistName: playlists[index]['name']!,
                          playlistId: playlists[index]['id']!,
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getCurrentUserUid() {
    return _auth.currentUser?.uid ?? '';
  }
}

class PlaylistCard extends StatelessWidget {
  final String playlistName;
  final String playlistId;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Random _random = Random();

  PlaylistCard({
    required this.playlistName,
    required this.playlistId,
  });

  String getCurrentUserUid() {
    return _auth.currentUser?.uid ?? '';
  }

  // LinearGradient _generateDarkGradient() {
  //   Color color1 = Color.fromRGBO(_random.nextInt(128) + 128,
  //       _random.nextInt(128) + 128, _random.nextInt(128) + 128, 1.0);
  //   Color color2 = Color.fromRGBO(_random.nextInt(128) + 128,
  //       _random.nextInt(128) + 128, _random.nextInt(128) + 128, 1.0);

  //   return LinearGradient(
  //     begin: Alignment.topLeft,
  //     end: Alignment.bottomRight,
  //     colors: [color1, color2],
  //   );
  // }
  LinearGradient _generateDarkGradient() {
    Color color1 = Color.fromARGB(
      255,
      _random.nextInt(128),
      _random.nextInt(128),
      _random.nextInt(128),
    );
    Color color2 = Color.fromARGB(
      255,
      _random.nextInt(128),
      _random.nextInt(128),
      _random.nextInt(128),
    );

    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [color1, color2],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent, // Set card color to transparent
      child: InkWell(
        onTap: () {
          // Navigate to a screen showing songs in the selected playlist
          navigateToPlaylistSongsScreen(context, playlistId);
        },
        child: Stack(
          children: [
            // Card with dark gradient background
            Container(
              decoration: BoxDecoration(
                gradient: _generateDarkGradient(),
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),

            // Text in the center
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  playlistName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.0, // Adjusted font size
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void navigateToPlaylistSongsScreen(BuildContext context, String playlistId) {
    Get.to(PlaylistSongsScreen(
      playlistName: playlistName,
      userId: getCurrentUserUid(),
      playlistId: playlistId,
    ));
  }
}
