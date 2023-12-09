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
//   String apiUrl =
//       'https://convert2mp3s.com/api/widget?url=https://www.youtube.com/watch?v=pRpeEdMmmQ0';

//   Future<String> fetchData() async {
//     final response = await http.get(Uri.parse(apiUrl));

//     if (response.statusCode == 200) {
//       return response.body;
//     } else {
//       throw Exception('Failed to load data');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('HTTP Request Example'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             fetchData().then((data) {
//               print('Response: $data');
//               // Handle the response data here
//             }).catchError((error) {
//               print('Error: $error');
//               // Handle the error here
//             });
//           },
//           child: Text('Make HTTP Request'),
//         ),
//       ),
//     );
//   }
// }
