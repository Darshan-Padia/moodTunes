import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:mood_tunes/models/savn_search.dart';
import 'package:mood_tunes/models/song_model.dart';

class FirebaseDb {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection names
  static const String usersCollection = 'users';
  static const String songsCollection = 'songs';
  static const String playlistsCollection = 'playlists';

  Future<void> addOrUpdateLikedSong(
    String userId,
    SongModel song,
  ) async {
    try {
      await _firestore
          .collection(usersCollection)
          .doc(userId)
          .collection('likedSongs')
          .doc(song.videoId)
          .set({
        'videoId': song.videoId,
        'title': song.title,
        'album': song.album,

        'artists': song.artists,
        'thumbnails': song.thumbnails,
        'duration': song.duration,
        'isLiked': true, // Add this line to set the default value
      });
    } catch (e) {
      print('Error adding or updating liked song: $e');
    }
  }

  // creating a likesongsvideoIds where we will store all the video ids only of liked songs
  Future<void> addOrUpdateLikedSongVideoIds(
    String userId,
    SongModel song,
  ) async {
    try {
      await _firestore
          .collection(usersCollection)
          .doc(userId)
          .collection('likedSongsVideoIds')
          .doc(song.videoId)
          .set({
        'videoId': song.videoId,
      });
    } catch (e) {
      print('Error adding or updating liked song: $e');
    }
  }

  // making a method that returns boolean if the videoId is present in the likesongsvideoIds
  Future<bool> isLikedSongVideoIdPresent(String userId, String songId) async {
    try {
      DocumentSnapshot docSnapshot = await _firestore
          .collection(usersCollection)
          .doc(userId)
          .collection('likedSongsVideoIds')
          .doc(songId)
          .get();
      if (docSnapshot.exists) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error fetching liked songs: $e');
      return false;
    }
  }

  // making a remove function for removing the video id from likesongsvideoIds
  Future<void> removeLikedSongVideoIds(String userId, String songId) async {
    try {
      await _firestore
          .collection(usersCollection)
          .doc(userId)
          .collection('likedSongsVideoIds')
          .doc(songId)
          .delete();
    } catch (e) {
      print('Error removing liked song: $e');
    }
  }

  // getting all the song list from likesongsvideoIds
  Future<List<SongModel>> getAllLikedSongs(String userId) async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('likedSongsVideoIds').get();
      return querySnapshot.docs.map((doc) {
        return SongModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print('Error fetching all songs: $e');
      return [];
    }
  }

  // updating isLiked variable in any playlist with given id
  Future<void> updateIsLiked(
      String userId, String playlistId, String songId, bool isLiked) async {
    try {
      await _firestore
          .collection(usersCollection)
          .doc(userId)
          .collection(playlistsCollection)
          .doc(playlistId)
          .collection('songs')
          .doc(songId)
          .update({
        'isLiked': isLiked,
      });
    } catch (e) {
      print('Error updating isLiked: $e');
    }
  }

  Future<void> removeLikedSong(String userId, String songId) async {
    try {
      await _firestore
          .collection(usersCollection)
          .doc(userId)
          .collection('likedSongs')
          .doc(songId)
          .delete();
    } catch (e) {
      print('Error removing liked song: $e');
    }
  }

  Stream<List<SongModel>> getLikedSongsStream(String userId) {
    return _firestore
        .collection(usersCollection)
        .doc(userId)
        .collection('likedSongs')
        .snapshots()
        .map(
      (querySnapshot) {
        return querySnapshot.docs.map((doc) {
          return SongModel.fromJson(doc.data() as Map<String, dynamic>);
        }).toList();
      },
    );
  }

  // Future<void> createPlaylist(String userId, String playlistName) async {
  //   try {
  //     await _firestore
  //         .collection(usersCollection)
  //         .doc(userId)
  //         .collection(playlistsCollection)
  //         .add({
  //       'name': playlistName,
  //     });
  //   } catch (e) {
  //     print('Error creating playlist: $e');
  //   }
  // }
  Future<String> createPlaylist(String userId, String playlistName) async {
    try {
      DocumentReference playlistReference = await _firestore
          .collection(usersCollection)
          .doc(userId)
          .collection(playlistsCollection)
          .add({
        'name': playlistName,
      });

      return playlistReference.id;
    } catch (e) {
      print('Error creating playlist: $e');
      return '';
    }
  }

  Future<void> addToPlaylist(
      String userId, String playlistId, Song song) async {
    try {
      await _firestore
          .collection(usersCollection)
          .doc(userId)
          .collection(playlistsCollection)
          .doc(playlistId)
          .collection('songs')
          .doc(song.id)
          .set({
        'videoId': song.id,
        'title': song.name,
        'album': song.album.name,

        'artists': song.primaryArtists,
        // 'thumbnails': song.images,
        'duration': song.duration,
        'isLiked': false, // Add this line to set the default value
      });
    } catch (e) {
      print('Error adding to playlist: $e');
    }
  }

  Future<List<String>> getSongIdsInPlaylist(
      String userId, String playlistId) async {
    try {
      final playlistSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('playlists')
          .doc(playlistId)
          .collection('songs')
          .get();

      List<String> songIds = [];

      playlistSnapshot.docs.forEach((doc) {
        songIds.add(doc.id);
      });

      return songIds;
    } catch (e) {
      print('Error getting song IDs in playlist: $e');
      return [];
    }
  }

  Future<void> removeFromPlaylist(
      String userId, String playlistId, String songId) async {
    try {
      await _firestore
          .collection(usersCollection)
          .doc(userId)
          .collection(playlistsCollection)
          .doc(playlistId)
          .collection('songs')
          .doc(songId)
          .delete();
    } catch (e) {
      print('Error removing from playlist: $e');
    }
  }

  Stream<List<Map<String, String>>> getPlaylistsStream(String userId) {
    return _firestore
        .collection(usersCollection)
        .doc(userId)
        .collection(playlistsCollection)
        .snapshots()
        .map(
      (querySnapshot) {
        return querySnapshot.docs.map((doc) {
          return {
            'id': doc.id,
            'name': doc['name']
                as String, // Assuming 'name' is the field for the playlist name
          };
        }).toList();
      },
    );
  }

  Stream<List<SongModel>> getSongsInPlaylistStream(
      String userId, String playlistId) {
    return _firestore
        .collection(usersCollection)
        .doc(userId)
        .collection(playlistsCollection)
        .doc(playlistId)
        .collection('songs')
        .snapshots()
        .map(
      (querySnapshot) {
        // printing what is returned from the query
        print('\n\n\n');
        print(querySnapshot.docs);
        print('\n\n\n');
        // returning id of song separately and the whole song model as well
        return querySnapshot.docs.map((doc) {
          print('\n\n\nddddddddddddddddddddddddddddddddddd');
          print(doc.id); // Change 'id' to 'videoId'
          print('\n\n\n');
          return SongModel.fromJson(doc.data() as Map<String, dynamic>);
        }).toList();
      },
    );
  }

  Future<List<SongModel>> getAllSongs() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection(songsCollection).get();
      return querySnapshot.docs.map((doc) {
        return SongModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print('Error fetching all songs: $e');
      return [];
    }
  }
}
