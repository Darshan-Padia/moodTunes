import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mood_tunes/apis/songs_api.dart';
import 'package:mood_tunes/firebase_db.dart';
import 'package:mood_tunes/firebase_firestore_db.dart';
import 'package:mood_tunes/models/album_model.dart'; // Import the Album model
import 'package:mood_tunes/screens/album_song_screen.dart';

class SearchAlbums extends StatefulWidget {
  @override
  _SearchAlbumsState createState() => _SearchAlbumsState();
}

class _SearchAlbumsState extends State<SearchAlbums> {
  TextEditingController _searchController = TextEditingController();
  List<dynamic> searchResults = [];
  SongApi _songApi = SongApi();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Albums'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Enter search term',
                labelStyle: TextStyle(color: Colors.white),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search, color: Colors.white),
                  onPressed: () {
                    print('\n\nclickedddddddddd\nc\n');
                    _searchAlbums();
                  },
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: _buildSearchResults(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (searchResults.isEmpty) {
      print('\nempptyyyyyyyyyyyyyyyyy\n');
      return Center(
        child: Text(
          'No results to display',
          style: TextStyle(color: Colors.white),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: searchResults.length,
        itemBuilder: (context, index) {
          var album = searchResults[index];
          AlbumModel albumModel = AlbumModel.fromJson(album);
          print('\nalbumModel\n');

          // Print statements and null checks for albumModel properties
          print('Title: ${albumModel.title ?? 'Title not available'}');
          if (albumModel.artists.isNotEmpty) {
            print(
                'Artist: ${albumModel.artists[0]['name'] ?? 'Artist not available'}');
          } else {
            print('Artist not available');
          }

          print('\nalbumModel\n');

          return InkWell(
            onTap: () {
              Get.to(AlbumSongScreen(browseId: albumModel.browseId));
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color:
                    Colors.grey[800]!.withOpacity(0.1), // Set transparency here
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  // Add rounded radius bordered thumbnail leading
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Container(
                      width: 50.0, // Adjust the width as needed
                      height: 50.0, // Adjust the height as needed

                      // adding thumbnail
                      child: Image.network(
                        albumModel.thumbnails.isNotEmpty
                            ? albumModel.thumbnails[0]['url']
                            : 'placeholder_url',
                        width: 50.0,
                        height: 50.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.0), // Adjust the spacing as needed
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        albumModel.title != null
                            ? (albumModel.title!.length > 34
                                ? albumModel.title!.substring(0, 34) + '...'
                                : albumModel.title!)
                            : 'Title not available',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        albumModel.artists.isNotEmpty
                            ? albumModel.artists[0]['name'] ??
                                'Artist not available'
                            : 'Artist not available',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                        ),
                      ),
                      // Add more details as needed
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  Future<void> _searchAlbums() async {
    String searchTerm = _searchController.text.trim();

    if (searchTerm.isNotEmpty) {
      try {
        List<dynamic> results = await _songApi.fetchAlbumResults(searchTerm);

        setState(() {
          print('\n\n\mmmmm\nr');
          // if searchResults is empty, then again search for the same term
          if (searchResults.isEmpty) {
            print('\n\n\mmmmm\nr');
            _searchAlbums();
          }
          print(searchResults);
          searchResults = results;
        });

        // Fetch and store the current user ID
        User user = FirebaseAuth.instance.currentUser!;
        String userId = user.uid;

        // Now you can use userId for performing database operations.
        // For example, you can pass userId to methods like _addToPlaylist and _addToLikedSongs.
      } catch (e) {
        print('Error fetching search results: $e');
        setState(() {
          searchResults = [];
        });
      }
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
