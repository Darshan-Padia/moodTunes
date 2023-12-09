// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

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
//   List<dynamic> albums = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }

//   Future<void> fetchData() async {
//     Uri uri = Uri.parse('https://saavn.me/modules?language=hindi,english');
//     final response = await http.get(uri);

//     if (response.statusCode == 200) {
//       final Map<String, dynamic> data = json.decode(response.body);
//       setState(() {
//         albums = data['data']['albums'];
//       });
//     } else {
//       throw Exception('Failed to load data');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Saavn Albums'),
//       ),
//       body: ListView.builder(
//         itemCount: albums.length,
//         itemBuilder: (context, index) {
//           return Card(
//             elevation: 3,
//             child: Column(
//               children: [
//                 Container(
//                   height: 150,
//                   width: double.infinity,
//                   child: Image.network(
//                     albums[index]['image'][2]
//                         ['link'], // Assuming the first link is the thumbnail
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 ListTile(
//                   title: Text(albums[index]['name']),
//                   subtitle: Text(albums[index]['language']),
//                   onTap: () {
//                     // Handle item tap if needed
//                   },
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Demo',
      home: VideoPlayerScreen(
        videoUrl:
            'https://aac.saavncdn.com/679/b0b7a063d3efddf3a771a0dc91b30d69_48.mp4',
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;

  VideoPlayerScreen({required this.videoUrl});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        // hiding the video and only play audio

        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
      ),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : Container(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
