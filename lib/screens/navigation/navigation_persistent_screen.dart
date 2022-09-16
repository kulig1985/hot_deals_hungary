/*import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hot_deals_hungary/controllers/mongo_dao_controller.dart';
import 'package:hot_deals_hungary/controllers/user_controller.dart';
import 'package:hot_deals_hungary/screens/action_listener/action_listener_page.dart';
import 'package:hot_deals_hungary/screens/shopping_list/all_shopping_list_page.dart';
import 'package:hot_deals_hungary/screens/shopping_list/list_of_shopping_list.dart';
import 'package:hot_deals_hungary/screens/shopping_list/shopping_list_group_view.dart';
import 'package:hot_deals_hungary/screens/user_profile/user_profile.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class NavigationPersistentScreen extends StatefulWidget {
  const NavigationPersistentScreen({Key? key}) : super(key: key);

  @override
  State<NavigationPersistentScreen> createState() =>
      _NavigationPersistentScreenState();
}

class _NavigationPersistentScreenState
    extends State<NavigationPersistentScreen> {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  final MongoDaoController _mongoDaoController = Get.find();
  final UserDataController _userDataController = Get.find();

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.list),
        title: ("Bevásárló listák"),
        activeColorPrimary: Color.fromRGBO(255, 255, 255, 1),
        inactiveColorPrimary: Color.fromARGB(255, 174, 173, 173),
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.person),
        title: ("Profil"),
        activeColorPrimary: Color.fromRGBO(255, 255, 255, 1),
        inactiveColorPrimary: Color.fromARGB(255, 174, 173, 173),
      ),
      /*PersistentBottomNavBarItem(
        icon: const Icon(Icons.shopping_bag_outlined),
        title: ("Bevásáró Listám"),
        activeColorPrimary: Color.fromRGBO(196, 99, 82, 1),
        inactiveColorPrimary: Color.fromARGB(157, 112, 112, 112),
      ),*/
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabView(
        context,
        controller: _controller,
        backgroundColor: const Color.fromRGBO(37, 37, 37, 1),
        screens: const [
          ListOfShoppingListScreen(),
          UserProfileScreen(),

          //ShoppingListGroupView(),
        ],
        items: _navBarsItems(),
        //navBarStyle: NavBarStyle.style1,
        //navBarStyle: NavBarStyle.style9,
        //navBarStyle: NavBarStyle.style7,
        //navBarStyle: NavBarStyle.style10,
        //navBarStyle: NavBarStyle.style12,
        //navBarStyle: NavBarStyle.style13,
        navBarStyle: NavBarStyle.style3,
        //navBarStyle: NavBarStyle.style6,
      ),
    );
  }
}
*/