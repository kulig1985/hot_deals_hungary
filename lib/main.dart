import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hot_deals_hungary/auth/auth_gate.dart';
import 'package:hot_deals_hungary/auth/login_page.dart';
import 'package:hot_deals_hungary/firebase_options.dart';
import 'package:hot_deals_hungary/screens/action_listener/action_listener_page.dart';
import 'package:hot_deals_hungary/screens/navigation/navigation_persistent_screen.dart';
import 'package:hot_deals_hungary/screens/navigation/navigation_screen.dart';
import 'package:hot_deals_hungary/screens/shopping_list/list_of_shopping_list.dart';
import 'package:hot_deals_hungary/screens/shopping_list/shopping_list_group_view.dart';
import 'package:hot_deals_hungary/screens/user_profile/user_profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Gotham'),
      /*theme: ThemeData(
          textTheme: GoogleFonts.nunitoSansTextTheme(
        Theme.of(context).textTheme,
      )),*/
      home: const AuthGate(),
      routes: {
        "/home": (_) => const ListOfShoppingListScreen(),
        "/user_profile": (_) => const UserProfileScreen(),
        "/auth": (_) => const AuthGate(),
        "/cart": (_) => const ShoppingListGroupView(),
      },
      builder: (context, child) {
        final mediaQueryData = MediaQuery.of(context);

        return MediaQuery(
          data: mediaQueryData.copyWith(textScaleFactor: 1.0),
          child: ScrollConfiguration(
            behavior: MyBehavior(),
            child: child!,
          ),
        );
      },
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
