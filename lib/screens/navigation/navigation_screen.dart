import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hot_deals_hungary/screens/action_listener/action_listener_page.dart';
import 'package:hot_deals_hungary/screens/shopping_list/all_shopping_list_page.dart';
import 'package:hot_deals_hungary/screens/shopping_list/shopping_list_group_view.dart';
import 'package:hot_deals_hungary/screens/user_profile/user_profile.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({Key? key}) : super(key: key);

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  List pages = [
    AllShoppingListPage(),
    ActionListenerPage(),
    //UserProfileScreen(),

    //ShoppingListGroupView()
  ];
  int currentIndex = 0;
  void onTap(int index) {
    setState(() {
      print('ontap:$index');
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color.fromRGBO(113, 68, 51, 0.1),
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          onTap: onTap,
          selectedItemColor: Color.fromRGBO(196, 99, 82, 1),
          unselectedItemColor: Color.fromARGB(157, 112, 112, 112),
          showSelectedLabels: true,
          showUnselectedLabels: true,
          elevation: 0,
          items: const [
            /*BottomNavigationBarItem(
                label: "Profil",
                icon: Icon(
                  Icons.person,
                )),*/
            BottomNavigationBarItem(label: "Listáim", icon: Icon(Icons.list)),
            BottomNavigationBarItem(
                label: "Akció figyelő", icon: Icon(Icons.search)),
            /*BottomNavigationBarItem(
                label: "Kosár", icon: Icon(Icons.shopping_basket)),*/
          ]),
    );
  }
}
