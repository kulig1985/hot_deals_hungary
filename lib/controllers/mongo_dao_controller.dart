import 'dart:async';
import 'dart:collection';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hot_deals_hungary/controllers/user_controller.dart';
import 'package:hot_deals_hungary/models/mongo/add_item_to_shopping_list_entity.dart';
import 'package:hot_deals_hungary/models/mongo/custom_offer_model.dart';
import 'package:hot_deals_hungary/models/mongo/modify_offer_listener_entity.dart';
import 'package:hot_deals_hungary/models/mongo/modify_shopping_list_entity.dart';
import 'package:hot_deals_hungary/models/mongo/modify_shopping_list_item_entity.dart';
import 'package:hot_deals_hungary/models/mongo/offer_creation_done.dart';
import 'package:hot_deals_hungary/models/mongo/offer_listener_entity.dart';
import 'package:hot_deals_hungary/models/mongo/shopping_list_complex_model.dart';
import 'package:hot_deals_hungary/models/mongo/shopping_list_creation_done.dart';
import 'package:hot_deals_hungary/models/mongo/shopping_list_entity.dart';
import 'package:hot_deals_hungary/models/mongo/offer.dart';
import 'package:hot_deals_hungary/screens/action_listener/action_listener_page.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

class MongoDaoController extends GetxController {
  var _httpClient = http.Client();

  var BASE_URL = 'http://95.138.193.102:9988';
  Map<String, String> BASE_HEADER = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };
  var _selectedListMap = {}.obs;

  get selectedListMap => _selectedListMap;

  var _shoppingListEntityList = <ShoppingListEntity>[].obs;
  var choosenShoppingListLength = 0.obs;
  var sumPrice = 0.obs;
  var _offerListSize = 0.obs;

  get offerListSize => _offerListSize;

  String? choosenListId;
  ShoppingListEntity? _choosenShoppingList;
  var _offerListenerEntityList = <OfferListenerEntityOld>[].obs;
  OfferListenerEntityOld? _justAddedOffer;

  var _customOfferListenerAndOfferWrapperList =
      <CustomOfferListenerAndOfferWrapper>[].obs;

  get customOfferListenerAndOfferWrapperList =>
      _customOfferListenerAndOfferWrapperList;

  OfferListenerEntityOld? get justAddedOffer => _justAddedOffer;

  get offerListenerEntityList => _offerListenerEntityList;
  get offerListenerEntityListLength => _offerListenerEntityList.length;

  var _rxShoppingList = ShoppingListEntity(
          alloweUidList: [],
          boolId: 1,
          crDate: 'na.',
          id: SlId(oid: 'na'),
          itemList: [],
          listName: 'Default list',
          modDate: 'na.',
          imageColorIndex: 0)
      .obs;

  get rxShoppingList => _rxShoppingList;

  set tstShoppingList(rxShoppingList) {
    _rxShoppingList = rxShoppingList;
  }

  ShoppingListEntity? get choosenShoppingList => _choosenShoppingList;
  //int? get choosenShoppingListLength => _choosenShoppingList?.itemList.length;

  get shoppingListEntityList => _shoppingListEntityList;
  get shoppingListEntityListLength => _shoppingListEntityList.length;

  Future<OfferCreationDoneEntity> createOfferListener(
      String itemName, String uid) async {
    OfferListenerEntityOld offerListenerEntity = OfferListenerEntityOld(
        uid: uid,
        itemName: itemName,
        crDate: createDateString(),
        boolId: 1,
        imageColorIndex: Random().nextInt(4));

    Map<String, dynamic> offerListenerEntityMap = offerListenerEntity.toJson();

    offerListenerEntityMap.remove('_id');

    print(offerListenerEntityMap);

    var uri = Uri.parse('$BASE_URL/create_offer_listener');

    var response = await _httpClient.post(uri,
        body: jsonEncode(offerListenerEntityMap), headers: BASE_HEADER);

    var json = response.body;
    OfferCreationDoneEntity offerCreationDoneEntity =
        offerCreationDoneEntityFromJson(json);

    return offerCreationDoneEntity;
  }

  Future<List<OfferListenerEntityOld>> getAllOfferListenerByUser(
      String uid, String? justAddedId) async {
    print('getAllOfferListenerByUser invoked..');
    var uri = Uri.parse('$BASE_URL/get_offer_listener_by_user/$uid');
    var response = await _httpClient.get(uri);

    var json = response.body;
    List<OfferListenerEntityOld> offerListenerList =
        offerListenerEntityOldFromJson(json);

    print("offerListenerList length: " + offerListenerList.length.toString());

    _offerListenerEntityList.clear();
    _offerListenerEntityList.addAll(offerListenerList);

    print("_offerListenerEntityList length: " +
        _offerListenerEntityList.length.toString());

    //print("offerListenerList len:${offerListenerList!.length}");

    /*if (justAddedId != null) {
      final justAddedOfferListner =
          offerListenerList!.where((element) => element.id!.oid == justAddedId);
      print("justAddedOfferListner: " + justAddedOfferListner.first.id!.oid!);
      _justAddedOffer = justAddedOfferListner.first;
    }*/

    for (var offerListener in offerListenerList) {
      CustomOfferListenerAndOfferWrapper customOfferListenerAndOfferWrapper =
          CustomOfferListenerAndOfferWrapper(
              offerListenerEntity: offerListener);

      List<OfferOld> offerList = await getOffers(offerListener.itemName);

      customOfferListenerAndOfferWrapper.offers = offerList;

      _customOfferListenerAndOfferWrapperList
          .add(customOfferListenerAndOfferWrapper);
    }

    print(
        "_customOfferListenerAndOfferWrapperList: ${customOfferListenerAndOfferWrapperToJson(_customOfferListenerAndOfferWrapperList)}");

    return offerListenerList;
  }

  void removeElement(int index) {
    _offerListenerEntityList.removeAt(index);
  }

/*
  Future<OfferListenerEntity> findJustCreatedOfferListener(String id) async {
    final justAddedOfferListner =
        offerListenerList!.where((element) => element.id!.oid == id);

    return justAddedOfferListner.first as OfferListenerEntity;
  }
*/
  Future<http.Response> modifyOfferListener(Id id, int boolId) {
    // ignore: prefer_interpolation_to_compose_strings
    print('modifyOfferListener invoked: id:' +
        id.oid.toString() +
        'boolId: ' +
        boolId.toString());
    var uri = Uri.parse('$BASE_URL/modify_offer_listener');

    ModifyOfferListenerEntity modifyOfferListenerEntity =
        ModifyOfferListenerEntity(
            id: id.oid.toString(), boolId: boolId, modDate: createDateString());

    Map<String, dynamic> modifyOfferListenerEntityMap =
        modifyOfferListenerEntity.toJson();

    var response = _httpClient.patch(uri,
        body: jsonEncode(modifyOfferListenerEntityMap), headers: BASE_HEADER);

    return response;
  }

  Future<List<OfferOld>> getOffers(String itemCleanName) async {
    /*if (itemCleanName == '') {
      return createEmptyOfferList();
    } else {*/
    print('getOffers invoked!');
    var uri = Uri.parse('$BASE_URL/get_offer/$itemCleanName');

    var response = await _httpClient.get(uri);

    var json = response.body;
    List<OfferOld> offerList = offerOldFromJson(json);

    print("offerList size: ${offerList.length}");

    _offerListSize = RxInt(offerList.length);

    update();

    return offerList;

    /*if (offerList.isNotEmpty) {
        return offerList;
      } else {
        var completer = Completer<List<Offer>>();
        List<Offer> emptyOfferList = <Offer>[];
        completer.complete(emptyOfferList);
        print(completer.future);
        return completer.future;
      }
    }*/
  }

  resetOfferListSize() {
    print('resetOfferListSize invoked!');
    _offerListSize = RxInt(0);
  }

  Future<List<OfferOld>> createEmptyOfferList() {
    var completer = Completer<List<OfferOld>>();

    List<OfferOld> emptyOfferList = <OfferOld>[];

    OfferOld emptyOffer = OfferOld(
        id: IdOf(oid: 'Na.'),
        itemId: 'Na.',
        itemName: 'Nincs akció - változtass a termék nevén',
        itemCleanName: 'Nincs akció',
        imageUrl: 'https://picsum.photos/60',
        price: 0,
        measure: 'Na.',
        salesStart: 'Na.',
        source: 'Na.',
        runDate: 'Na.',
        shopName: 'Na.',
        timeKey: 'Na.',
        insertType: 'Na.');

    emptyOfferList.add(emptyOffer);

    completer.complete(emptyOfferList);

    return completer.future;
  }

  Future<List<ShoppingListComplexModel>> getAllComplexShoppingListByUser(
      User user) async {
    var uri = Uri.parse('$BASE_URL/get_shopping_list_by_user/${user.uid}');
    var response = await _httpClient.get(uri);

    print('getAllComplexShoppingListByUser invoked with uid: ${user.uid}');

    var json = response.body;
    List<ShoppingListComplexModel> shoppingListOnUser =
        shoppingListComplexModelFromJson(json);

    print(
        "shoppingListEntityListResponse length: ${shoppingListOnUser.length}");

    return shoppingListOnUser;
  }

  Future<void> getAllShoppingListByUser(User user) async {
    var uri = Uri.parse('$BASE_URL/get_shopping_list_by_user/${user.uid}');
    var response = await _httpClient.get(uri);

    print('getAllShoppingListByUser invoked with uid: ${user.uid}');

    var json = response.body;
    List<ShoppingListEntity> shoppingListEntityListResponse =
        shoppingListEntityFromJson(json);

    print(
        "shoppingListEntityListResponse length: ${shoppingListEntityListResponse.length}");

    _selectedListMap.clear();

    //if (_selectedListMap.isEmpty) {
    for (var shoppingList in shoppingListEntityListResponse) {
      if (shoppingList.id!.oid != _rxShoppingList.value.id!.oid) {
        _selectedListMap[shoppingList.id!.oid] = false;
      } else {
        _selectedListMap[shoppingList.id!.oid] = true;
      }
    }

    //}
    shoppingListEntityList.clear();
    shoppingListEntityList.addAll(shoppingListEntityListResponse);

    for (ShoppingListEntity shoppingList in shoppingListEntityList) {
      print('shoppingList loop');
      if (shoppingList.id!.oid == choosenListId) {
        _rxShoppingList = Rx(shoppingList);
        print('_rxShoppingList set to new value!');
        choosenShoppingListLength = RxInt(shoppingList.itemList.length);
        sumOfShoppingList();
        print(
            "getAllShoppingListByUser choosenShoppingListLength set to:$choosenShoppingListLength");
        update();
      }
    }

    //return shoppingListEntityList;
  }

  selectShoppingList(String oid, bool value) {
    _selectedListMap[oid] = value;

    _selectedListMap.forEach((key, value) {
      _selectedListMap[key] = false;

      if (key == oid) {
        print('if key:' + key);
        _selectedListMap[oid] = value;
        choosenListId = oid;

        for (ShoppingListEntity shoppingList in shoppingListEntityList) {
          if (shoppingList.id!.oid == oid) {
            //_choosenShoppingList = shoppingList;
            _rxShoppingList = Rx(shoppingList);
            choosenShoppingListLength = RxInt(shoppingList.itemList.length);
            sumOfShoppingList();
            print(
                "selectShoppingList new length set to: $choosenShoppingListLength");
            //print("choosenShoppingList set to: $choosenShoppingList");
          }
        }
      }
    });
    update();
  }

  Future<void> addOfferToShoppingList(
      OfferOld offer, int addVolume, User user) async {
    _selectedListMap.forEach((key, value) {
      if (value) {
        choosenListId = key.toString();
      }
    });

    bool offerExistOnList = false;
    int volume = 0;
    int boolId = 0;
    String crDate = '';
    int checkFlag = 0;

    if (choosenListId != null) {
      for (ShoppingListEntity shoppingList in shoppingListEntityList) {
        if (shoppingList.id!.oid == choosenListId) {
          for (ItemList itemListInstance in shoppingList.itemList) {
            if (itemListInstance.itemDetail.offerCollectionId == offer.id.oid) {
              print('Already existing item: offer.id.oid: ${offer.id.oid}');
              offerExistOnList = true;
              volume = itemListInstance.volume;
              print('volume:$volume');
              boolId = itemListInstance.boolId;
              crDate = itemListInstance.crDate;
              checkFlag = itemListInstance.checkFlag;
            }
          }
        }
      }
      if (offerExistOnList) {
        print('modify item volume!');
        volume += 1;
        print('volume mod:$volume');

        ModifyShoppingListItemEntity modifyShoppingListItemEntity =
            ModifyShoppingListItemEntity(
                id: choosenListId!,
                offerCollectionId: offer.id.oid,
                boolId: boolId,
                crDate: crDate,
                checkFlag: checkFlag,
                volume: volume);

        Map<String, dynamic> modifyShoppingListItemEntityMap =
            modifyShoppingListItemEntity.toJson();

        //print(jsonEncode(itemToAddEntityMap));

        var uri = Uri.parse('$BASE_URL/modify_shopping_list_item');

        var response = await _httpClient.patch(uri,
            body: jsonEncode(modifyShoppingListItemEntityMap),
            headers: BASE_HEADER);

        print(response.body);
        if (response.statusCode == 201) {
          getAllShoppingListByUser(user);
        }
      } else {
        print('creating new item!');
        print('choosenListId: ${choosenListId!}');

        ItemDetail itemDetail = ItemDetail(
            offerCollectionId: offer.id.oid,
            itemId: offer.itemId ?? null,
            itemName: offer.itemName,
            itemCleanName: offer.itemCleanName,
            imageUrl: offer.imageUrl,
            price: offer.price,
            measure: offer.measure,
            salesStart: offer.salesStart,
            source: offer.source,
            runDate: offer.runDate,
            shopName: offer.shopName,
            timeKey: offer.timeKey);

        ItemList itemList = ItemList(
            itemDetail: itemDetail,
            crDate: createDateString(),
            checkFlag: 0,
            boolId: 1,
            volume: addVolume);
        AddItemToShoppingListEntity itemToAdd =
            AddItemToShoppingListEntity(id: choosenListId!, newItem: itemList);

        Map<String, dynamic> itemToAddEntityMap = itemToAdd.toJson();

        //print(jsonEncode(itemToAddEntityMap));

        var uri = Uri.parse('$BASE_URL/add_item_to_shopping_list');

        var response = await _httpClient.post(uri,
            body: jsonEncode(itemToAddEntityMap), headers: BASE_HEADER);

        print(response.body);
        if (response.statusCode == 201) {
          getAllShoppingListByUser(user);
          sumOfShoppingList();
        }
      }
    } else {
      Get.defaultDialog(
          title: "Nincs bevásárló listád!",
          backgroundColor: Color.fromRGBO(65, 37, 37, 0.9),
          titleStyle: TextStyle(color: Colors.white),
          middleTextStyle: TextStyle(color: Colors.white),
          radius: 5,
          content: Column(
            children: [shoppingListExistCheck(user)],
          ));
    }
  }

  Future<void> createNewShoppingList(User user) async {
    AllowedUidList allowedUidList = AllowedUidList(
        uid: user.uid,
        boolId: 1,
        crDate: createDateString(),
        role: 'creator',
        modDate: null);

    int shoppingListNr = shoppingListEntityList.value.length + 1;

    ShoppingListComplexModel newShoppingListEntity = ShoppingListComplexModel(
        id: IdScm(oid: '0'),
        alloweUidList: [allowedUidList],
        boolId: 1,
        crDate: createDateString(),
        offerModelList: [],
        listName:
            '${user.displayName} listája nr: ${shoppingListNr.toString()}',
        modDate: createDateString(),
        imageColorIndex: Random().nextInt(4));

    Map<String, dynamic> newShoppingListEntityMap =
        newShoppingListEntity.toJson();

    newShoppingListEntityMap.remove('_id');

    var uri = Uri.parse('$BASE_URL/create_shopping_list');

    /*var response = await _httpClient
        .post(uri,
            body: jsonEncode(newShoppingListEntityMap), headers: BASE_HEADER)
        .then((value) => getAllShoppingListByUser(user));*/

    var response = await _httpClient.post(uri,
        body: jsonEncode(newShoppingListEntityMap), headers: BASE_HEADER);

    var json = response.body;
    /*ShoppingListCreationDoneEntity shoppingListCreationDoneEntity =
        shoppingListCreationDoneEntityFromJson(json);*/

    print('new Shopping list done:' + json);

    //return shoppingListCreationDoneEntity;
  }

  Future<void> removeUserFromShoppingList(
      User user, String shoppingListOidToRemove) async {
    print(
        "removeUserFromShoppingList invoked on shopping list oid: $shoppingListOidToRemove");
    AlloweUidList alloweUidList = AlloweUidList(
        uid: user.uid,
        boolId: 0,
        crDate: createDateString(),
        role: 'creator',
        modDate: createDateString());
    ModifyShoppingListEntity modifyShoppingListEntity =
        ModifyShoppingListEntity(
            id: shoppingListOidToRemove,
            removeUser: 'Y',
            alloweUidList: alloweUidList);

    Map<String, dynamic> newShoppingListEntityMap =
        modifyShoppingListEntity.toJson();
    var uri = Uri.parse('$BASE_URL/modify_shopping_list');

    var response = await _httpClient
        .patch(uri,
            body: jsonEncode(newShoppingListEntityMap), headers: BASE_HEADER)
        .then((value) => print('remove succes!'))
        .then((value) => getAllShoppingListByUser(user))
        .then((value) => choosenShoppingListLength = RxInt(0))
        .then((value) => sumPrice = RxInt(0))
        .then((value) => choosenListId = null)
        .then((value) => update());
  }

  setShoppingListToDefault() {
    ItemDetail itemDetail = ItemDetail(
        offerCollectionId: 'na.',
        itemId: 'na.',
        itemName: 'na.',
        itemCleanName: 'na.',
        imageUrl: 'na.',
        price: 0,
        measure: 'na.',
        salesStart: 'na.',
        source: 'na.',
        runDate: 'na.',
        shopName: 'na.',
        timeKey: 'na.');

    ItemList itemList = ItemList(
        itemDetail: itemDetail,
        crDate: createDateString(),
        checkFlag: 0,
        boolId: 1,
        volume: 0);

    _rxShoppingList.value = ShoppingListEntity(
        alloweUidList: [],
        boolId: 1,
        crDate: 'na.',
        id: SlId(oid: 'na'),
        itemList: [itemList],
        listName: 'Default list',
        modDate: 'na.',
        imageColorIndex: 0);
  }

  ItemList createEmptyShoppingList() {
    ItemDetail itemDetail = ItemDetail(
        offerCollectionId: 'na.',
        itemId: 'na.',
        itemName: 'na.',
        itemCleanName: 'na.',
        imageUrl: 'na.',
        price: 0,
        measure: 'na.',
        salesStart: 'na.',
        source: 'na.',
        runDate: 'na.',
        shopName: 'na.',
        timeKey: 'na.');

    ItemList itemList = ItemList(
        itemDetail: itemDetail,
        crDate: createDateString(),
        checkFlag: 0,
        boolId: 1,
        volume: 0);

    return itemList;
  }

  sumOfShoppingList() {
    int sumPriceLocal = 0;
    if (_rxShoppingList.value.itemList.isNotEmpty) {
      for (ItemList shoppingList in _rxShoppingList.value.itemList) {
        sumPriceLocal += shoppingList.itemDetail.price * shoppingList.volume;
      }
      print('shopping list sum set to: $sumPriceLocal');
      sumPrice = RxInt(sumPriceLocal);
    } else {
      sumPrice = RxInt(0);
    }
  }

  Future<void> setCheckFlagOnOffer(User user, String offerId, bool value,
      int boolId, String crDate, int volume) async {
    int checkFlag = 0;
    if (value) {
      checkFlag = 1;
    }

    ModifyShoppingListItemEntity modifyShoppingListItemEntity =
        ModifyShoppingListItemEntity(
            id: choosenListId!,
            offerCollectionId: offerId,
            boolId: boolId,
            crDate: crDate,
            checkFlag: checkFlag,
            volume: volume);

    Map<String, dynamic> modifyShoppingListItemEntityMap =
        modifyShoppingListItemEntity.toJson();

    print(jsonEncode(modifyShoppingListItemEntityMap));

    var uri = Uri.parse('$BASE_URL/modify_shopping_list_item');

    var response = await _httpClient.patch(uri,
        body: jsonEncode(modifyShoppingListItemEntityMap),
        headers: BASE_HEADER);

    print(response.body);
    if (response.statusCode == 201) {
      getAllShoppingListByUser(user);
    }
  }

  Future<void> removeItemFromShoppingList(
      User user, String offerId, int volume, int checkFlag) async {
    ModifyShoppingListItemEntity modifyShoppingListItemEntity =
        ModifyShoppingListItemEntity(
            id: choosenListId!,
            offerCollectionId: offerId,
            volume: volume,
            checkFlag: checkFlag,
            boolId: 0,
            modDate: createDateString());

    Map<String, dynamic> modifyShoppingListItemEntityMap =
        modifyShoppingListItemEntity.toJson();

    print(jsonEncode(modifyShoppingListItemEntityMap));

    var uri = Uri.parse('$BASE_URL/modify_shopping_list_item');

    var response = await _httpClient
        .patch(uri,
            body: jsonEncode(modifyShoppingListItemEntityMap),
            headers: BASE_HEADER)
        .then((value) => getAllShoppingListByUser(user))
        .then((value) => print(
            'rxShoppingList lengt dissmiss:${rxShoppingList.value.itemList.length}'));

    update();
  }

  Future<void> addOfferByUser(
      String itemName, String shopName, User user) async {
    OfferOld offerAddByUserEntity = OfferOld(
        id: IdOf(oid: '123'),
        imageUrl: 'Na.',
        insertType: user.uid,
        itemCleanName: itemName,
        itemId: null,
        itemName: itemName,
        measure: 'Na.',
        price: 0,
        runDate: 'Na.',
        salesStart: 'Na.',
        shopName: shopName,
        source: 'user_add',
        timeKey: '1990_01_01_00_00');

    Map<String, dynamic> offerAddByUserEntityMap =
        offerAddByUserEntity.toJson();

    offerAddByUserEntityMap.remove('_id');

    var postObject = jsonEncode(offerAddByUserEntityMap);

    var uri = Uri.parse('$BASE_URL/add_offer');

    Map<String, String> custom_header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    var response =
        await _httpClient.post(uri, body: postObject, headers: BASE_HEADER);

    if (response.statusCode == 201) {
      print('success adding!');

      var json = response.body;
      OfferCreationDoneEntity offerCreationDoneEntity =
          offerCreationDoneEntityFromJson(json);

      print('offer created by user id: ${offerCreationDoneEntity.id}');

      addUserCreatedOfferToShoppingList(offerCreationDoneEntity, user);
    }
  }

  Future<void> addUserCreatedOfferToShoppingList(
      OfferCreationDoneEntity offerCreationDoneEntity, User user) async {
    var uri =
        Uri.parse('$BASE_URL/find_offer_by_id/${offerCreationDoneEntity.id}');

    var response = await _httpClient.get(uri);

    final Map<String, dynamic> data = json.decode(response.body);

    OfferOld createdNewOffer = OfferOld.fromJson(data);

    print(createdNewOffer);

    addOfferToShoppingList(createdNewOffer, 1, user);
  }

  Widget shoppingListExistCheck(User user) {
    if (shoppingListEntityList.value.length == 0) {
      return const Text(
        "Hozz létre majd válassz ki egy bevásárló listát, a Listáim menüpontban!",
        style: TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
      );
      /*ElevatedButton.icon(
        onPressed: () {
          createNewShoppingList(user);
          Get.back();
        },
        icon: const Icon(Icons.list_alt_sharp),
        label: const Text("Bevásárló lista létrehozása!"),
        style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(fontSize: 15),
            primary: const Color.fromRGBO(196, 99, 82, 1)),
      );*/
    } else {
      return const Text(
        "Válassz ki egy bevásárló listát!",
        style: TextStyle(color: Colors.white),
      );
    }
  }

  Future<void> addUserToShoppingList(String uid) async {
    AlloweUidList alloweUidList = AlloweUidList(
        uid: uid, boolId: 1, crDate: createDateString(), role: 'subscriber');

    ModifyShoppingListEntity modifyShoppingListEntity =
        ModifyShoppingListEntity(
            id: rxShoppingList.value.id.oid,
            removeUser: 'N',
            boolId: rxShoppingList.value.boolId,
            alloweUidList: alloweUidList);

    Map<String, dynamic> newShoppingListEntityMap =
        modifyShoppingListEntity.toJson();
    var uri = Uri.parse('$BASE_URL/modify_shopping_list');

    var response = await _httpClient.patch(uri,
        body: jsonEncode(newShoppingListEntityMap), headers: BASE_HEADER);

    Get.snackbar(
      "Lista megosztás sikerül!",
      "Uid-val: $uid",
      duration: Duration(seconds: 1),
      icon: Icon(Icons.share, color: Colors.black12),
      snackPosition: SnackPosition.TOP,
    );
  }

  Future<String> findOfferByFilters(String shopDropDownValue,
      String priceDropDownValue, OfferListenerEntityOld offer) {
    print(
        "findoffer invoked with: shopDropDownValue:$shopDropDownValue  priceDropDownValue: $priceDropDownValue offerSearchName: ${offer.id!.oid!}");

    getOffers(offer.itemName)
        .then((value) => print("offerList size xxxx:${value.length}"));

    var completer = Completer<String>();
    String emptyString = "Aldi";
    completer.complete(emptyString);

    return completer.future;
  }

  String createDateString() {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm");
    String stringDate = dateFormat.format(DateTime.now());
    return stringDate;
  }
}
