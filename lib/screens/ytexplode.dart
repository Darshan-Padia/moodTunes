// import 'package:flutter/material.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:youtube_explode_dart/youtube_explode_dart.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   final YoutubeExplode _ytExplode = YoutubeExplode();
//   final AudioPlayer _audioPlayer = AudioPlayer();

//   TextEditingController _controller = TextEditingController();

//   @override
//   void dispose() {
//     _ytExplode.close();
//     _audioPlayer.dispose();
//     super.dispose();
//   }

//   void _playYoutubeAudio(String videoUrl) async {
//     var videoId = 'nnjSgp0-z-Q';
//     var manifest = await _ytExplode.videos.streamsClient.getManifest(videoId);

//     var audioStreamInfo = manifest.audioOnly.sortByBitrate().last;

//     var audioStream = _ytExplode.videos.streamsClient.get(audioStreamInfo);
//     // uri = Uri.parse((await audioStream))
//     Stream<List<int>> stream = await audioStream;
//     Uri uri = Uri.parse(stream.toString());
//     var audioUri = uri;

//     await _audioPlayer.setAudioSource(
//       AudioSource.uri(audioUri),
//     );

//     _audioPlayer.play();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('YouTube Audio Player'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: _controller,
//               decoration: InputDecoration(labelText: 'Enter YouTube Video URL'),
//             ),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: () {
//                 if (_controller.text.isNotEmpty) {
//                   _playYoutubeAudio(_controller.text);
//                 } else {
//                   // Handle case where the URL is empty
//                   print('Please enter a YouTube video URL');
//                 }
//               },
//               child: Text('Play Audio'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
