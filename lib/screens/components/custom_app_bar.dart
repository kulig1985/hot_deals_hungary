import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hot_deals_hungary/controllers/mongo_dao_controller.dart';
import 'package:hot_deals_hungary/controllers/user_controller.dart';
import 'package:hot_deals_hungary/screens/shopping_list/shopping_list_group_view.dart';
import 'package:hot_deals_hungary/screens/user_profile/user_profile.dart';

class CustomAppBar extends StatefulWidget {
  final String titleName;
  final bool backButtonchooser;
  const CustomAppBar(
      {Key? key, required this.titleName, required this.backButtonchooser})
      : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  final MongoDaoController _mongoDaoController = Get.find();
  final UserDataController _userDataController = Get.find();

  Widget conditionalImage() {
    if (widget.backButtonchooser) {
      return IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.pop(context);
        },
      );
    } else {
      return IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const UserProfileScreen()));
          },
          icon: const Icon(Icons.person));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MongoDaoController>(
      builder: (_) => AppBar(
        centerTitle: false,
        titleSpacing: 20.0,
        title: Text(widget.titleName),

        elevation: 3,
        backgroundColor: const Color.fromRGBO(37, 37, 37, 1),
        actions: [
          IconButton(
            iconSize: 20,
            icon: const FaIcon(FontAwesomeIcons.user),
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UserProfileScreen()));
            },
          )
        ],
        /*actions: [
          Container(
            margin: EdgeInsets.only(right: 20),
            child: Badge(
                shape: BadgeShape.circle,
                elevation: 0,
                position: BadgePosition.topStart(),
                badgeContent: Text(
                    _mongoDaoController.choosenShoppingListLength.toString()),
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  size: 25,
                ) /*PopupMenuButton(
                    icon: const Icon(Icons.shopping_bag_outlined),
                    itemBuilder: (context) {
                      return List.generate(
                        _mongoDaoController.shoppingListEntityListLength,
                        (index) => PopupMenuItem(
                          value: _mongoDaoController
                              .shoppingListEntityList[index].id.oid,
                          child: Text(
                            _mongoDaoController
                                .shoppingListEntityList[index].listName,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ),
                      );
                    },
                    onSelected: (value) {
                      print(value);
                      
                      if (value == 0) {
                        print("My account menu is selected.");
                      } else if (value == 1) {
                        print("Settings menu is selected.");
                      } else if (value == 2) {
                        print("Logout menu is selected.");
                      }
                     
                    }) */
                ),
          ),
        ],*/
        //leading: conditionalImage(),
      ),
    );
  }
}
