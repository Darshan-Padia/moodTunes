import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:mood_tunes/models/song_model.dart';
import 'package:mood_tunes/screens/forgot_password.dart';
import 'package:mood_tunes/screens/home.dart';
import 'package:mood_tunes/screens/login.dart';
import 'package:mood_tunes/screens/player_state.dart';
import 'package:mood_tunes/screens/sign_up.dart';
import 'package:mood_tunes/screens/song_list.dart';
import 'package:mood_tunes/user_controller.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'firebase_options.dart';
import 'package:mood_tunes/apis/firebase_noti.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseApi().initNotification();
  await setMaximumRefreshRate(); // Set maximum refresh rate

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PlayerState(),
      child: GetMaterialApp(
        debugShowCheckedModeBanner:
            false, // Set to false to remove the debug banner

        title: 'MoodTunes',
        theme: ThemeData(
          primaryColor: Color(0xff1E2E3D),
          hintColor: Colors.amber[800],
          scaffoldBackgroundColor: Color(0xff0C1C2E),
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color.fromARGB(255, 81, 58, 183),
          ),
          useMaterial3: true,
          textTheme: TextTheme(
            headline3: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.amber[800],
            ),
            bodyText2: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: EdgeInsets.symmetric(vertical: 15),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        initialRoute: '/splash',
        initialBinding: BindingsBuilder(() {
          Get.put(UserController(), permanent: true);
        }),

        getPages: [
          GetPage(name: '/splash', page: () => SplashScreen()),
          GetPage(name: '/home', page: () => HomeScreen()),
          GetPage(name: '/login', page: () => LoginScreen()),
          GetPage(name: '/signup', page: () => SignUpScreen()),
          GetPage(name: '/forgot-password', page: () => ForgotPasswordScreen()),
          GetPage(name: '/songlist', page: () => MySongsList()),
        ],
      ),
    );
  }
}

Future<void> setMaximumRefreshRate() async {
  try {
    List<DisplayMode> modes = await FlutterDisplayMode.supported;
    modes.forEach(print);

    // Sort modes by refresh rate in descending order
    modes.sort((a, b) => b.refreshRate.compareTo(a.refreshRate));

    // Set preferred to the highest available refresh rate
    DisplayMode preferred = modes.first;

    await FlutterDisplayMode.setPreferredMode(preferred);
  } on PlatformException catch (e) {
    print(e);
  }
}
