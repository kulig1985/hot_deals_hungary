import 'dart:async';
import 'dart:math';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
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
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:logger/logger.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uni_links/uni_links.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';

class ListOfShoppingListScreen extends StatefulWidget {
  const ListOfShoppingListScreen({Key? key}) : super(key: key);

  @override
  State<ListOfShoppingListScreen> createState() =>
      _ListOfShoppingListScreenState();
}

class _ListOfShoppingListScreenState extends State<ListOfShoppingListScreen>
    with WidgetsBindingObserver {
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

  Future<List<ShoppingListComplexModel>>? shoppingListOnUser;

  bool shimmerEnabled = true;
  var _gridVisible = true;

  Uri? _initialURI;
  Uri? _currentURI;
  Object? _err;
  bool _initialURILinkHandled = false;
  bool appLinkCheckFinished = false;
  bool isLoading = false;

  Widget _getListWidgets(List<AlloweUidList> lstItens) {
    return Row(children: lstItens.map((i) => Text(i.uid)).toList());
  }

  @override
  void initState() {
    log.d("initState called!");

    super.initState();
    _initURIHandler();
    _incomingLinkHandler();
    shoppingListOnUser = _mainDaoController.getAllComplexShoppingListByUser(
        _userDataController.user, null, false, false, true);
    WidgetsBinding.instance.addObserver(this);
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    log.d("didChangeAppLifecycleState invoked state: $state");
    if (state == AppLifecycleState.resumed) {
      shoppingListOnUser = _mainDaoController.getAllComplexShoppingListByUser(
          _userDataController.user, null, false, false, true);

      setState(() {});
    }
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  late NavigatorState _navigator;
  @override
  void didChangeDependencies() {
    _navigator = Navigator.of(context);
    super.didChangeDependencies();
  }

  String checkUserNameExist(User user) {
    if (user.displayName == "" || user.displayName == null) {
      return user.email!;
      //
    } else {
      return user.displayName!;
    }
  }

  StreamSubscription? _streamSubscription;

  Future<void> _initURIHandler() async {
    log.d("_initURIHandler invoked!");
    if (!_initialURILinkHandled) {
      _initialURILinkHandled = true;
      try {
        final initialURI = await getInitialUri();
        // Use the initialURI and warn the user if it is not correct,
        // but keep in mind it could be `null`.
        if (initialURI != null) {
          log.d("Initial URI received $initialURI");
          if (!mounted) {
            return;
          }
          setState(() {
            _initialURI = initialURI;
          });
          log.d("_initialURI set to: ${_initialURI.toString()}");
          await loadSharedList(_initialURI!);
        } else {
          log.d("Null Initial URI received");
          setState(() {
            appLinkCheckFinished = true;
          });
        }
      } on PlatformException {
        // Platform messages may fail, so we use a try/catch PlatformException.
        // Handle exception by warning the user their action did not succeed
        log.d("Failed to receive initial uri");
      } on FormatException catch (err) {
        if (!mounted) {
          return;
        }
        log.d('Malformed Initial URI received');
        setState(() => _err = err);
      }
    }
  }

  _incomingLinkHandler() {
    log.d("_incomingLinkHandler invoked!");
    _streamSubscription = uriLinkStream.listen((Uri? uri) async {
      log.d("_incomingLinkHandler listen invoked!");
      appLinkCheckFinished = false;
      if (!mounted) {
        return;
      }
      log.d('Received URI: $uri');
      _currentURI = uri;
      _err = null;
      setState(() {
        appLinkCheckFinished = false;
      });
      await loadSharedList(_currentURI!);
    }, onError: (Object err) {
      if (!mounted) {
        return;
      }
      log.d('Error occurred: $err');
      setState(() {
        _currentURI = null;
        appLinkCheckFinished = true;
        if (err is FormatException) {
          _err = err;
        } else {
          _err = null;
        }
      });
    });
  }

  Future<void> loadSharedList(Uri uri) async {
    log.d("loadSharedList with uri: $uri");
    if (_currentURI != null) {

      String shoppingListId = _currentURI!.queryParameters['shoppingList']!;
      _currentURI = null;

      /*final stream = Stream.fromFutures([
      _mainDaoController.addUserToShoppingList(
          _userDataController.user, shoppingListId),
      _mainDaoController.getAllComplexShoppingListByUser(
          _userDataController.user, shoppingListId, true, false, true),
      _mainDaoController.selectShoppingList(shoppingListId)
    ]);

    stream.asyncMap((event) => null).drain(null);
*/

      await _mainDaoController.addUserToShoppingList(
          _userDataController.user, shoppingListId);

      await _mainDaoController.getAllComplexShoppingListByUser(
          _userDataController.user, shoppingListId, true, false, true);

      await _mainDaoController.selectShoppingList(shoppingListId);

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const ShoppingListGroupView()))
          .then((value) => shoppingListOnUser =
          _mainDaoController.getAllComplexShoppingListByUser(
              _userDataController.user, null, true, false, true))
          .then((value) => setState(
            () {
          appLinkCheckFinished = true;
        },
      ));

    }
    else {

      setState(
            () {
          appLinkCheckFinished = true;
        },
      );

    }

  }

  Widget checkSharedList(ShoppingListComplexModel shoppingListComplexModel) {
    AllowedUidList? alloweUidList = shoppingListComplexModel.alloweUidList
        .firstWhereOrNull(
            (element) => element.uid != _userDataController.user.uid);
    if (alloweUidList != null) {
      return const Icon(Icons.share, color: Colors.black);
    } else {
      return Container();
    }
  }

  var colors = [
    Color.fromRGBO(255, 204, 128, 1),
    Color.fromRGBO(207, 147, 217, 1),
    Color.fromRGBO(230, 238, 155, 1),
    Color.fromRGBO(124, 223, 232, 1),
    Color.fromRGBO(255, 171, 145, 1),
  ];

  var listOptions = ["Megosztás", "Törlés"];

  Future<void> share(String url) async {
    await FlutterShare.share(
        title: 'Lista megosztása',
        text: 'Meg szeretném osztani veled a listámat! Klikk rá!',
        linkUrl: url,
        chooserTitle: 'Chooser');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: CustomAppBar(
            titleName: 'Bevásárló listák',
            backButtonchooser: false,
          ),
        ),
        body: Container(
          color: const Color.fromRGBO(37, 37, 37, 1),
          child: SafeArea(
            child: Container(
              width: double.infinity,
              color: const Color.fromRGBO(37, 37, 37, 1),
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
                            onTap: () async {
                              setState(() {
                                isLoading = true;
                              });

                              String newShoppingListId =
                                  await _mainDaoController
                                      .createNewShoppingList(
                                          _userDataController.user);

                              await _mainDaoController
                                  .getAllComplexShoppingListByUser(
                                      _userDataController.user,
                                      newShoppingListId,
                                      false,
                                      false,
                                      true);

                              _mainDaoController.selectShoppingList(
                                  _mainDaoController
                                      .lastCreatedShoppingListId!);

                              Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ShoppingListGroupView()))
                                  .then((value) => shoppingListOnUser =
                                      _mainDaoController
                                          .getAllComplexShoppingListByUser(
                                              _userDataController.user,
                                              null,
                                              false,
                                              false,
                                              true))
                                  .then((value) => setState(
                                        () {
                                          isLoading = false;
                                        },
                                      ));
                            },
                            child: Container(
                              height: 165,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                  color: const Color.fromRGBO(104, 237, 173, 1),
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
                                        Icons.add,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      "Új bevásárló lista létrehozása! ",
                                      style: TextStyle(
                                          color: Colors.black,
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
                    Visibility(visible: isLoading, child: CircularLoader()),
                    Visibility(
                        visible: !isLoading,
                        child: conoditionalShoppingListGridCreator()),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Future<void> refreshGrid() async {
    shoppingListOnUser = _mainDaoController.getAllComplexShoppingListByUser(
        _userDataController.user, null, false, false, true);
  }

  Widget conoditionalShoppingListGridCreator() {
    if (appLinkCheckFinished) {
      return Expanded(
        child: FutureBuilder(
            initialData: [],
            future: shoppingListOnUser,
            builder: (context, snapshot) {
              log.d("snapshot.connectionState:${snapshot.connectionState}");
              if (snapshot.connectionState == ConnectionState.waiting) {
                log.d("connection state waiting waiting");
                return CircularLoader();
              } else {
                log.d("data: " + snapshot.data.toString());
                var data =
                    (snapshot.data as List<ShoppingListComplexModel>).toList();

                return Visibility(
                  visible: _gridVisible,
                  child: Container(
                    margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
                    child: GetBuilder<MongoDaoController>(
                      builder: (_) => LiquidPullToRefresh(
                        height: 100,
                        color: const Color.fromRGBO(37, 37, 37, 1),
                        showChildOpacityTransition: false,
                        springAnimationDurationInMilliseconds: 500,
                        onRefresh: () async {
                          refreshGrid();
                          setState(() {});
                        },
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisExtent: 180.0,
                                  crossAxisSpacing: 0,
                                  mainAxisSpacing: 0),
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return AnimationConfiguration.staggeredGrid(
                              position: index,
                              duration: const Duration(milliseconds: 375),
                              columnCount: 2,
                              child: ScaleAnimation(
                                child: FadeInAnimation(
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    color: colors[
                                        ((index / 5 - (index / 5).floor()) * 5)
                                            .toInt()],
                                    child: Container(
                                        child: GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        await _mainDaoController
                                            .selectShoppingList(
                                                data[index].id.oid);

                                        _navigator
                                            .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    const ShoppingListGroupView()))
                                            .then((value) => setState(
                                                  () {
                                                    isLoading = false;
                                                  },
                                                ));
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10, left: 10, right: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    width: 60,
                                                    child: Text(
                                                      data[index].listName,
                                                      maxLines: 2,
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, top: 10),
                                              child: Text(
                                                "${data[index].offerModelList.length} db termék",
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),

                                          /*Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, top: 10),
                                              child: Text(
                                                "${_mainDaoController.countSumOfShoppingList(data[index])} ,-Ft",
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),*/
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              /*const Padding(
                                                padding: EdgeInsets.only(
                                                    top: 0, left: 10, bottom: 0),
                                                child: FaIcon(
                                                  FontAwesomeIcons.listCheck,
                                                  color: Colors.white,
                                                ),
                                              ),*/
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 0,
                                                    right: 10,
                                                    bottom: 0),
                                                child: PopupMenuButton(
                                                    color: const Color.fromRGBO(
                                                        43, 47, 58, 1),
                                                    icon: const FaIcon(
                                                      FontAwesomeIcons.ellipsis,
                                                      color: Colors.black,
                                                    ),
                                                    itemBuilder: (context) {
                                                      return List.generate(
                                                        listOptions.length,
                                                        (index) =>
                                                            PopupMenuItem(
                                                          value: listOptions[
                                                              index],
                                                          child: Text(
                                                            listOptions[index],
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.white,
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
                                                    onSelected: (value) async {
                                                      print(value);

                                                      if (value == 'Törlés') {
                                                        await _mainDaoController
                                                            .removeUserFromShoppingList(
                                                                _userDataController
                                                                    .user,
                                                                data[index]
                                                                    .id
                                                                    .oid);

                                                        shoppingListOnUser =
                                                            _mainDaoController
                                                                .getAllComplexShoppingListByUser(
                                                                    _userDataController
                                                                        .user,
                                                                    null,
                                                                    false,
                                                                    false,
                                                                    true);

                                                        setState(() {});
                                                      }
                                                      if (value ==
                                                          'Megosztás') {
                                                        share(
                                                            'hotdeal://kebodev.hu/?shoppingList=${data[index].id.oid}');
                                                      }
                                                    }),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 10),
                                                child: checkSharedList(
                                                    data[index]),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              }
            }),
      );
    } else {
      return Container(
        margin: const EdgeInsets.only(top: 150),
        child: Center(
            child: Column(
          children: const [
            CircularProgressIndicator(
              color: Colors.white,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Egy pillanat!",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            )
          ],
        )),
      );
    }
  }

  Visibility shimmerGrid() {
    return Visibility(
      visible: _gridVisible,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 10),
                    child: Shimmer.fromColors(
                      direction: ShimmerDirection.ltr,
                      period: const Duration(milliseconds: 1000),
                      baseColor: const Color.fromARGB(255, 23, 25, 31),
                      highlightColor: const Color.fromARGB(126, 36, 52, 111),
                      enabled: true,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[600],
                            borderRadius: BorderRadius.circular(5)),
                        width: 160,
                        height: 10,
                      ),
                    ),
                  ),
                  Shimmer.fromColors(
                    direction: ShimmerDirection.ltr,
                    period: const Duration(milliseconds: 1000),
                    baseColor: const Color.fromARGB(255, 23, 25, 31),
                    highlightColor: const Color.fromARGB(126, 36, 52, 111),
                    enabled: true,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, top: 30),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[600],
                            borderRadius: BorderRadius.circular(5)),
                        width: 80,
                        height: 10,
                      ),
                    ),
                  ),
                  Shimmer.fromColors(
                    direction: ShimmerDirection.ltr,
                    period: const Duration(milliseconds: 1000),
                    baseColor: const Color.fromARGB(255, 23, 25, 31),
                    highlightColor: const Color.fromARGB(126, 36, 52, 111),
                    enabled: true,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, top: 20),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[600],
                            borderRadius: BorderRadius.circular(5)),
                        width: 60,
                        height: 10,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Shimmer.fromColors(
                        direction: ShimmerDirection.ltr,
                        period: const Duration(milliseconds: 1000),
                        baseColor: const Color.fromARGB(255, 23, 25, 31),
                        highlightColor: const Color.fromARGB(126, 36, 52, 111),
                        enabled: true,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 20, left: 10, bottom: 0),
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                color: Colors.grey[600],
                                borderRadius: BorderRadius.circular(5)),
                          ),
                        ),
                      ),
                      Shimmer.fromColors(
                        direction: ShimmerDirection.ltr,
                        period: const Duration(milliseconds: 1000),
                        baseColor: const Color.fromARGB(255, 23, 25, 31),
                        highlightColor: const Color.fromARGB(126, 36, 52, 111),
                        enabled: true,
                        child: Padding(
                            padding: const EdgeInsets.only(
                                top: 20, right: 10, bottom: 0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[600],
                                  borderRadius: BorderRadius.circular(5)),
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
      ),
    );
  }
}

class CircularLoader extends StatelessWidget {
  const CircularLoader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 150),
      child: Center(
          child: Column(
        children: const [
          CircularProgressIndicator(
            color: Colors.white,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Egy pillanat...",
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )
        ],
      )),
    );
  }
}
