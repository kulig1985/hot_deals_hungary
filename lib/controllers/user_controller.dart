// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UserDataController extends GetxController {
  final User user;

  UserDataController({
    required this.user,
  });

  get loggedUser => user;
}
