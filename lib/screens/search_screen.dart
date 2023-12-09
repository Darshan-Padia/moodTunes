// // SearchSongs
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mood_tunes/apis/songs_api.dart';
import 'package:mood_tunes/firebase_db.dart';
import 'package:mood_tunes/firebase_firestore_db.dart';
import 'package:mood_tunes/models/song_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mood_tunes/screens/display_playlist.dart';
import 'package:mood_tunes/screens/download_dialogue.dart';
import 'package:mood_tunes/screens/home.dart';
import 'package:mood_tunes/screens/navbar.dart';
import 'package:mood_tunes/screens/profile_screen.dart';
import 'package:mood_tunes/screens/song_item_card.dart';
import 'package:get/get.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

// import 'package:firebase_messaging/firebase_messaging.dart';

// import 'package:mood_tunes/widgets/song_item_card.dart';

// class SearchSongs extends StatefulWidget {
//   @override
//   _SearchSongsState createState() => _SearchSongsState();
// }

// class _SearchSongsState extends State<SearchSongs> {
//   TextEditingController _searchController = TextEditingController();
//   List<dynamic> searchResults = [];
//   SongApi _songApi = SongApi();
//   int _searchIndex = 1;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       bottomNavigationBar: CustomBottomNavBar(
//           selectedIndex: _searchIndex,
//           onTabChange: (index) {
//             setState(() {
//               _searchIndex = index;
//             });
//             if (index == 0) {
//               Get.to(HomeScreen(),
//                   transition: Transition.leftToRightWithFade,
//                   duration: Duration(milliseconds: 500));
//             } else if (index == 1) {
//               // Get.to(SearchSongs())
//             } else if (index == 2) {
//               // Get.to()
//             } else if (index == 3) {
//               // Get.to()
//             }
//           }),
//       appBar: AppBar(
//         title: Text('Search Songs'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _searchController,
//               style: TextStyle(color: Colors.white),
//               decoration: InputDecoration(
//                 labelText: 'Enter search term',
//                 labelStyle: TextStyle(color: Colors.white),
//                 suffixIcon: IconButton(
//                   icon: Icon(Icons.search, color: Colors.white),
//                   onPressed: () {
//                     _searchSongs();
//                   },
//                 ),
//               ),
//             ),
//             SizedBox(height: 16.0),
//             Expanded(
//               child: _buildSearchResults(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSearchResults() {
//     if (searchResults.isEmpty) {
//       return Center(
//         child: Text(
//           'No results to display',
//           style: TextStyle(color: Colors.white),
//         ),
//       );
//     } else {
//       return ListView.builder(
//         itemCount: searchResults.length,
//         itemBuilder: (context, index) {
//           var song = searchResults[index];
//           SongModel songModel = SongModel.fromJson(song);

//           return SongItemCard(
//             userId: FirebaseAuth.instance.currentUser!.uid,
//             playlistId: '', // Pass an empty string or any placeholder value
//             playlistName: '',
//             song: songModel,
//             onOptionsPressed: () {
//               // Handle options for SearchSongs
//               // e.g., show add to playlist and add to liked songs
//               _showOptionsDialog(songModel);
//             },
//           );
//         },
//       );
//     }
//   }

//   void _addToLikedSongs(SongModel songModel) {
//     // Fetch and store the current user ID
//     User user = FirebaseAuth.instance.currentUser!;
//     String userId = user.uid;

//     // Implement logic to add to liked songs here
//     // You can use the songModel and the user's ID to update Firestore
//     // ...
//     FirebaseDb().addOrUpdateLikedSong(userId, songModel);
//   }

//   Future<void> _searchSongs() async {
//     String searchTerm = _searchController.text.trim();
//     if (searchTerm.isNotEmpty) {
//       try {
//         List<dynamic> results = await _songApi.fetchSearchResults(searchTerm);
//         setState(() {
//           searchResults = results;
//         });

//         // Fetch and store the current user ID
//         User user = FirebaseAuth.instance.currentUser!;
//         String userId = user.uid;

//         // Now you can use userId for performing database operations.
//         // For example, you can pass userId to methods like _addToPlaylist and _addToLikedSongs.
//       } catch (e) {
//         print('Error fetching search results: $e');
//         setState(() {
//           searchResults = [];
//         });
//       }
//     }
//   }

// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mood_tunes/apis/songs_api.dart';
import 'package:mood_tunes/models/savn_search.dart';
import 'package:mood_tunes/screens/home.dart';
import 'package:mood_tunes/screens/navbar.dart';
import 'package:mood_tunes/screens/savn_music.dart';
// import 'package:push/push.dart';

class SearchSongScreen extends StatefulWidget {
  @override
  _SearchSongScreenState createState() => _SearchSongScreenState();
}

class _SearchSongScreenState extends State<SearchSongScreen> {
  SongApi saavnApi = SongApi();
  int _searchIndex = 1;
  int _currentPage = 1;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // final isGranted = await Push.instance.requestPermission();

    _scrollController.addListener(_loadMore);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadMore() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      setState(() {
        _currentPage++;
        print(_currentPage);
        print('\nmm');
        // loading more songs
        _performSearch(page: _currentPage);
      });
    }
  }

  TextEditingController _searchController = TextEditingController();
  List<Song> _searchResults = [];

  void _performSearch({required int page}) async {
    String query = _searchController.text;
    if (query.isNotEmpty) {
      try {
        List<Song> results = await saavnApi.searchSongs(query, page, 10);
        setState(() {
          // appending the results to the search results list
          _searchResults.addAll(results);
        });
      } catch (e) {
        print("Error searching songs: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _searchIndex,
        onTabChange: (index) {
          setState(() {
            _searchIndex = index;
          });
          if (index == 0) {
            Get.offAll(
              HomeScreen(),
              transition: Transition.leftToRightWithFade,
              duration: Duration(milliseconds: 500),
            );
          } else if (index == 1) {
            // Get.to(SearchSongs())
          } else if (index == 2) {
            Get.offAll(
              Get.offAll(DisplayPlaylistScreen()),
            );
            // Get.to()
          } else if (index == 3) {
            // Get.to()
            Get.offAll(
              () => ProfileScreen(),
              transition: Transition.rightToLeft,
              duration: Duration(milliseconds: 500),
            );
          }
        },
      ),
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Search Songs',
                labelStyle: TextStyle(color: Colors.white),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      _searchResults.clear();
                    });
                    _performSearch(page: 1);
                  },
                ),
              ),
              onSubmitted: (String query) {
                setState(() {
                  _searchResults.clear();
                });
                _performSearch(page: 1);
              },
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: _searchResults.isNotEmpty
                  ? _buildSearchResults()
                  : Center(
                      child: Text(
                        'No results found',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return Center(
        child: Text(
          'No results to display',
          style: TextStyle(color: Colors.white),
        ),
      );
    }
    String formatDuration(int seconds) {
      Duration duration = Duration(seconds: seconds);
      String minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
      String secondsStr = (duration.inSeconds % 60).toString().padLeft(2, '0');
      return '$minutes:$secondsStr';
    }

    return ListView.builder(
      itemCount: _searchResults.length,
      controller: _scrollController,
      itemBuilder: (context, index) {
        Song song = _searchResults[index];
        return ListTile(
          title: Text(
            song.name,
            style: TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            song.primaryArtists,
            style: TextStyle(color: Colors.white30),
          ),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              song.images[1].link,
              width: 50.0,
              height: 50.0,
              fit: BoxFit.cover,
            ),
          ),
          trailing: Container(
            width: MediaQuery.of(context).size.width * 0.20,
            child: Row(
              children: [
                Text(
                  formatDuration(int.parse(song.duration)),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(width: 10.0),
                // more options adding here with add to playlist option
                InkWell(
                  child: IconButton(
                    onPressed: () {
                      _showOptionsDialog(song);
                    },
                    icon: Icon(
                      Icons.more_vert_outlined,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
          onTap: () {
            // Add navigation or other action when a song is tapped
            Get.to(MainSongScreen(
              songmodel_savn: song,
              songurl: null,
              songthumb: null,
            ));
            print('Song tapped: ${song.downloadUrls[0].link}');
          },
        );
      },
    );
  }

  void _showOptionsDialog(Song songModel) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Options'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.playlist_add),
                title: Text('Add to Playlist'),
                onTap: () {
                  Navigator.pop(context); // Close the dialog
                  _addToPlaylist(songModel);
                },
              ),
              ListTile(
                leading: Icon(Icons.download),
                title: Text('Download Song'),
                onTap: () {
                  Navigator.pop(context); // Close the dialog
                  showDialog(
                      context: context,
                      builder: (context) => DownloadingDialog(
                            url: songModel.downloadUrls[2].link,
                            fileName: songModel.name,
                          ));
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _downloadSong(url) {
    FlutterDownloader.enqueue(
      url: url,
      savedDir: '/storage/emulated/0/Download',
      showNotification: true,
      openFileFromNotification: true,
    );
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  Future<String?> _showCreatePlaylistDialog() async {
    TextEditingController playlistNameController = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Create New Playlist'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Enter the name for the new playlist:'),
              SizedBox(height: 8.0),
              TextField(
                controller: playlistNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Playlist Name',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.pop(context, playlistNameController.text),
              child: Text('Create'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addToPlaylist(Song songModel) async {
    // Fetch and store the current user ID
    User user = FirebaseAuth.instance.currentUser!;
    String userId = user.uid;

    // Fetch existing playlists using the stream
    List<Map<String, String>> playlists =
        await FirebaseDb().getPlaylistsStream(userId).first;

    // Show a dialog to choose or create a playlist
    String? chosenPlaylistId = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add to Playlist'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Choose a playlist or create a new one:'),
              SizedBox(height: 16.0),
              ...playlists.map((playlist) {
                return ListTile(
                  title: Text(playlist['name'] ?? ''),
                  onTap: () {
                    Navigator.pop(
                        context, playlist['id']); // Return chosen playlist ID
                  },
                );
              }).toList(),
              SizedBox(height: 16.0),
              ListTile(
                title: Text('Create New Playlist'),
                onTap: () {
                  Navigator.pop(
                      context, ''); // Return an empty string for a new playlist
                },
              ),
            ],
          ),
        );
      },
    );

    if (chosenPlaylistId != null && chosenPlaylistId.isNotEmpty) {
      // Add to the chosen playlist

      FirebaseDb().addToPlaylist(userId, chosenPlaylistId, songModel);
      _showSnackbar(
          'Added to playlist: ${playlists.firstWhere((p) => p['id'] == chosenPlaylistId)['name']}');
      // _sendPushNotification(
      //   playlists.firstWhere((p) => p['id'] == chosenPlaylistId)['name'],
      //   songModel.name,
      // );
    } else {
      // Handle creating a new playlist (prompt the user for a new playlist name)
      String? newPlaylistName = await _showCreatePlaylistDialog();
      if (newPlaylistName != null && newPlaylistName.isNotEmpty) {
        String newPlaylistId =
            await FirebaseDb().createPlaylist(userId, newPlaylistName);
        FirebaseDb().addToPlaylist(userId, newPlaylistId, songModel);
        _showSnackbar('Added to new playlist: $newPlaylistName');
        // _sendPushNotification(
        //   newPlaylistName!,
        //   songModel.name,
        // );
      }
    }
  }
}
