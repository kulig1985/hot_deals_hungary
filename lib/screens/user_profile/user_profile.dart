import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hot_deals_hungary/auth/auth_gate.dart';
import 'package:hot_deals_hungary/controllers/user_controller.dart';
import 'package:hot_deals_hungary/screens/components/bottom_bar.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:hot_deals_hungary/screens/components/custom_app_bar.dart';
import 'package:hot_deals_hungary/screens/components/header_widget.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final UserDataController _userDataController = Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signOut() async {
    await _auth.signOut().then((value) => Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => AuthGate()),
        ModalRoute.withName("/auth")));
  }

  Widget showProfilScreen() {
    return ProfileScreen(
      avatarSize: 50,
      actions: [
        SignedOutAction((context) {
          Navigator.pushReplacementNamed(context, '/auth');
        }),
      ],

      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 5),
              child: Row(
                children: [
                  SelectableText(
                    "User ID: ${_userDataController.user.uid}",
                    style: const TextStyle(fontSize: 15),
                    onTap: () {
                      Clipboard.setData(
                          ClipboardData(text: _userDataController.user.uid));
                      Get.snackbar("Másolás!", "User ID lemásolva!",
                          snackPosition: SnackPosition.TOP,
                          isDismissible: true,
                          duration: const Duration(seconds: 1));
                    },
                  ),
                  Material(
                    borderRadius: BorderRadius.circular(40),
                    color: Colors.white,
                    child: InkWell(
                      onTap: () {
                        Clipboard.setData(
                            ClipboardData(text: _userDataController.user.uid));
                        Get.snackbar("Másolás!", "User ID lemásolva!",
                            snackPosition: SnackPosition.TOP,
                            isDismissible: true,
                            duration: const Duration(seconds: 1));
                      },
                      child: const Icon(
                        Icons.copy,
                        size: 17,
                      ),
                    ),
                  )
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 12, top: 15),
              child: Icon(Icons.person),
            ),
          ],
        )
      ],
      // ...
    );
  }

  String checkUserNameExist(User user) {
    if (user.displayName == "" || user.displayName == null) {
      return user.email!;
    } else {
      return user.displayName!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: CustomAppBar(
            titleName: 'Profil',
            backButtonchooser: false,
          ),
        ),
        body: SafeArea(
            child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          color: const Color.fromRGBO(43, 47, 58, 1),
          child: Stack(children: [
            Column(
              children: [
                /*HeaderWidget(
              titleName: 'Profil',
              backButtonchooser: false,
            ),*/
                const Divider(
                  color: Colors.black12,
                ),
                Center(
                  child: Text(
                    "Süssön rád a 🌞 kedves ${checkUserNameExist(_userDataController.user)} a következő azonosítóval tudod megosztani a listáidat. Csak rá kell klikkelj és már is kimaásoltad!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 40, left: 20, bottom: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            width: 300,
                            child: SelectableText(
                              "${_userDataController.user.uid}",
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.white),
                              onTap: () {
                                Clipboard.setData(ClipboardData(
                                    text: _userDataController.user.uid));
                                Get.snackbar("Másolás!", "User ID lemásolva!",
                                    snackPosition: SnackPosition.TOP,
                                    isDismissible: true,
                                    duration: const Duration(seconds: 1));
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 40),
                          child: Material(
                            borderRadius: BorderRadius.circular(40),
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Clipboard.setData(ClipboardData(
                                    text: _userDataController.user.uid));
                                Get.snackbar("Másolás!", "User ID lemásolva!",
                                    snackPosition: SnackPosition.TOP,
                                    isDismissible: true,
                                    duration: const Duration(seconds: 1));
                              },
                              child: const Icon(
                                Icons.copy,
                                size: 17,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _signOut();
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text("Kilépés"),
                  style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 15),
                      primary: const Color.fromRGBO(196, 99, 82, 1)),
                )
              ],
            )
          ]),
        )));
  }
}
