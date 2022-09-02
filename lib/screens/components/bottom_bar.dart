import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hot_deals_hungary/controllers/cart_controller.dart';
import 'package:hot_deals_hungary/controllers/mongo_dao_controller.dart';
import 'package:hot_deals_hungary/controllers/user_controller.dart';
import 'package:hot_deals_hungary/screens/action_listener/action_listener_page.dart';
import 'package:hot_deals_hungary/screens/shopping_list/shopping_list_group_view.dart';
import 'package:hot_deals_hungary/screens/user_profile/user_profile.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  CartController cartController = Get.find();
  final MongoDaoController _mongoDaoController = Get.find();
  final UserDataController _userDataController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    //_mongoDaoController.getAllShoppingListByUser(_userDataController.user.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MongoDaoController>(
        builder: (_) => BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 6.0,
            color: Colors.transparent,
            elevation: 9.0,
            clipBehavior: Clip.antiAlias,
            child: Container(
                height: 50.0,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0)),
                    color: Colors.white),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          height: 50.0,
                          width: MediaQuery.of(context).size.width / 2 - 40.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Material(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                                child: InkWell(
                                    onTap: () {
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ActionListenerPage()),
                                          ModalRoute.withName("/home"));
                                    },
                                    child: const Icon(
                                      Icons.home,
                                      color: Color(0xFF676E79),
                                      size: 30,
                                    )),
                              ),
                              Material(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const UserProfileScreen()),
                                        ModalRoute.withName("/user_profile"));
                                  },
                                  child: const Icon(Icons.person_outline,
                                      color: Color(0xFF676E79), size: 30),
                                ),
                              )
                            ],
                          )),
                      SizedBox(
                          height: 50.0,
                          width: MediaQuery.of(context).size.width / 2 - 40.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Material(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                                child: InkWell(
                                    onTap: (() {
                                      showModalBottomSheet<void>(
                                          isDismissible: true,
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Column(
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10),
                                                  child: Text(
                                                      "Válaszd ki a bevásárló listát!",
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        color: Color.fromARGB(
                                                            255, 63, 63, 63),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      )),
                                                ),
                                                SizedBox(
                                                  height: 400,
                                                  child: GetBuilder<
                                                      MongoDaoController>(
                                                    builder: (_) =>
                                                        ListView.builder(
                                                            itemCount:
                                                                _mongoDaoController
                                                                    .shoppingListEntityListLength,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              return CheckboxListTile(
                                                                title: Text(_mongoDaoController
                                                                    .shoppingListEntityList[
                                                                        index]
                                                                    .listName),
                                                                value: _mongoDaoController
                                                                        .selectedListMap[
                                                                    _mongoDaoController
                                                                        .shoppingListEntityList[
                                                                            index]
                                                                        .id
                                                                        .oid],
                                                                onChanged:
                                                                    (value) {
                                                                  setState(() {
                                                                    _mongoDaoController.selectShoppingList(
                                                                        _mongoDaoController
                                                                            .shoppingListEntityList[index]
                                                                            .id
                                                                            .oid,
                                                                        value!);
                                                                    print(
                                                                        'checked:${_mongoDaoController.selectedListMap}');
                                                                    _mongoDaoController
                                                                        .update();
                                                                    Navigator.pop(
                                                                        context);
                                                                  });
                                                                },
                                                                secondary:
                                                                    const Icon(
                                                                  Icons
                                                                      .list_alt,
                                                                ),
                                                              );
                                                            }),
                                                  ),
                                                ),
                                                TextButton.icon(
                                                    label: const Text(
                                                        'Bevásárló lista létrehozása!'),
                                                    icon: const Icon(
                                                      Icons.list_alt_sharp,
                                                    ),
                                                    onPressed: () {
                                                      _mongoDaoController
                                                          .createNewShoppingList(
                                                              _userDataController
                                                                  .user);
                                                      Get.back();
                                                    })
                                              ],
                                            );
                                          });
                                    }),
                                    child: const Icon(
                                      Icons.list,
                                      color: Color(0xFF676E79),
                                      size: 30,
                                    )),
                              ),
                              Badge(
                                  elevation: 1,
                                  position: BadgePosition.topEnd(),
                                  badgeContent: Text(_mongoDaoController
                                      .choosenShoppingListLength
                                      .toString()),
                                  child: Material(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                    child: InkWell(
                                      radius: 200,
                                      onTap: () {
                                        if (_mongoDaoController
                                                .rxShoppingList.value.id.oid !=
                                            'na') {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const ShoppingListGroupView()));
                                        } else {
                                          Get.defaultDialog(
                                              title: "Nincs bevásárló listád!",
                                              middleText:
                                                  "Válassz ki, vagy hozz létre egyet!",
                                              backgroundColor:
                                                  const Color.fromRGBO(
                                                      65, 37, 37, 0.9),
                                              titleStyle: const TextStyle(
                                                  color: Colors.white),
                                              middleTextStyle: const TextStyle(
                                                  color: Colors.white),
                                              radius: 12,
                                              content: Column(
                                                children: [
                                                  _mongoDaoController
                                                      .shoppingListExistCheck(
                                                          _userDataController
                                                              .user)
                                                ],
                                              ));
                                        }
                                      },
                                      child: const Icon(Icons.shopping_basket,
                                          color: Color(0xFF676E79), size: 30),
                                    ),
                                  ))
                            ],
                          )),
                    ]))));
  }
}
