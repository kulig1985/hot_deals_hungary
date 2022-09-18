import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:get/get.dart';
import 'package:hot_deals_hungary/controllers/main_dao_controller.dart';
import 'package:hot_deals_hungary/controllers/mongo_dao_controller.dart';
import 'package:hot_deals_hungary/controllers/user_controller.dart';
import 'package:hot_deals_hungary/screens/action_listener/action_listener_page.dart';
import 'package:hot_deals_hungary/screens/navigation/navigation_persistent_screen.dart';
import 'package:hot_deals_hungary/screens/navigation/navigation_screen.dart';

import '../screens/shopping_list/list_of_shopping_list.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SignInScreen(
                providerConfigs: const [
                  EmailProviderConfiguration(),
                  GoogleProviderConfiguration(
                      clientId:
                          '1028524662787-4rv061tnikes9eovpvjf0m0no2qmpecv.apps.googleusercontent.com'),
                  FacebookProviderConfiguration(clientId: '3249979211885631')
                ],
                subtitleBuilder: (context, _) {
                  return Container(color: const Color.fromRGBO(37, 37, 37, 1));
                },
                headerBuilder: (context, constraints, _) {
                  return Container(
                    margin: EdgeInsets.only(top: 30),
                    child: const Image(
                      image: AssetImage('assets/images/shopping_list_logo.png'),
                      width: 80,
                      height: 80,
                    ),
                  );
                });
          } else {
            UserDataController _dataController =
                Get.put(UserDataController(user: snapshot.data!));
            MongoDaoController _mongoDaoController =
                Get.put(MongoDaoController());
            MainDaoController _mainDaoController = Get.put(MainDaoController());
            //return const ActionListenerPage();
            return const ListOfShoppingListScreen();
            //return const NavigationPage();
          }
        });
  }
}
