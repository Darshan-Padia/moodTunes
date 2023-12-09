import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mood_tunes/apis/songs_api.dart';
import 'package:mood_tunes/models/cards.dart';
import 'package:mood_tunes/models/drawer_items.dart';
import 'package:mood_tunes/models/homepage_savn.dart';
import 'package:mood_tunes/models/savn_search.dart';
import 'package:mood_tunes/models/song_model.dart';
import 'package:mood_tunes/screens/album_screen.dart';
import 'package:mood_tunes/screens/display_playlist.dart';
import 'package:mood_tunes/screens/mood_playlist_screen.dart';
import 'package:mood_tunes/screens/moods_screen.dart';
import 'package:mood_tunes/screens/navbar.dart';
import 'package:mood_tunes/screens/profile_screen.dart';
import 'package:mood_tunes/screens/search_screen.dart';
import 'package:mood_tunes/screens/sng_dtail.dart';
import 'package:mood_tunes/screens/song_list.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late Future<SaavnApiResponse> futureSaavnData;

  SongApi songApi = SongApi();

  // getting the data from the api
  List<SaavnAlbum> albumss = [];
  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.offAllNamed('/login');
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    futureSaavnData = SongApi().fetchSaavnData();
    SongApi().fetchSaavnData().then((value) => {
          setState(() {
            albumss = value.data.albums;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return albumss.isEmpty
        ? Center(
            child: CircularProgressIndicator(),
          )
        : SafeArea(
            child: Scaffold(
              bottomNavigationBar: CustomBottomNavBar(
                  selectedIndex: _selectedIndex,
                  onTabChange: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                    if (index == 0) {
                      // Get.to(HomeScreen());
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
                      Get.offAll(
                        () => ProfileScreen(),
                        transition: Transition.rightToLeft,
                        duration: Duration(milliseconds: 500),
                      );
                    }
                  }),
              appBar: AppBar(
                title: Text(
                  "MoodTunes",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      Icons.exit_to_app,
                      color: Colors.white,
                    ),
                    onPressed: _logout,
                  ),
                ],
                backgroundColor: Theme.of(context).primaryColor,
                elevation: 0, // Remove app bar shadow
              ),
              drawer: Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    DrawerHeader(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Text(
                        // Adding user's name or username dynamically from auth
                        'Darshan',

                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    DrawerItem(
                      icon: Icons.library_music,
                      title: 'Playlists',
                      onTap: () {
                        // Navigate to playlists screen or perform an action
                        // Example: Get.toNamed('/playlists');
                        Get.to(DisplayPlaylistScreen());
                      },
                    ),
                    DrawerItem(
                      icon: Icons.settings,
                      title: 'Settings',
                      onTap: () {
                        // Navigate to settings screen or perform an action
                        // Example: Get.toNamed('/settings');
                      },
                    ),
                    DrawerItem(
                      icon: Icons.person,
                      title: 'Profile',
                      onTap: () {
                        // Navigate to profile screen or perform an action
                        // Example: Get.toNamed('/profile');
                      },
                    ),

                    // Add yourself

                    DrawerItem(
                      icon: Icons.search,
                      title: 'search',
                      onTap: () {
                        Get.to(SearchSongScreen());
                      },
                    ),
                    DrawerItem(
                      icon: Icons.album_outlined,
                      title: 'album',
                      onTap: () {
                        Get.to(SearchAlbums());
                      },
                    ),
                    DrawerItem(
                      icon: Icons.mood,
                      title: 'moods',
                      onTap: () {
                        Get.to(MoodScreen());
                      },
                    ),
                  ],
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height / 3,
                        child: CarouselSlider(
                          items: List.generate(
                            5, // Replace with the actual number of carousel items
                            (index) =>
                                // colored sizzed box
                                Container(
                              // add  images to the carousel
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    albumss[index + 6].images[2].link,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          // ),
                          options: CarouselOptions(
                            height: MediaQuery.of(context).size.height / 3,
                            aspectRatio: 9 / 16,
                            viewportFraction: 0.8,
                            initialPage: 0,
                            enableInfiniteScroll: true,
                            reverse: false,
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 3),
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 800),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enlargeCenterPage: true,
                            scrollDirection: Axis.horizontal,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Latest",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 200,
                        child:
                            //  ListView.builder(
                            //   scrollDirection: Axis.horizontal,
                            //   itemCount: albumss
                            //       .length, // Change this to the actual number of cards
                            //   itemBuilder: (context, index) {
                            //     return GlassyCard(
                            //       // savnresp: takes SaavnApiResponse,
                            //       index: index,
                            //     ); // Create a GlassyCard widget
                            //   },
                            // ),
                            Center(
                          child: FutureBuilder<SaavnApiResponse>(
                            future: futureSaavnData,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                List<SaavnAlbum> first10Albums = snapshot
                                    .data!.data.albums
                                    .take(10)
                                    .toList();

                                return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: first10Albums.length,
                                  itemBuilder: (context, index) {
                                    // return ListTile(
                                    //   title: Text(first10Albums[index].name),
                                    //   onTap: () {},
                                    // );
                                    OnTap:
                                    () {
                                      SongApi().fetchSaavnAlbumDetails(
                                          first10Albums[index].id);
                                    };
                                    return GlassyCard(
                                        album: first10Albums[index]);
                                  },
                                );
                              }
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 200,
                        child:
                            //  ListView.builder(
                            //   scrollDirection: Axis.horizontal,
                            //   itemCount: albumss
                            //       .length, // Change this to the actual number of cards
                            //   itemBuilder: (context, index) {
                            //     return GlassyCard(
                            //       // savnresp: takes SaavnApiResponse,
                            //       index: index,
                            //     ); // Create a GlassyCard widget
                            //   },
                            // ),
                            Center(
                          child: FutureBuilder<SaavnApiResponse>(
                            future: futureSaavnData,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                List<SaavnAlbum> first10Albums = snapshot
                                    .data!.data.albums
                                    .take(50)
                                    .toList();

                                return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 8,
                                  itemBuilder: (context, index) {
                                    // return ListTile(
                                    //   title: Text(first10Albums[index].name),
                                    //   onTap: () {},
                                    // );
                                    OnTap:
                                    return GlassyCard(
                                        album: first10Albums[index + 10]);
                                  },
                                );
                              }
                            },
                          ),
                        ),
                      ),
                      // Text(
                      //   "Latest",
                      //   style: TextStyle(
                      //     color: Colors.white,
                      //     fontSize: 24,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      // Container(
                      //   height: 200,
                      //   child: ListView.builder(
                      //     scrollDirection: Axis.horizontal,
                      //     itemCount: 5, // Change this to the actual number of cards
                      //     itemBuilder: (context, index) {
                      //       return GlassyCard(); // Create a GlassyCard widget
                      //     },
                      //   ),
                      // ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  _showEmojiSelection(context);
                },
                child: Icon(Icons.insert_emoticon),
              ),
            ),
          );
  }

  void _showEmojiSelection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.grey[900],
          height: MediaQuery.of(context).size.height * 0.25,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Select an Mood',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildEmojiButton('😢', 'Sad'),
                  _buildEmojiButton('😍', 'Romance'),
                  _buildEmojiButton('😊', 'Feel Good'),
                  _buildEmojiButton('😌', 'Chill'),
                  _buildEmojiButton('💪', 'Energy Boosters'),
                  // add more moods
                  _buildEmojiButton('More', '')

                  // Add more emoji buttons as needed
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmojiButton(String emoji, String category) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(Get.overlayContext!).pop(); // Close the bottom sheet
        if (category != '') {
          Get.to(() => MoodPlaylistScreen(moodTitle: category));
        } else {
          Get.to(() => MoodScreen());
        }
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.grey[800], // Dark background color
      ),
      child: Column(
        children: [
          Text(
            emoji,
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          SizedBox(height: 5),
          Text(
            category,
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
