import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
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
import 'package:hot_deals_hungary/models/push_notification.dart';
import 'package:hot_deals_hungary/screens/components/custom_app_bar.dart';
import 'package:hot_deals_hungary/screens/shopping_list/shopping_list_group_view.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:logger/logger.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uni_links/uni_links.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';

/*Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
  FlutterAppBadger.updateBadgeCount(1);
}
*/

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
  bool appLinkCheckFinished = true;
  bool isLoading = false;
  String? platformName;

  late final FirebaseMessaging _messaging;
  PushNotification? _notificationInfo;

  void requestAndRegisterNotification() async {
    // 2. Instantiate Firebase Messaging
    _messaging = FirebaseMessaging.instance;
    //FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 3. On iOS, this helps to take the user permissions
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log.d('User granted permission');
      String? token = await _messaging.getToken();
      log.d("The token is " + token!);

      if (Platform.isAndroid) {
        log.d("platfrom is Android!");
        platformName = "android";
      } else if (Platform.isIOS) {
        log.d("platfrom is IOS!");
        platformName = "ios";
      }

      _mainDaoController.createUidAndToken(
          _userDataController.user, token, platformName!);

      // For handling the received notifications
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        // Parse the message received
        PushNotification notification = PushNotification(
          title: message.notification?.title,
          body: message.notification?.body,
        );

        log.d(notification.toString());

        FlutterAppBadger.updateBadgeCount(1);
        /*
        setState(() {
          _notificationInfo = notification;
          _totalNotifications++;
        });
        */

        showSimpleNotification(
          Text(notification.title!),
          leading: const Image(
            image: AssetImage('assets/images/szatyor.png'),
          ),
          subtitle: Text(notification.body!),
          background: const Color.fromRGBO(124, 223, 232, 1),
          duration: Duration(seconds: 2),
        );
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }

  Widget _getListWidgets(List<AlloweUidList> lstItens) {
    return Row(children: lstItens.map((i) => Text(i.uid)).toList());
  }

  @override
  void initState() {
    log.d("initState called!");

    super.initState();
    //_initURIHandler();
    //_incomingLinkHandler();
    _initFirebaseDynamicLink();
    shoppingListOnUser = _mainDaoController.getAllComplexShoppingListByUser(
        _userDataController.user, null, false, false, true);
    WidgetsBinding.instance.addObserver(this);

    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) async {
      log.d(
          "dynamicLink: ${dynamicLinkData.link.queryParameters['shoppingListId']!}");

      setState(
        () {
          appLinkCheckFinished = false;
        },
      );

      String? shoppingListId =
          dynamicLinkData.link.queryParameters['shoppingListId'];
      String? shoppingListName =
          dynamicLinkData.link.queryParameters['shoppingListName'];

      if (shoppingListId != null && shoppingListName != null) {
        await showAddSharedListDialog(
            context, shoppingListId, shoppingListName);
      } else {
        setState(
          () {
            appLinkCheckFinished = true;
          },
        );
      }
    }).onError((error) {
      // Handle errors
      setState(
        () {
          appLinkCheckFinished = true;
        },
      );
    });

    //_totalNotifications = 0;
    //FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    requestAndRegisterNotification();

    /*
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Parse the message received
      PushNotification notification = PushNotification(
        title: message.notification?.title,
        body: message.notification?.body,
      );

      log.d(notification.toString());

      FlutterAppBadger.updateBadgeCount(1);

    });*/
  }

  showAddSharedListDialog(
      BuildContext context, String shoppingListId, String listName) async {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text(
        "Nem",
        style: TextStyle(color: Colors.black),
      ),
      onPressed: () {
        setState(
          () {
            appLinkCheckFinished = true;
            Navigator.of(context).pop();
          },
        );
      },
    );
    Widget continueButton = TextButton(
      child: const Text(
        "Igen",
        style: TextStyle(color: Colors.black),
      ),
      onPressed: () async {
        Navigator.of(context).pop();
        await loadSharedList(shoppingListId);
      },
    ); // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text(
        "Feliratkozás listára?",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      content: Text(
        "Szeretnél feliratkozni a ${listName} nevű listára?",
        style: const TextStyle(color: Colors.black),
      ),
      backgroundColor: const Color.fromRGBO(104, 237, 173, 1),
      actions: [
        cancelButton,
        continueButton,
      ],
    ); // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> _initFirebaseDynamicLink() async {
    final PendingDynamicLinkData? initialLink =
        await FirebaseDynamicLinks.instance.getInitialLink();

    if (initialLink != null) {
      log.d(
          "initialLink: ${initialLink.link.queryParameters['shoppingListId']!}");

      String? shoppingListId =
          initialLink.link.queryParameters['shoppingListId'];
      String? shoppingListName =
          initialLink.link.queryParameters['shoppingListName'];

      setState(
        () {
          appLinkCheckFinished = false;
        },
      );

      if (shoppingListId != null && shoppingListName != null) {
        await showAddSharedListDialog(
            context, shoppingListId, shoppingListName);
      } else {
        setState(
          () {
            appLinkCheckFinished = true;
          },
        );
      }
    }
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

  Future<void> loadSharedList(String shoppingListId) async {
    log.d("loadSharedList with uri: $shoppingListId");

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
    FlutterAppBadger.removeBadge();

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
                                        size: 35,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      "Új bevásárló lista létrehozása! ",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
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
                                    //elevation: 30,
                                    //shadowColor: Colors.green,
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
                                                        final dynamicLinkParams =
                                                            DynamicLinkParameters(
                                                          link: Uri.parse(
                                                              "https://szatyor.eu/?shoppingListId=${data[index].id.oid}&shoppingListName=${data[index].listName}"),
                                                          uriPrefix:
                                                              "https://szatyor.page.link",
                                                          androidParameters:
                                                              const AndroidParameters(
                                                                  packageName:
                                                                      "com.kebodev.szatyor"),
                                                          iosParameters:
                                                              const IOSParameters(
                                                                  bundleId:
                                                                      "com.kebodev.szatyor"),
                                                        );
                                                        final dynamicLink =
                                                            await FirebaseDynamicLinks
                                                                .instance
                                                                .buildShortLink(
                                                                    dynamicLinkParams);

                                                        share(dynamicLink
                                                            .shortUrl
                                                            .toString());
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
