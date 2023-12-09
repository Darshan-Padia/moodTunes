import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  // title body and payload
  print('Title : ${message.notification?.title}');
  print('Body : ${message.notification?.body}');
  print('Payload : ${message.data}');
}

class FirebaseApi {
  final _fieldMessage = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    await _fieldMessage.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    final token = await _fieldMessage.getToken();
    print(token);

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}
