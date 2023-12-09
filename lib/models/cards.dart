import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mood_tunes/apis/songs_api.dart';
import 'package:mood_tunes/models/homepage_savn.dart';
import 'package:mood_tunes/screens/sng_dtail.dart';

class GlassyCard extends StatelessWidget {
  GlassyCard({required this.album, this.index = 0});
  final int index;
  SaavnAlbum album;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        try {
          List<dynamic> songsData =
              await SongApi().fetchSaavnAlbumDetails(album.id);
          List<Songg> songs =
              songsData.map((json) => Songg.fromJson(json)).toList();
          Get.to(
            SongDetailsScreen(songs: songs),
          );
        } catch (e) {
          print(e);
        }
      },
      child: Container(
        width: 150,
        margin: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).cardColor, // Use theme for card color
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: [
              // Add your card content here
              Image.network(
                album.images[2].link, // Replace with your image URL
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                // width: 50,
                // height: 170,
              ),
              // Add glass effect overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0),
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
              // You can add other card contents, such as title and subtitle, on top of the image
              // Example:
              Positioned(
                bottom: 10,
                left: 10,
                right: 10,
                child: Text(
                  album.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
