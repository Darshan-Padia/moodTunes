import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';

import 'package:mood_tunes/screens/mood_playlist_screen.dart';

class MoodScreen extends StatelessWidget {
  MoodScreen({Key? key});

  List<List<Color>> generateRandomGradients() {
    final random = Random();
    return List.generate(
      moods.length,
      (index) => [
        Color.fromRGBO(
            random.nextInt(256), random.nextInt(256), random.nextInt(256), 1),
        Color.fromRGBO(
            random.nextInt(256), random.nextInt(256), random.nextInt(256), 1),
      ],
    );
  }

  final List<String> moods = [
    'Chill',
    'Commute',
    'Energy Boosters',
    'Feel Good',
    'Focus',
    'Party',
    'Romance',
    'Sad',
    'Sleep',
    'Workout',
    'African',
    'Arabic',
    'Assamese & Odia',
    'Bengali',
    'Bhojpuri',
    'Carnatic Classical',
    'Classical',
    'Country & Americana',
    'Dance & Electronic',
    'Decades',
    'Devotional',
    'Family',
    'Folk & Acoustic',
    'Ghazal/Sufi',
    'Gujarati',
    'Haryanvi',
    'Hindi',
    'Hindustani Classical',
    'Hip-Hop',
    'Indian Indie',
    'Indian Pop',
    'Indie & Alternative',
    'J-Pop',
    'Jazz',
    'K-Pop',
    'Kannada',
    'Latin',
    'Malayalam',
    'Marathi',
    'Metal',
    'Monsoon',
    'Pop',
    'Punjabi',
    'R&B & Soul',
    'Reggae & Caribbean',
    'Rock',
    'Tamil',
    'Telugu'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Moods'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(16.0),
        childAspectRatio: 8.0 / 9.0,
        mainAxisSpacing: 16.0,
        crossAxisSpacing: 16.0,
        children: List.generate(moods.length, (index) {
          List<Color> gradientColors = generateRandomGradients()[index];
          return InkWell(
            onTap: () {
              Get.to(() => MoodPlaylistScreen(moodTitle: moods[index]));
            },
            child: Ink(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Center(
                child: Text(
                  moods[index],
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
