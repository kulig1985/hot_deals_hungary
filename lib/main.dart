import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hot_deals_hungary/auth/auth_gate.dart';
import 'package:hot_deals_hungary/firebase_options.dart';
import 'package:hot_deals_hungary/screens/action_listener/action_listener_page.dart';
import 'package:hot_deals_hungary/screens/navigation/navigation_persistent_screen.dart';
import 'package:hot_deals_hungary/screens/navigation/navigation_screen.dart';
import 'package:hot_deals_hungary/screens/shopping_list/shopping_list_group_view.dart';
import 'package:hot_deals_hungary/screens/user_profile/user_profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
          textTheme: GoogleFonts.nunitoSansTextTheme(
        Theme.of(context).textTheme,
      )),
      home: const AuthGate(),
      routes: {
        "/home": (_) => NavigationPersistentScreen(),
        "/user_profile": (_) => UserProfileScreen(),
        "/auth": (_) => AuthGate(),
        "/cart": (_) => ShoppingListGroupView(),
      },
    );
  }
}
