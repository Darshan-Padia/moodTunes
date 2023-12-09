import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SongModel {
  final String videoId;
  final String title;
  final List<Map<String, dynamic>> artists;
  final Map<String, dynamic> album; // Add album information

  final List<Map<String, dynamic>> thumbnails;
  final String duration;
  final Rx<bool> isLiked;

  SongModel({
    required this.videoId,
    required this.title,
    required this.artists,
    required this.album, // Add album information

    required this.thumbnails,
    required this.duration,
    required this.isLiked,
  });

  factory SongModel.fromJson(Map<String, dynamic> json) {
    // Assuming json['album'] is a dynamic type
    dynamic albumData = json['album'];
    print('albumData: $albumData');
    Map<String, dynamic> album;

    // Check if albumData is a String
    if (albumData is String) {
      // If it's a String, create a Map with a specified key (e.g., 'albumName')
      album = {'name': albumData};
    } else if (albumData is Map<String, dynamic>) {
      // If it's already a Map, use it as is
      album = Map<String, dynamic>.from(albumData);
    } else {
      // Handle the case where 'albumData' is not of the expected type
      print('Error: Unexpected type for albumData');
      album = {}; // Provide a default value or handle the error as needed
    }

    return SongModel(
      videoId: json['videoId']?.toString() ?? '',
      title: json['title'] ?? '',
      artists: List<Map<String, dynamic>>.from(json['artists'] ?? []),
      album: album, // Use the 'album' Map
      thumbnails: List<Map<String, dynamic>>.from(json['thumbnails'] ?? []),
      duration: json['duration']?.toString() ?? '',
      isLiked: Rx<bool>(json['isLiked'] ?? false),
    );
  }

  // similarly from 'List<Map<String, dynamic>>'
}
