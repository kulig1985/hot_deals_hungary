import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hot_deals_hungary/controllers/main_dao_controller.dart';
import 'package:hot_deals_hungary/controllers/mongo_dao_controller.dart';
import 'package:hot_deals_hungary/controllers/user_controller.dart';
import 'package:hot_deals_hungary/models/mongo/shopping_list_complex_model.dart';
import 'package:hot_deals_hungary/models/mongo/shopping_list_entity.dart';
import 'package:hot_deals_hungary/screens/components/custom_app_bar.dart';
import 'package:hot_deals_hungary/screens/shopping_list/shopping_list_group_view.dart';
import 'package:logger/logger.dart';
import 'package:shimmer/shimmer.dart';

class ListOfShoppingListScreen extends StatefulWidget {
  const ListOfShoppingListScreen({Key? key}) : super(key: key);

  @override
  State<ListOfShoppingListScreen> createState() =>
      _ListOfShoppingListScreenState();
}

class _ListOfShoppingListScreenState extends State<ListOfShoppingListScreen> {
  var log = Logger(
    printer: PrettyPrinter(
        methodCount: 1, // number of method calls to be displayed
        errorMethodCount: 8, // number of method calls if stacktrace is provided
        lineLength: 120, // width of the output
        colors: true, // Colorful log messages
        printEmojis: true, // Print an emoji for each log message
        printTime: true // Should each log print contain a timestamp
        ),
  );

  final UserDataController _userDataController = Get.find();
  final MainDaoController _mainDaoController = Get.find();

  List<ShoppingListComplexModel>? shoppingListOnUser;

  bool shimmerEnabled = true;

  Widget _getListWidgets(List<AlloweUidList> lstItens) {
    return Row(children: lstItens.map((i) => Text(i.uid)).toList());
  }

  @override
  void initState() {
    // TODO: implement initState
    /*
    _mainDaoController
        .getAllComplexShoppingListByUser(_userDataController.user)
        .then((value) => shoppingListOnUser = value);
*/
    super.initState();
  }

  Widget isListChoosen(String currentShoppingListOid, String? choosenListId) {
    if (choosenListId != null) {
      if (currentShoppingListOid == choosenListId) {
        return const Text(
          "✓",
          style: TextStyle(fontSize: 20),
        );
      } else {
        return const Text("");
      }
    } else {
      return const Text("");
    }
  }

  Color isListChoosenColor(
      String currentShoppingListOid, String? choosenListId) {
    if (choosenListId != null) {
      if (currentShoppingListOid == choosenListId) {
        return Color.fromRGBO(255, 183, 90, 1);
      } else {
        return Colors.white;
      }
    } else {
      return Colors.white;
    }
  }

  String checkUserNameExist(User user) {
    if (user.displayName == "" || user.displayName == null) {
      return user.email!;
      //
    } else {
      return user.displayName!;
    }
  }

  @override
  Widget build(BuildContext context) {
    var colors = [
      Color.fromRGBO(65, 176, 125, 1),
      Color.fromRGBO(241, 77, 43, 1),
      Color.fromRGBO(255, 183, 90, 1),
      Color.fromRGBO(69, 125, 174, 1),
      Color.fromRGBO(83, 120, 252, 1),
    ];

    var listOptions = ["Megosztás", "Törlés"];

    return Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: CustomAppBar(
            titleName: 'Bevásárló listák',
            backButtonchooser: false,
          ),
        ),
        body: SafeArea(
          child: Container(
            width: double.infinity,
            color: const Color.fromRGBO(43, 47, 58, 1),
            child: Container(
              margin: EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 165,
                          decoration: const BoxDecoration(),
                          margin: const EdgeInsets.only(left: 15, right: 20),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 5, top: 15, bottom: 5, right: 10),
                            child: Text(
                              "Hello ${checkUserNameExist(_userDataController.user)} Próbáld ki és készítsd el az első listád.",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _mainDaoController
                                  .createNewShoppingList(
                                      _userDataController.user)
                                  .then((value) => _mainDaoController.update());
                            });
                          },
                          child: Container(
                            height: 165,
                            decoration: BoxDecoration(
                                color: const Color.fromRGBO(111, 181, 139, 1),
                                borderRadius: BorderRadius.circular(15.0)),
                            margin: const EdgeInsets.only(
                              left: 5,
                              right: 20,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 5, top: 15, bottom: 5, right: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 10, left: 0, bottom: 10),
                                    child: Icon(
                                      Icons.list_alt,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "Új bevásárló lista létrehozása! ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Expanded(
                    child: FutureBuilder(
                        initialData: [],
                        future:
                            _mainDaoController.getAllComplexShoppingListByUser(
                                _userDataController.user,
                                null,
                                true,
                                false,
                                true),
                        builder: (context, snapshot) {
                          log.d(
                              "snapshot.connectionState:${snapshot.connectionState}");
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            log.d("connection state waiting waiting");
                            return GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisExtent: 180.0,
                                      crossAxisSpacing: 0,
                                      mainAxisSpacing: 0),
                              itemCount: 4,
                              itemBuilder: (context, index) {
                                return SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    color: Colors.black,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10, left: 10),
                                          child: Shimmer.fromColors(
                                            direction: ShimmerDirection.ltr,
                                            period: const Duration(
                                                milliseconds: 1000),
                                            baseColor: const Color.fromARGB(
                                                255, 23, 25, 31),
                                            highlightColor:
                                                const Color.fromARGB(
                                                    126, 36, 52, 111),
                                            enabled: true,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.grey[600],
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              width: 160,
                                              height: 10,
                                            ),
                                          ),
                                        ),
                                        Shimmer.fromColors(
                                          direction: ShimmerDirection.ltr,
                                          period: const Duration(
                                              milliseconds: 1000),
                                          baseColor: const Color.fromARGB(
                                              255, 23, 25, 31),
                                          highlightColor: const Color.fromARGB(
                                              126, 36, 52, 111),
                                          enabled: true,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, top: 30),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.grey[600],
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              width: 80,
                                              height: 10,
                                            ),
                                          ),
                                        ),
                                        Shimmer.fromColors(
                                          direction: ShimmerDirection.ltr,
                                          period: const Duration(
                                              milliseconds: 1000),
                                          baseColor: const Color.fromARGB(
                                              255, 23, 25, 31),
                                          highlightColor: const Color.fromARGB(
                                              126, 36, 52, 111),
                                          enabled: true,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, top: 20),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.grey[600],
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              width: 60,
                                              height: 10,
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Shimmer.fromColors(
                                              direction: ShimmerDirection.ltr,
                                              period: const Duration(
                                                  milliseconds: 1000),
                                              baseColor: const Color.fromARGB(
                                                  255, 23, 25, 31),
                                              highlightColor:
                                                  const Color.fromARGB(
                                                      126, 36, 52, 111),
                                              enabled: true,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 20,
                                                    left: 10,
                                                    bottom: 0),
                                                child: Container(
                                                  width: 50,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey[600],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                ),
                                              ),
                                            ),
                                            Shimmer.fromColors(
                                              direction: ShimmerDirection.ltr,
                                              period: const Duration(
                                                  milliseconds: 1000),
                                              baseColor: const Color.fromARGB(
                                                  255, 23, 25, 31),
                                              highlightColor:
                                                  const Color.fromARGB(
                                                      126, 36, 52, 111),
                                              enabled: true,
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 20,
                                                          right: 10,
                                                          bottom: 0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.grey[600],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                    width: 50,
                                                    height: 50,
                                                  )),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            log.d("data: " + snapshot.data.toString());
                            var data = (snapshot.data
                                    as List<ShoppingListComplexModel>)
                                .toList();

                            return Container(
                              margin: const EdgeInsets.only(
                                  left: 15, right: 15, top: 15),
                              child: GetBuilder<MongoDaoController>(
                                builder: (_) => GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          mainAxisExtent: 180.0,
                                          crossAxisSpacing: 0,
                                          mainAxisSpacing: 0),
                                  itemCount: data.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      color:
                                          colors[data[index].imageColorIndex],
                                      child: Container(
                                          child: GestureDetector(
                                        onTap: () {
                                          _mainDaoController.selectShoppingList(
                                              data[index].id.oid);

                                          Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const ShoppingListGroupView()))
                                              .then((value) => setState(
                                                    () {},
                                                  ));
                                        },
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10, left: 10, right: 10),
                                              child: Text(
                                                data[index].listName,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, top: 10),
                                              child: Text(
                                                "${data[index].offerModelList.length} db termék",
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, top: 10),
                                              child: Text(
                                                "${_mainDaoController.countSumOfShoppingList(data[index])} ,-Ft",
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 0,
                                                      left: 10,
                                                      bottom: 0),
                                                  child: FaIcon(
                                                    FontAwesomeIcons.listCheck,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 0,
                                                          right: 10,
                                                          bottom: 0),
                                                  child: PopupMenuButton(
                                                      color:
                                                          const Color.fromRGBO(
                                                              43, 47, 58, 1),
                                                      icon: const FaIcon(
                                                        FontAwesomeIcons
                                                            .ellipsis,
                                                        color: Colors.white,
                                                      ),
                                                      itemBuilder: (context) {
                                                        return List.generate(
                                                          listOptions.length,
                                                          (index) =>
                                                              PopupMenuItem(
                                                            value: listOptions[
                                                                index],
                                                            child: Text(
                                                              listOptions[
                                                                  index],
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                fontFamily:
                                                                    'Roboto',
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      onSelected: (value) {
                                                        print(value);

                                                        if (value == 'Törlés') {
                                                          _mainDaoController
                                                              .removeUserFromShoppingList(
                                                                  _userDataController
                                                                      .user,
                                                                  data[index]
                                                                      .id
                                                                      .oid)
                                                              .then((value) =>
                                                                  setState(
                                                                    () {},
                                                                  ));
                                                        }
                                                      }),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      )),
                                    );
                                  },
                                ),
                              ),
                            );
                          }
                        }),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
