// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class FirebaseDB {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // User Authentication

//   Future<User?> signInWithEmailAndPassword(
//       String email, String password) async {
//     try {
//       UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       return userCredential.user;
//     } catch (e) {
//       print('Error signing in: $e');
//       return null;
//     }
//   }

//   Future<void> updateLikedSongsPlaylist(
//       String userId, List<Map<String, dynamic>> likedSongs) async {
//     try {
//       await _firestore.collection('likedSongs').doc(userId).set({
//         'songs': likedSongs,
//         'updatedAt': FieldValue.serverTimestamp(),
//       });
//     } catch (e) {
//       print('Error updating liked songs playlist: $e');
//     }
//   }

//   Future<List<Map<String, dynamic>>> getAllLikedSongs(String userId) async {
//     try {
//       DocumentSnapshot docSnapshot =
//           await _firestore.collection('likedSongs').doc(userId).get();
//       if (docSnapshot.exists) {
//         return List<Map<String, dynamic>>.from(docSnapshot['songs']);
//       } else {
//         return [];
//       }
//     } catch (e) {
//       print('Error fetching liked songs: $e');
//       return [];
//     }
//   }

//   Future<User?> signUpWithEmailAndPassword(
//       String email, String password) async {
//     try {
//       UserCredential userCredential =
//           await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       return userCredential.user;
//     } catch (e) {
//       print('Error signing up: $e');
//       return null;
//     }
//   }

//   Future<void> signOut() async {
//     await _auth.signOut();
//   }

//   // Firestore Operations

//   Future<List<Map<String, dynamic>>> getAllSongs() async {
//     try {
//       QuerySnapshot querySnapshot = await _firestore.collection('songs').get();
//       return querySnapshot.docs
//           .map((doc) => doc.data() as Map<String, dynamic>)
//           .toList();
//     } catch (e) {
//       print('Error fetching songs: $e');
//       return [];
//     }
//   }

//   Future<void> createPlaylist(
//       String userId, String playlistName, List<String> songIds) async {
//     try {
//       CollectionReference playlistsRef = _firestore
//           .collection('userPlaylists')
//           .doc(userId)
//           .collection('playlists');
//       await playlistsRef.add({
//         'name': playlistName,
//         'songs': songIds,
//         'createdAt': FieldValue.serverTimestamp(),
//       });
//     } catch (e) {
//       print('Error creating playlist: $e');
//     }
//   }
// }
