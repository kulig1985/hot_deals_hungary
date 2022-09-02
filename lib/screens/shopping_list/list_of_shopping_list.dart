import 'dart:math';

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
              padding:
                  const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
              color: const Color.fromRGBO(43, 47, 58, 1),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                                left: 15, right: 0, bottom: 5, top: 10),
                            child: Card(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                color: Color.fromRGBO(43, 47, 58, 1),
                                child: Container(
                                  height: 160,
                                  width: 184,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5, top: 15, bottom: 5),
                                        child: Text(
                                          "Hello ${_userDataController.user.displayName} Próbáld ki és készítsd el az első listád.",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                left: 0, right: 15, bottom: 5, top: 10),
                            child: Card(
                                elevation: 30,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                color: const Color.fromRGBO(111, 181, 139, 1),
                                child: Container(
                                  height: 160,
                                  width: 188,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _mainDaoController
                                            .createNewShoppingList(
                                                _userDataController.user)
                                            .then((value) =>
                                                _mainDaoController.update());
                                      });
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 10, left: 10, bottom: 40),
                                          child: Icon(
                                            Icons.list_alt,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 15, top: 15, bottom: 5),
                                          child: Text(
                                            "Új bevásárló lista létrehozása!",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                          ),
                        ],
                      ),
                      Expanded(
                        child: FutureBuilder(
                            initialData: [],
                            future: _mainDaoController
                                .getAllComplexShoppingListByUser(
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
                                return Shimmer.fromColors(
                                  direction: ShimmerDirection.ltr,
                                  period: Duration(milliseconds: 1000),
                                  loop: 2,
                                  baseColor: Color.fromARGB(255, 23, 25, 31),
                                  highlightColor:
                                      const Color.fromRGBO(83, 120, 252, 0.5),
                                  enabled: true,
                                  child: GridView.builder(
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            mainAxisExtent: 180.0,
                                            crossAxisSpacing: 0,
                                            mainAxisSpacing: 0),
                                    itemCount: 4,
                                    itemBuilder: (context, index) {
                                      return Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              height: 24,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            Container(
                                              width: 250,
                                              height: 24,
                                              decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                );
                                /*return Center(
                                      child: Container(
                                    margin: const EdgeInsets.only(top: 200),
                                    child: Column(
                                      children: [
                                        const Text("Egy pillanat...",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20)),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(top: 15),
                                          child:
                                              const CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ));*/
                              } else {
                                var data =
                                    (snapshot.data as List<dynamic>).toList();

                                return Container(
                                  margin: const EdgeInsets.only(
                                      left: 15, right: 15),
                                  child: GetBuilder<MongoDaoController>(
                                    builder: (_) => GridView.builder(
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              mainAxisExtent: 180.0,
                                              crossAxisSpacing: 0,
                                              mainAxisSpacing: 0),
                                      itemCount: data.length,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          color: colors[
                                              data[index].imageColorIndex],
                                          child: Container(
                                              child: GestureDetector(
                                            onTap: () {
                                              _mainDaoController
                                                  .selectShoppingList(
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
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10, left: 10),
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
                                                  padding:
                                                      const EdgeInsets.only(
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
                                                  padding:
                                                      const EdgeInsets.only(
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
                                                        FontAwesomeIcons
                                                            .listCheck,
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
                                                          color: const Color
                                                                  .fromRGBO(
                                                              43, 47, 58, 1),
                                                          icon: const FaIcon(
                                                            FontAwesomeIcons
                                                                .ellipsis,
                                                            color: Colors.white,
                                                          ),
                                                          itemBuilder:
                                                              (context) {
                                                            return List
                                                                .generate(
                                                              listOptions
                                                                  .length,
                                                              (index) =>
                                                                  PopupMenuItem(
                                                                value:
                                                                    listOptions[
                                                                        index],
                                                                child: Text(
                                                                  listOptions[
                                                                      index],
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        15,
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

                                                            if (value == 0) {
                                                              print(
                                                                  "My account menu is selected.");
                                                            } else if (value ==
                                                                1) {
                                                              print(
                                                                  "Settings menu is selected.");
                                                            } else if (value ==
                                                                2) {
                                                              print(
                                                                  "Logout menu is selected.");
                                                            }
                                                          }),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )),
                                        ); /*Dismissible(
                                    key: Key(_mongoDaoController
                                        .shoppingListEntityList[index].id.oid),
                                    onDismissed: (direction) {
                                      _mongoDaoController.removeUserFromShoppingList(
                                          _userDataController.user,
                                          _mongoDaoController
                                              .shoppingListEntityList[index].id.oid);
                                    },
                                    background: Container(
                                      margin: const EdgeInsets.only(bottom: 5.0),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 0.0),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFE6E6),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        children: [
                                          const Spacer(),
                                          SvgPicture.asset("assets/images/Trash.svg"),
                                        ],
                                      ),
                                    ),
                                    child: Container(
                                      width: double.infinity,
                                      margin: const EdgeInsets.only(bottom: 4.0),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 10.0),
                                      decoration: BoxDecoration(
                                          color: isListChoosenColor(
                                              _mongoDaoController
                                                  .shoppingListEntityList[index].id.oid,
                                              _mongoDaoController.choosenListId),
                                          borderRadius: BorderRadius.circular(10.0)),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            _mongoDaoController.selectShoppingList(
                                                _mongoDaoController
                                                    .shoppingListEntityList[index]
                                                    .id
                                                    .oid,
                                                true);
                                            _mongoDaoController.update();
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const ShoppingListGroupView()));
                                            //Navigator.pop(context);
                                          });
                                        },
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                const Icon(Icons.list),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  _mongoDaoController
                                                      .shoppingListEntityList[index]
                                                      .listName,
                                                  style: const TextStyle(
                                                      color: Color(0XFF211551),
                                                      fontSize: 20.0,
                                                      fontWeight: FontWeight.w200),
                                                ),
                                                const SizedBox(
                                                  width: 140,
                                                ),
                                                isListChoosen(
                                                    _mongoDaoController
                                                        .shoppingListEntityList[index]
                                                        .id
                                                        .oid,
                                                    _mongoDaoController.choosenListId)
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const SizedBox(
                                                  width: 35,
                                                ),
                                                Text(
                                                    "Termékek a listán: ${_mongoDaoController.shoppingListEntityList[index].itemList.length}")
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const SizedBox(
                                                  width: 35,
                                                ),
                                                Text(
                                                    "Felhasználók száma: ${_mongoDaoController.shoppingListEntityList[index].alloweUidList.length}")
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );*/
                                      },
                                    ),
                                  ),
                                );
                              }
                            }),
                      ),
                      //),
                    ],
                  )
                ],
              ))),
      /*floatingActionButton: FloatingActionButton.extended(
        label: const Text('Lista létrehozása!'),
        onPressed: () {
          setState(() {
            _mongoDaoController
                .createNewShoppingList(_userDataController.user)
                .then((value) => _mongoDaoController
                    .getAllShoppingListByUser(_userDataController.user))
                .then((value) => _mongoDaoController.update());
          });
        },
        backgroundColor: Color.fromRGBO(54, 60, 73, 1),
        icon: Icon(Icons.list_alt_rounded),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,*/
    );
  }
}
