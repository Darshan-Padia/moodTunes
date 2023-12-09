// song_list.dart
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mood_tunes/firebase_db.dart';
import 'package:mood_tunes/models/song_model.dart';
import 'package:mood_tunes/screens/song_main_screen.dart';
import 'package:mood_tunes/user_controller.dart';

class MySongsList extends StatelessWidget {
  const MySongsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // late List<Song> songs;
    Future<void> setHighrefreshrate() async {
      await FlutterDisplayMode.setHighRefreshRate();
    }

    // calling the setHighrefreshrate function when the screen is built
    setHighrefreshrate();
    // initialisng songs only once when the screen is built
    // songs = [
    //   Song(id: 1, title: 'Song 1', artist: 'Artist 1', duration: '3:45'),
    //   Song(id: 2, title: 'Song 2', artist: 'Artist 2', duration: '4:20'),
    //   Song(id: 2, title: 'Song 2', artist: 'Artist 2', duration: '4:20'),
    //   Song(id: 2, title: 'Song 2', artist: 'Artist 2', duration: '4:20'),
    //   Song(id: 2, title: 'Song 2', artist: 'Artist 2', duration: '4:20'),
    //   Song(id: 2, title: 'Song 2', artist: 'Artist 2', duration: '4:20'),
    //   Song(id: 2, title: 'Song 2', artist: 'Artist 2', duration: '4:20'),
    //   Song(id: 2, title: 'Song 2', artist: 'Artist 2', duration: '4:20'),
    //   Song(id: 2, title: 'Song 2', artist: 'Artist 2', duration: '4:20'),
    //   Song(id: 2, title: 'Song 2', artist: 'Artist 2', duration: '4:20'),
    //   Song(id: 2, title: 'Song 2', artist: 'Artist 2', duration: '4:20'),
    //   Song(id: 2, title: 'Song 2', artist: 'Artist 2', duration: '4:20'),
    //   Song(id: 2, title: 'Song 2', artist: 'Artist 2', duration: '4:20'),
    //   Song(id: 2, title: 'Song 2', artist: 'Artist 2', duration: '4:20'),
    //   Song(id: 2, title: 'Song 2', artist: 'Artist 2', duration: '4:20'),
    //   Song(id: 2, title: 'Song 2', artist: 'Artist 2', duration: '4:20'),

    //   // Add more songs as needed
    // ];

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
        ],
        title: const Text("Beats"),
      ),
      body: SafeArea(
        child: Column(
            //   children: [
            //     // Album cover or photo
            //     Container(
            //       height: MediaQuery.of(context).size.width /
            //           1.5, // Adjust the height as needed
            //       width: double.infinity,
            //       decoration: BoxDecoration(
            //         image: DecorationImage(
            //           image: NetworkImage(
            //             // Replace this with the URL of your album cover or photo
            //             'https://lensvid.com/wp-content/uploads/2016/01/How-to-Add-Film-Effects-to-Any-Photo.jpeg',
            //           ),
            //           fit: BoxFit.cover,
            //         ),
            //       ),
            //       child: BackdropFilter(
            //         filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            //         child: Container(
            //           color:
            //               Colors.black.withOpacity(0.5), // Adjust opacity as needed
            //         ),
            //       ),
            //     ),
            //     // List of songs
            //     Expanded(
            //       child: ListView.builder(
            //         itemCount: songs.length,
            //         itemBuilder: (context, index) {
            //           return ListTile(
            //             onTap: () {
            //               // Navigate to the song screen when the user taps on a song
            //               Get.to(SongMainScreen());
            //             },
            //             leading: CircleAvatar(
            //               child: Text(songs[index].id.toString()),
            //             ),
            //             title: Text(
            //               songs[index].title,
            //               style: TextStyle(color: Colors.white),
            //             ),
            //             subtitle: Text(songs[index].artist),
            //             trailing: Row(
            //               mainAxisSize: MainAxisSize.min,
            //               children: [
            //                 Text(
            //                   songs[index].duration,
            //                   style: TextStyle(color: Colors.white),
            //                 ),
            //                 SizedBox(width: 10),
            //                 Obx(
            //                   () => IconButton(
            //                     onPressed: () {
            //                       songs[index].isLiked.toggle();
            //                     },
            //                     icon: Icon(
            //                       songs[index].isLiked.value
            //                           ? Icons.favorite
            //                           : Icons.favorite_border,
            //                       color: Colors.white,
            //                     ),
            //                   ),
            //                 ),
            //                 IconButton(
            //                   onPressed: () {},
            //                   icon: Icon(
            //                     // showing 3 horizontal dots
            //                     Icons.more_horiz,
            //                     color: Colors.white,
            //                   ),
            //                 )
            //               ],
            //             ),
            //           );
            //         },
            //       ),
            //     ),
            //   ],
            ),
      ),
    );
  }
}
