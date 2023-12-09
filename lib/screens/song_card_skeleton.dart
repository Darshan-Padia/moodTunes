import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mood_tunes/firebase_firestore_db.dart';
import 'package:mood_tunes/models/song_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SongCardSkel extends StatelessWidget {
  final SongModel song;
  final String albumPhoto;
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  SharedPreferences? prefs;
  SongCardSkel({required this.song, required this.albumPhoto});
// load the shared preferences
  void loadSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    loadSharedPreferences();
    return SafeArea(
      child: Card(
        color: Colors.blueGrey[900]!.withOpacity(0.01),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  InkWell(
                    enableFeedback: true,
                    borderRadius: BorderRadius.circular(4),
                    splashColor: Colors.amber,
                    onTap: () {
                      // Handle the main tap
                      // Get.toNamed('/song', arguments: song);
                    },
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          height: 50,
                          width: 50,
                          child: InkWell(
                            enableFeedback: true,
                            onDoubleTap: () {
                              song.isLiked.value = !song.isLiked.value;
                            },
                            child: Image.network(
                              song.thumbnails.isNotEmpty
                                  ? song.thumbnails[0]['url']
                                  : albumPhoto,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        song.title,
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        song.artists.isNotEmpty
                            ? song.artists[0]['name'] as String
                            : 'Unknown Artist' as String,
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.white38,
                        ),
                      ),
                      trailing: Container(
                        width: MediaQuery.of(context).size.width * 0.20,
                        child: Row(
                          children: [
                            Obx(() => InkWell(
                                  onTap: () async {
                                    await handleLikeStatus();
                                  },
                                  child: Icon(
                                    // prefs?.getBool(song.videoId) == true
                                    //     ? Icons.favorite
                                    //     : Icons.favorite_border,
                                    // color: Colors.white,
                                    song.isLiked.value
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: Colors.white,
                                  ),
                                )),
                            SizedBox(width: 10),
                            PopupMenuButton(
                              color: Colors.black,
                              enableFeedback: true,
                              icon: Icon(
                                Icons.more_vert,
                                color: Colors.white,
                              ),
                              shape: ContinuousRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 1,
                                  child: Row(
                                    children: [
                                      Icon(Icons.add,
                                          color: Color.fromARGB(
                                              255, 192, 145, 149)),
                                      SizedBox(width: 10),
                                      Text(
                                        'Add to Playlist',
                                        style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 2,
                                  child: Row(
                                    children: [
                                      Icon(Icons.download,
                                          color: Color.fromARGB(
                                              255, 192, 145, 149)),
                                      SizedBox(width: 10),
                                      Text(
                                        "Download",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 3,
                                  child: Row(
                                    children: [
                                      Icon(Icons.share,
                                          color: Color.fromARGB(
                                              255, 192, 145, 149)),
                                      SizedBox(width: 10),
                                      Text(
                                        "Share",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                              onSelected: (value) {
                                // Handle popup menu item selection
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> handleLikeStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey(song.videoId)) {
      prefs.remove(song.videoId);
      await FirebaseDb().removeLikedSong(userId, song.videoId);
      await FirebaseDb()
          .updateIsLiked(userId, 'likedSongs', song.videoId, false);
      await FirebaseDb().removeLikedSongVideoIds(userId, song.videoId);
      song.isLiked.value = !song.isLiked.value;
    } else {
      prefs.setBool(song.videoId, true);
      await FirebaseDb().addOrUpdateLikedSong(userId, song);
      await FirebaseDb()
          .updateIsLiked(userId, 'likedSongs', song.videoId, true);
      await FirebaseDb().addOrUpdateLikedSongVideoIds(userId, song);
      song.isLiked.value = !song.isLiked.value;
    }
  }
}
