import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mood_tunes/firebase_db.dart';
import 'package:mood_tunes/models/savn_search.dart';
import 'package:mood_tunes/models/song_model.dart';
import 'package:mood_tunes/user_controller.dart';

class SongMainScreen extends StatelessWidget {
  // const SongMainScreen({super.key});
  SongMainScreen({required this.songmodel_savn});
  final Song songmodel_savn;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Now Playing",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor:
            const Color.fromARGB(255, 58, 66, 183), // Choose a suitable color
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color.fromARGB(255, 2, 49, 102), Colors.indigo],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // first showing song photo associated on 1/2 of the screen
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/images/album_cover.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // showing song title and artist name
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Text(
                    'Song Title',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Artist Name',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            // showing song duration and like button
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Flex(
                        direction: Axis.horizontal,
                        // space between song duration and like button
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '3:45',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.favorite_border,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // showing song progress bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: LinearProgressIndicator(
                value: 0.5,
                backgroundColor: Colors.grey[800],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            // showing song control buttons
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.skip_previous,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.skip_next,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ),
            // showing song volume control
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.volume_down,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.volume_up,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
