import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hot_deals_hungary/controllers/main_dao_controller.dart';
import 'package:hot_deals_hungary/controllers/mongo_dao_controller.dart';
import 'package:hot_deals_hungary/controllers/user_controller.dart';
import 'package:hot_deals_hungary/models/mongo/offer.dart';
import 'package:hot_deals_hungary/models/mongo/offer_listener_entity.dart';
import 'package:hot_deals_hungary/models/mongo/shopping_list_complex_model.dart';
import 'package:hot_deals_hungary/screens/action_listener/search_offer_new_page.dart';
import 'package:hot_deals_hungary/screens/components/custom_app_bar.dart';
import 'package:hot_deals_hungary/screens/components/custom_page_route.dart';
import 'package:logger/logger.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';
import 'package:http/http.dart' as http;

class ShoppingListGroupView extends StatefulWidget {
  const ShoppingListGroupView({Key? key}) : super(key: key);

  @override
  State<ShoppingListGroupView> createState() => _ShoppingListGroupViewState();
}

class _ShoppingListGroupViewState extends State<ShoppingListGroupView> {
  final UserDataController _userDataController = Get.find();
  final MainDaoController _mainDaoController = Get.find();
  TextEditingController userUidTextController = TextEditingController();
  TextEditingController offerSearchTextController = TextEditingController();
  TextEditingController listNameTextController = TextEditingController();
  String shopDropDownValue = 'Összes üzlet';
  String priceDropDownValue = 'Legjobb árak';

  var messageVisible = false;
  var opactityVisible = false;
  var saveButtonVisible = true;
  var listVisible = true;

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

  bool ischecked(int checkFlag) {
    log.d("invoked: $checkFlag");
    return checkFlag == 1;
  }

  int _index = 0;
  /*
  Widget conditionalShoppingListBuilder() {
    final GroupedItemScrollController itemScrollController =
        GroupedItemScrollController();
    if (_mongoDaoController.rxShoppingList!.value.itemList.length == 0) {
      return Column(
        children: const [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 200),
            child: Text(
              "Üres bevásárló lista!",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white),
            ),
          )
        ],
      );
    } else {
      return StickyGroupedListView<dynamic, String>(
        stickyHeaderBackgroundColor: Color.fromRGBO(43, 47, 58, 1),
        elements: _mongoDaoController.rxShoppingList!.value.itemList,
        groupBy: (dynamic element) => element.itemDetail.shopName,
        groupSeparatorBuilder: (dynamic element) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
          child: SizedBox(
            height: 50,
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(255, 183, 90, 1),
                    borderRadius: BorderRadius.circular(16.0)),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    element.itemDetail.shopName,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ),
            ),
          ),
        ),
        itemBuilder: (context, dynamic element) => Dismissible(
          key: Key(element.itemDetail.offerCollectionId),
          onDismissed: (direction) {
            _mongoDaoController.removeItemFromShoppingList(
                _userDataController.user,
                element.itemDetail.offerCollectionId,
                element.volume,
                element.checkFlag);
          },
          background: Container(
            margin: const EdgeInsets.only(bottom: 10.0),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0.0),
            decoration: BoxDecoration(
              color: Colors.white,
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
            margin: const EdgeInsets.only(bottom: 5.0, left: 15, right: 15),
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(15.0)),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(
                              value: ischecked(element.checkFlag),
                              onChanged: (value) {
                                print('checked!');
                                _mongoDaoController.setCheckFlagOnOffer(
                                    _userDataController.user,
                                    element.itemDetail.offerCollectionId,
                                    value!,
                                    element.boolId,
                                    element.crDate,
                                    element.volume);
                              }),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Text(
                              '${element.itemDetail.itemName}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(element.volume.toString() + "db = "),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: Text(
                                '${element.volume * element.itemDetail.price},-Ft',
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                )),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        elementIdentifier: (element) => element
            .itemDetail.offerCollectionId, // optional - see below for usage
        itemScrollController: itemScrollController, // optional
        order: StickyGroupedListOrder.ASC, // optional
      );
    }
  }*/

  Future<String?> checkImageUrl(String imageUrl) async {
    var _httpClient = http.Client();
    var uri = Uri.parse(imageUrl);

    try {
      var response = await _httpClient.get(uri);

      if (response.statusCode == 200) {
        return imageUrl;
      } else {
        return null;
      }
    } catch (_) {
      return null;
    }
  }
  /*
  String futureString(String shopDropDownValue, String priceDropDownValue,
      OfferListenerEntityOld offer) {
    String returnString = '';

    _mongoDaoController
        .findOfferByFilters(shopDropDownValue, priceDropDownValue, offer)
        .then((value) => returnString = value);

    return returnString;
  }*/

  AssetImage defineShopLogo(String shopName) {
    switch (shopName) {
      case 'aldi':
        return const AssetImage('assets/images/aldi_logo.png');
      case 'lidl':
        return const AssetImage('assets/images/lidl_logo.png');
      case 'auchan':
        return const AssetImage('assets/images/auchan_logo.png');
      case 'spar':
        return const AssetImage('assets/images/spar_logo.png');
      case 'tesco':
        return const AssetImage('assets/images/tesco_logo.png');
      default:
        return const AssetImage('assets/images/not_found.png');
    }
  }

  List<Offer> checkIfOfferListEmpty(List<Offer> offerList) {
    log.d("invoked offerList length: ${offerList.length}");
    if (offerList.isNotEmpty) {
      log.d("returning offerList length: ${offerList.length}");
      return offerList;
    } else {
      List<Offer> emptyOfferList = [];

      var emptyOffer = Offer(
          id: "0",
          itemId: -1,
          itemName: "Nincsenek akciók",
          itemCleanName: "Nincsenek akciók",
          imageUrl: "na",
          price: 0,
          measure: "na",
          salesStart: "na",
          source: "na",
          runDate: "na",
          shopName: "Nincsenek akciók",
          isSales: 0,
          insertType: "na",
          timeKey: "na",
          imageColorIndex: 0,
          isSelectedFlag: 0,
          selectedBy: "na");

      emptyOfferList.add(emptyOffer);

      log.d("returning emptyOfferList length: ${emptyOfferList.length}");

      return emptyOfferList;
    }
  }

  @override
  Widget build(BuildContext context) {
    final PersistentTabController _controller =
        PersistentTabController(initialIndex: 0);

    listNameTextController.text =
        _mainDaoController.choosenShoppingList.value.listName;
    /*
    Future<String?> openAddUserDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Add meg a felhazsnáló azonosítót!"),
              content: TextField(
                controller: userUidTextController,
                autofocus: true,
                autocorrect: false,
                decoration: const InputDecoration(
                    hintText: "pld. prQUKkIxljVqbHlCKah7T1Rh7l22"),
              ),
              actions: [
                TextButton(
                    onPressed: () async {
                      if (userUidTextController.text != "") {
                        await _mongoDaoController
                            .addUserToShoppingList(userUidTextController.text);

                        print('User added to shopping list!');

                        setState(() {});
                        userUidTextController.clear();
                      }

                      Navigator.of(context).pop(userUidTextController.text);
                    },
                    child: const Text("Mentés")),
                TextButton(
                  onPressed: () =>
                      Navigator.pop(context, "Mégsem"), // passing false
                  child: const Text('Mégsem'),
                )
              ],
            ));*/

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CustomAppBar(
          titleName: 'Bevásárló lista',
          backButtonchooser: true,
        ),
      ),
      body: SafeArea(
          child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
        color: const Color.fromRGBO(43, 47, 58, 1),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15, top: 10, bottom: 20),
                  child: TextField(
                    autofocus: false,
                    autocorrect: false,
                    onEditingComplete: () {
                      print('fuck editing completed!');
                    },
                    controller: listNameTextController,
                    //_mongoDaoController.rxShoppingList.value.listName,
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                /*Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      color: Color.fromRGBO(35, 39, 46, 1),
                      padding: EdgeInsets.only(left: 15),
                      margin: EdgeInsets.only(left: 15, bottom: 20),
                      child: SizedBox(
                        width: 160,
                        height: 38,
                        child: DropdownButtonFormField<String>(
                          dropdownColor: const Color.fromRGBO(35, 39, 46, 1),
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                          isExpanded: true,
                          value: shopDropDownValue,
                          elevation: 16,
                          onChanged: (String? newValue) {},
                          items: <String>[
                            'Összes üzlet',
                            'aldi',
                            'auchan',
                            'spar',
                            'tesco',
                            'lidl',
                            'piac',
                            'egyéb'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    Container(
                      color: Color.fromRGBO(35, 39, 46, 1),
                      padding: EdgeInsets.only(left: 15),
                      margin: EdgeInsets.only(left: 15, bottom: 20),
                      child: SizedBox(
                        width: 160,
                        height: 38,
                        child: DropdownButtonFormField<String>(
                          dropdownColor: const Color.fromRGBO(35, 39, 46, 1),
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                          isExpanded: true,
                          value: priceDropDownValue,
                          elevation: 16,
                          onChanged: (String? newValue) {},
                          items: <String>['Legjobb árak', 'Összes ár']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    )
                  ],
                ),*/
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 330,
                      margin: const EdgeInsets.only(top: 15),
                      child: Container(
                        margin: const EdgeInsets.only(left: 10, right: 10),
                        height: 38,
                        child: TextField(
                            style: const TextStyle(color: Colors.white),
                            //autofocus: true,
                            controller: offerSearchTextController,

                            /*onEditingComplete: () {
                            print('editing completed!');
                          },
                          onSubmitted: (value) {
                            print(offerSearchTextController.text);
                          },*/
                            textAlign: TextAlign.start,
                            textAlignVertical: TextAlignVertical.bottom,
                            autocorrect: false,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                filled: true,
                                hintStyle: TextStyle(color: Colors.grey),
                                hintText: "Új elem a bevásárló listára!",
                                fillColor: Color.fromRGBO(54, 60, 73, 1))),
                      ),
                    ),
                    Container(
                        decoration: const BoxDecoration(
                          color: const Color.fromRGBO(111, 181, 139, 1),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        width: 40,
                        height: 40,
                        padding: EdgeInsets.only(right: 10),
                        margin: EdgeInsets.only(top: 15, left: 20),
                        child: IconButton(
                            onPressed: () {
                              if (offerSearchTextController.text != '' &&
                                  offerSearchTextController.text.length >= 3) {
                                setState(() {
                                  listVisible = false;
                                  log.d("set State invoked!");
                                  _mainDaoController
                                      .createOfferListener(
                                          offerSearchTextController.text,
                                          _mainDaoController
                                              .choosenShoppingList.value,
                                          _userDataController.user)
                                      .then((value) => _mainDaoController
                                          .getAllComplexShoppingListByUser(
                                              _userDataController.user,
                                              _mainDaoController
                                                  .choosenShoppingList
                                                  .value
                                                  .id
                                                  .oid,
                                              true,
                                              true,
                                              false))
                                      .then((value) => _mainDaoController
                                          .selectShoppingList(_mainDaoController
                                              .oldShoppingListoid!))
                                      .then((value) => setState(() {
                                            log.d("set State 2 invoked!");
                                            messageVisible = true;
                                            listVisible = true;
                                            offerSearchTextController.text = "";
                                          }));
                                });

                                /*_mongoDaoController
                                    .createOfferListener(
                                        offerSearchTextController.text,
                                        _userDataController.user.uid)
                                    .then((value) => _mongoDaoController
                                        .getAllOfferListenerByUser(
                                            _userDataController.user.uid, null))
                                    .then(
                                        (value) => _mongoDaoController.update())
                                    .then((value) => setState(() {
                                          messageVisible = true;
                                        }));
                                        */
                              }
                              /*
                              if (offerSearchTextController.text != '' &&
                                  offerSearchTextController.text.length >= 3) {
                                setState(() {
                                  offerList = _mongoDaoController.getOffers(
                                      offerSearchTextController.text);
                                });
                              }*/
                            },
                            icon: const Icon(Icons.add)))
                  ],
                ),
                Visibility(
                  visible: !listVisible,
                  child: Center(
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
                          margin: const EdgeInsets.only(top: 15),
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )),
                ),
                Visibility(
                  visible: listVisible,
                  child: Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 20),
                      child: ListView.builder(
                          itemCount: _mainDaoController
                              .choosenShoppingList.value.offerModelList.length,
                          itemBuilder: (context, index) {
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 350),
                              child: SlideAnimation(
                                verticalOffset: 60.0,
                                child: FadeInAnimation(
                                  child: Container(
                                    margin: EdgeInsets.only(top: 5),
                                    child: Column(children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              Obx(
                                                () => RoundCheckBox(
                                                    size: 30,
                                                    checkedColor:
                                                        const Color.fromRGBO(
                                                            111, 181, 139, 1),
                                                    isChecked: ischecked(
                                                        _mainDaoController
                                                            .choosenShoppingList
                                                            .value
                                                            .offerModelList[
                                                                index]
                                                            .offerListenerEntity
                                                            .checkFlag!),
                                                    onTap: (_) {
                                                      log.d("onTap invoked!");
                                                      _mainDaoController.modifyCheckFlagOnOfferListener(
                                                          _mainDaoController
                                                              .choosenShoppingList
                                                              .value
                                                              .offerModelList[
                                                                  index]
                                                              .offerListenerEntity
                                                              .id,
                                                          _mainDaoController
                                                              .choosenShoppingList
                                                              .value
                                                              .offerModelList[
                                                                  index]
                                                              .offerListenerEntity
                                                              .checkFlag!,
                                                          index);
                                                    }),
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              Text(
                                                _mainDaoController
                                                    .choosenShoppingList
                                                    .value
                                                    .offerModelList[index]
                                                    .offerListenerEntity
                                                    .itemName,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          GetBuilder<MainDaoController>(
                                            builder: (_) => Container(
                                              margin: EdgeInsets.only(top: 5),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${checkIfOfferListEmpty(_mainDaoController.choosenShoppingList.value.offerModelList[index].offers)[0].price * _mainDaoController.choosenShoppingList.value.offerModelList[index].offerListenerEntity.itemCount},- Ft",
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    "${checkIfOfferListEmpty(_mainDaoController.choosenShoppingList.value.offerModelList[index].offers)[0].price} /db",
                                                    style: const TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 185, 185, 185),
                                                        fontSize: 12),
                                                    textAlign: TextAlign.start,
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 50,
                                            width: 300,
                                            child: ListTile(
                                              leading: CircleAvatar(
                                                radius: 20,
                                                backgroundImage: defineShopLogo(
                                                    checkIfOfferListEmpty(
                                                            _mainDaoController
                                                                .choosenShoppingList
                                                                .value
                                                                .offerModelList[
                                                                    index]
                                                                .offers)[0]
                                                        .shopName),
                                              ),
                                              title: Text(
                                                checkIfOfferListEmpty(
                                                        _mainDaoController
                                                            .choosenShoppingList
                                                            .value
                                                            .offerModelList[
                                                                index]
                                                            .offers)[0]
                                                    .shopName,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              subtitle: Text(
                                                checkIfOfferListEmpty(
                                                        _mainDaoController
                                                            .choosenShoppingList
                                                            .value
                                                            .offerModelList[
                                                                index]
                                                            .offers)[0]
                                                    .itemName,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              await Navigator.push(
                                                      context,
                                                      CustomPageRoute(
                                                          child: SearchOffersPage(
                                                              index: index,
                                                              itemCleanName: _mainDaoController
                                                                  .choosenShoppingList
                                                                  .value
                                                                  .offerModelList[
                                                                      index]
                                                                  .offerListenerEntity
                                                                  .itemName)))
                                                  .then((value) =>
                                                      _mainDaoController
                                                          .update())
                                                  .then((value) => setState(
                                                        () {},
                                                      ));
                                            },
                                            child: Text(
                                              'további ${_mainDaoController.choosenShoppingList.value.offerModelList[index].offers.length} találat ${checkIfOfferListEmpty(_mainDaoController.choosenShoppingList.value.offerModelList[index].offers)[0].price} Ft-tól',
                                              style: const TextStyle(
                                                  color: Color.fromRGBO(
                                                      30, 136, 228, 1),
                                                  decoration:
                                                      TextDecoration.underline),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  if (_mainDaoController
                                                          .choosenShoppingList
                                                          .value
                                                          .offerModelList[index]
                                                          .offerListenerEntity
                                                          .itemCount >
                                                      1) {
                                                    log.d("onTap invoked!");
                                                    _mainDaoController
                                                        .modifyItemCountOnOfferListener(
                                                            _mainDaoController
                                                                .choosenShoppingList
                                                                .value
                                                                .offerModelList[
                                                                    index]
                                                                .offerListenerEntity
                                                                .id,
                                                            -1,
                                                            index)
                                                        .then((value) =>
                                                            _mainDaoController
                                                                .update());
                                                  }
                                                },
                                                icon: const Icon(
                                                  Icons.remove_circle,
                                                  size: 30,
                                                  color: Color.fromRGBO(
                                                      130, 130, 130, 1),
                                                ),
                                              ),
                                              Container(
                                                height: 30,
                                                width: 35,
                                                decoration: const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(5)),
                                                    color: Color.fromRGBO(
                                                        31, 36, 43, 1)),
                                                child: Center(
                                                  child: GetBuilder<
                                                      MainDaoController>(
                                                    builder: (_) => Text(
                                                      _mainDaoController
                                                          .choosenShoppingList
                                                          .value
                                                          .offerModelList[index]
                                                          .offerListenerEntity
                                                          .itemCount
                                                          .toString(),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  log.d("onTap invoked!");
                                                  _mainDaoController
                                                      .modifyItemCountOnOfferListener(
                                                          _mainDaoController
                                                              .choosenShoppingList
                                                              .value
                                                              .offerModelList[
                                                                  index]
                                                              .offerListenerEntity
                                                              .id,
                                                          1,
                                                          index)
                                                      .then((value) =>
                                                          _mainDaoController
                                                              .update());
                                                },
                                                icon: const Icon(
                                                  Icons.add_circle,
                                                  size: 30,
                                                  color: Colors.white,
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                      const Divider(
                                        color: Color.fromRGBO(130, 130, 130, 1),
                                      )
                                    ]),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                ),
                /*Expanded(
                  child: FutureBuilder(
                      initialData: [],
                      future: offerList,
                      builder: (context, snapshot) {
                        var data = (snapshot.data as List<dynamic>).toList();
                        if (data.isNotEmpty) {
                          print('data not empty:${data.length}');
                          print(snapshot.connectionState);
                          return Container(
                            margin: EdgeInsets.only(top: 20),
                            child: ListView.builder(
                                itemCount: data.length,
                                itemBuilder: (BuildContext ctx, index) {
                                  return Container(
                                    height: 90,
                                    margin: const EdgeInsets.only(
                                      bottom: 3,
                                      left: 10,
                                      right: 10,
                                    ),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                    child: Row(
                                      children: [
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        FutureBuilder(
                                          future: checkImageUrl(
                                              data[index].imageUrl),
                                          builder: ((context, snapshot) {
                                            if (snapshot.data != null) {
                                              return FadeInImage(
                                                width: 70,
                                                height: 70,
                                                placeholder: const AssetImage(
                                                    'assets/images/wait.png'),
                                                image: NetworkImage(
                                                    data[index].imageUrl),
                                              );
                                            } else {
                                              return const Image(
                                                image: AssetImage(
                                                    'assets/images/image_not_found.png'),
                                                width: 75,
                                                height: 75,
                                              );
                                            }
                                          }),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${data[index].price},-Ft',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              width: 200,
                                              child: AutoSizeText(
                                                data[index].itemName,
                                                maxLines: 2,
                                              ),
                                            ),
                                            Text(data[index].shopName),
                                          ],
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 50),
                                          child: Material(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.white,
                                            child: IconButton(
                                                splashRadius: 60,
                                                icon: Icon(
                                                    Icons.add_box_outlined),
                                                onPressed: () {
                                                  _mongoDaoController
                                                      .addOfferToShoppingList(
                                                          data[index],
                                                          1,
                                                          _userDataController
                                                              .user);
                                                  //_mongoDaoController.update();
                                                }),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }),
                          );
                        } else {
                          print('if data.length: ${data.length}');
                          print(snapshot.connectionState);
                          if (snapshot.connectionState !=
                              ConnectionState.waiting) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 200),
                              child: Center(
                                child: SizedBox(
                                  width: 200,
                                  child: Text(
                                    "Nem találtam akciókat! Módosítsd a kereső szót! 😿",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 18,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        }
                      }),
                )*/
                /*HeaderWidget(
                  titleName: 'Kosár',
                  backButtonchooser: false,
                )
                GetBuilder<MongoDaoController>(
                  builder: (_) => Container(
                    margin:
                        const EdgeInsets.only(bottom: 0, left: 10, right: 10),
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(54, 60, 73, 1),
                        borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GetBuilder<MongoDaoController>(
                          builder: (_) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, top: 15),
                                child: Text(
                                  _mongoDaoController
                                      .rxShoppingList.value.listName,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                              /*Material(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.transparent,
                                child: Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        _mongoDaoController
                                            .removeUserFromShoppingList(
                                                _userDataController.user,
                                                _mongoDaoController
                                                    .rxShoppingList
                                                    .value
                                                    .id
                                                    .oid);
                                        _mongoDaoController.update();
                                        Navigator.pop(context);

                                        /*Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    NavigationPersistentScreen()),
                                            ModalRoute.withName("/home"));*/
                                      },
                                      icon: const Icon(Icons.delete),
                                      label: const Text("Leiratkozás"),
                                      style: ElevatedButton.styleFrom(
                                          textStyle:
                                              const TextStyle(fontSize: 15),
                                          primary: const Color.fromRGBO(
                                              247, 196, 105, 1)),
                                    )),
                              )*/
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                "Összesen: ${_mongoDaoController.sumPrice} ,-Ft",
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            Material(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.transparent,
                              child: Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      openAddUserDialog();
                                    },
                                    icon: const Icon(Icons.share),
                                    label: const Text("Megosztás"),
                                    style: ElevatedButton.styleFrom(
                                        textStyle:
                                            const TextStyle(fontSize: 15),
                                        primary: const Color.fromRGBO(
                                            196, 99, 82, 1)),
                                  )),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: GetBuilder<MongoDaoController>(
                        builder: (_) => conditionalShoppingListBuilder()),
                  ),
                ),*/
              ],
            )
          ],
        ),
      )),
      //bottomNavigationBar: const BottomBar(),
      /*floatingActionButton: FloatingActionButton.extended(
        label: const Text('Egyedi termék hozzáadása!'),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddCustomItemToShoppingList()));
          /*Get.to(HomePage(
            user: _userDataController.user,
          ));*/
        },
        backgroundColor: Color.fromRGBO(54, 60, 73, 1),
        icon: Icon(Icons.add_card_sharp),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,*/
    );
  }
}
