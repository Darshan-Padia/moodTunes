// user_controller.dart
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserController extends GetxController {
  Rx<User?> _user = Rx<User?>(null);

  User? get user => _user.value;

  void setUser(User? user) {
    _user.value = user;
  }
}
