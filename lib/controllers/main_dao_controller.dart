import 'dart:convert';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hot_deals_hungary/models/mongo/change_offer_on_offer_listener.dart';
import 'package:hot_deals_hungary/models/mongo/create_uid_and_token.dart';
import 'package:hot_deals_hungary/models/mongo/modify_offer_listener.dart';
import 'package:hot_deals_hungary/models/mongo/modify_shopping_list_entity.dart';
import 'package:hot_deals_hungary/models/mongo/offer.dart';
import 'package:hot_deals_hungary/models/mongo/offer_creation_done.dart';
import 'package:hot_deals_hungary/models/mongo/shopping_list_complex_model.dart';
import 'package:hot_deals_hungary/models/mongo/shopping_list_creation_done.dart';
import 'package:hot_deals_hungary/models/mongo/shopping_list_entity.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class MainDaoController extends GetxController {
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

  final _httpClient = http.Client();

  final BASE_URL = 'http://95.138.193.102:9988';
  //final BASE_URL = 'http://127.0.0.1:9988';

  Map<String, String> BASE_HEADER = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  var _shoppingListOnUser = <ShoppingListComplexModel>[].obs;
  var choosenShoppingList = ShoppingListComplexModel(
          id: IdScm(oid: '0'),
          listName: 'Default list',
          alloweUidList: [],
          offerModelList: [],
          crDate: 'null',
          modDate: 'null',
          boolId: 0,
          imageColorIndex: 0)
      .obs;

  get shoppingListOnUser => _shoppingListOnUser;
  get shoppingListOnUserLength => _shoppingListOnUser.length;
  String? oldShoppingListoid;
  OfferListenerEntity? lastCreatedofferListenerEntity;
  String? lastCreatedShoppingListId;

  Future<List<ShoppingListComplexModel>> getAllComplexShoppingListByUser(
      User user,
      String? shoppingListId,
      bool refreshOffers,
      bool refreshJustadded,
      bool refreshShoppingList) async {
    String url = "";
    List<ShoppingListComplexModel> shoppingListOnUserLocal;

    log.d("getAllComplexShoppingListByUser invoked");

    if (refreshShoppingList) {
      if (shoppingListId != null) {
        log.d("shoppingListId not null: $shoppingListId");
        url = '$BASE_URL/get_shopping_list_by_user/${user.uid}/$shoppingListId';
      } else {
        log.d("shoppingListId IS null");
        url = '$BASE_URL/get_shopping_list_by_user/${user.uid}/none';
      }

      var uri = Uri.parse(url);
      var response = await _httpClient.get(uri);

      log.d('getAllComplexShoppingListByUser invoked with uid: ${user.uid}');

      var json = response.body;
      shoppingListOnUserLocal = shoppingListComplexModelFromJson(json);
      log.d("json" + json);
    } else {
      shoppingListOnUserLocal = [choosenShoppingList.value];
    }
    /*
    if (refreshOffers) {
      for (ShoppingListComplexModel shoppingList in shoppingListOnUserLocal) {
        for (OfferModelList offerModelList in shoppingList.offerModelList) {
          if (refreshJustadded) {
            if (offerModelList.offerListenerEntity.id ==
                lastCreatedofferListenerEntity!.id) {
              List<Offer> offerList =
                  await getOffers(offerModelList.offerListenerEntity.itemName);

              offerList.sort((a, b) => a.price.compareTo(b.price));
              offerModelList.offers.addAll(offerList);
            }
          } else {
            List<Offer> offerList =
                await getOffers(offerModelList.offerListenerEntity.itemName);

            if (offerModelList.offers.length > 0) {
              offerList.removeWhere(
                  (element) => element.id == offerModelList.offers[0].id);
            }

            offerList.sort((a, b) => a.price.compareTo(b.price));

            offerModelList.offers.addAll(offerList);
          }
        }

        shoppingList.offerModelList.sort((b, a) => a.offerListenerEntity.crDate
            .compareTo(b.offerListenerEntity.crDate));
      }
    }*/

    log.d(
        "shoppingListEntityListResponse length: ${shoppingListOnUser.length}");

    _shoppingListOnUser.clear();
    _shoppingListOnUser.assignAll(shoppingListOnUserLocal);

    log.d("getAllComplexShoppingListByUser finished response!!");

    return shoppingListOnUserLocal;
  }

  Future<void> selectShoppingList(String oid) async {
    log.d('selectShoppingList with oid:$oid');

    oldShoppingListoid = oid;

    ShoppingListComplexModel foundShoppingList =
        _shoppingListOnUser.firstWhere((element) => element.id.oid == oid);
    choosenShoppingList = Rx(foundShoppingList);

    log.d("selectShoppingList finished!!");

    /*await Future.wait(choosenShoppingList.value.offerModelList
        .map((i) async => await loadOffersOnChoosenList(i)));*/

    /*for (OfferModelList offerModelList
        in choosenShoppingList.value.offerModelList) {
      log.d("start call loadOffersOnChoosenList");
      await loadOffersOnChoosenList(offerModelList);
    }*/

    /*for (var offerModelList in choosenShoppingList.value.offerModelList) {
      await loadOffersOnChoosenList(offerModelList);
    }*/

    lastCreatedofferListenerEntity;

    List mappedList = await Future.wait(choosenShoppingList.value.offerModelList
        .map((i) async => await getOffers(i.offerListenerEntity.itemName)));

    /*choosenShoppingList.value.offerModelList.map(
        (e) => e.offers.removeWhere((element) => element.isSelectedFlag == 0));*/

    /*for (OfferModelList offerModelList
        in choosenShoppingList.value.offerModelList) {
      offerModelList.offers
          .removeWhere((element) => element.isSelectedFlag == 0);
    }*/

    for (var i = 0; i < mappedList.length; i++) {
      List<Offer> offers = mappedList[i];

      offers.removeWhere((filteredKeywordMap) => choosenShoppingList
          .value.offerModelList[i].offers
          .any((element) => filteredKeywordMap.id == element.id));

      choosenShoppingList.value.offerModelList[i].offers.addAll(offers);
    }

    choosenShoppingList.value.offerModelList.sort((b, a) =>
        a.offerListenerEntity.crDate.compareTo(b.offerListenerEntity.crDate));

    //update();
  }

  Future<void> loadOffersOnChoosenList(OfferModelList offerModelList) async {
    log.d("loop");
    log.d("itemName:${offerModelList.offerListenerEntity.itemName}");
    offerModelList.offers
        .addAll(await getOffers(offerModelList.offerListenerEntity.itemName));

/*
    offerModelList.offers.addAll(await Future.wait(choosenShoppingList
        .value.offerModelList
        .map((i) async => await getOffers(i.offerListenerEntity.itemName))));

    List mappedList = await Future.wait(choosenShoppingList.value.offerModelList
        .map((i) async => await getOffers(i.offerListenerEntity.itemName)));

    for (var element in mappedList) {
      List<Offer> offers = element;
      for (var offer in offers) {
        log.d("element: ${offer.itemName}");
      }
    }*/
  }

  Future<List<Offer>> getOffers(String itemCleanName) async {
    /*if (itemCleanName == '') {
      return createEmptyOfferList();
    } else {*/
    log.d('getOffers invoked!');
    var uri = Uri.parse('$BASE_URL/get_offer/$itemCleanName');

    var response = await _httpClient.get(uri);

    var json = response.body;
    List<Offer> offerList = offerFromJson(json);

    print("offerList size: ${offerList.length}");

    //update();

    return offerList;
  }

  Future<String> createNewShoppingList(User user) async {
    AllowedUidList allowedUidList = AllowedUidList(
        uid: user.uid,
        boolId: 1,
        crDate: createDateString(),
        role: 'creator',
        modDate: null);

    int shoppingListNr = _shoppingListOnUser.value.length + 1;

    ShoppingListComplexModel newShoppingListEntity = ShoppingListComplexModel(
        id: IdScm(oid: '0'),
        alloweUidList: [allowedUidList],
        boolId: 1,
        crDate: createDateString(),
        offerModelList: [],
        listName:
            '${checkUserNameExist(user)} listája nr: ${shoppingListNr.toString()}',
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

    log.d('new Shopping list done:$json');

    ShoppingListCreationDoneEntity shoppingListCreationDoneEntity =
        shoppingListCreationDoneEntityFromJson(json);

    lastCreatedShoppingListId = shoppingListCreationDoneEntity.id;

    return shoppingListCreationDoneEntity.id;

    //return shoppingListCreationDoneEntity;
  }

  Future<void> addUserToShoppingList(User user, String shoppingListId) async {
    log.d("addUserToShoppingList invoked on list: " + shoppingListId);
    AlloweUidList alloweUidList = AlloweUidList(
        uid: user.uid,
        boolId: 1,
        crDate: createDateString(),
        modDate: createDateString(),
        role: 'subscriber');

    ModifyShoppingListEntity modifyShoppingListEntity =
        ModifyShoppingListEntity(
            id: shoppingListId,
            operationName: 'ADD_USER',
            boolId: 1,
            modDate: createDateString(),
            alloweUidList: alloweUidList);

    Map<String, dynamic> newShoppingListEntityMap =
        modifyShoppingListEntity.toJson();

    newShoppingListEntityMap.remove("boolId");
    newShoppingListEntityMap.remove("listName");

    var uri = Uri.parse('$BASE_URL/modify_shopping_list');

    var response = await _httpClient.patch(uri,
        body: jsonEncode(newShoppingListEntityMap), headers: BASE_HEADER);

    log.d("addUserToShoppingList finished response:$response");
  }

  Future<void> createOfferListener(String listItemName,
      ShoppingListComplexModel shoppingList, User user) async {
    log.d(
        "createOfferListener invoked to create: $listItemName on list: ${shoppingList.id.oid}");

    OfferListenerEntity offerListenerEntity = OfferListenerEntity(
        id: "0",
        uid: user.uid,
        itemName: listItemName,
        crDate: createDateString(),
        boolId: 1,
        modDate: null,
        imageColorIndex: Random().nextInt(4),
        shoppingListId: shoppingList.id.oid,
        checkFlag: 0,
        itemCount: 1);

    Map<String, dynamic> offerListenerEntityMap = offerListenerEntity.toJson();

    offerListenerEntityMap.remove('_id');

    var uri = Uri.parse('$BASE_URL/create_offer_listener');

    var response = await _httpClient.post(uri,
        body: jsonEncode(offerListenerEntityMap), headers: BASE_HEADER);

    log.d("response:${response.body}");

    OfferCreationDoneEntity offerCreationDoneEntity =
        offerCreationDoneEntityFromJson(response.body);

    offerListenerEntity.id = offerCreationDoneEntity.id;

    lastCreatedofferListenerEntity = offerListenerEntity;

    log.d("lastCreatedOfferListenerId:${lastCreatedofferListenerEntity!.id}");

    OfferModelList offerModelList =
        OfferModelList(offerListenerEntity: offerListenerEntity, offers: []);

    choosenShoppingList.value.offerModelList.add(offerModelList);
  }

  OfferModelList createModifiedOfferModelList(
      OfferModelList removedOfferModelList, String operationName) {
    OfferListenerEntity modifiedOfferListener = OfferListenerEntity(
        id: removedOfferModelList.offerListenerEntity.id,
        uid: removedOfferModelList.offerListenerEntity.uid,
        itemName: removedOfferModelList.offerListenerEntity.itemName,
        crDate: removedOfferModelList.offerListenerEntity.crDate,
        boolId: removedOfferModelList.offerListenerEntity.boolId,
        imageColorIndex:
            removedOfferModelList.offerListenerEntity.imageColorIndex,
        shoppingListId:
            removedOfferModelList.offerListenerEntity.shoppingListId,
        itemCount: removedOfferModelList.offerListenerEntity.itemCount);

    switch (operationName) {
      case "itemCount":
        modifiedOfferListener.checkFlag =
            removedOfferModelList.offerListenerEntity.checkFlag;
        break;
      default:
    }

    OfferModelList modifiedOfferModelList = OfferModelList(
        offerListenerEntity: modifiedOfferListener,
        offers: removedOfferModelList.offers);

    return modifiedOfferModelList;
  }

  Future<void> modifyCheckFlagOnOfferListener(
      String offerListenerEntityId, int checkFlag, int index) async {
    log.d(
        "invoked modifyCheckFlagOnOfferListener on offerListener: $offerListenerEntityId");

    ModifyOfferListener modifyOfferListener = ModifyOfferListener(
        id: choosenShoppingList.value.id.oid,
        offerListenerEntityId: offerListenerEntityId);

    Map<String, dynamic> modifyOfferListenerEntityMap =
        modifyOfferListener.toJson();

    OfferModelList removedOfferModelList =
        choosenShoppingList.value.offerModelList.removeAt(index);

    OfferModelList modifiedOfferModelList =
        createModifiedOfferModelList(removedOfferModelList, "checkFlag");

    if (checkFlag == 0) {
      log.d("checkFlag == 0 change to 1");
      modifyOfferListenerEntityMap['checkFlag'] = 1;
      modifiedOfferModelList.offerListenerEntity.checkFlag = 1;
    } else {
      log.d("checkFlag == 1 change to 0");
      modifyOfferListenerEntityMap['checkFlag'] = 0;
      modifiedOfferModelList.offerListenerEntity.checkFlag = 0;
    }
    modifyOfferListenerEntityMap.remove("boolId");
    modifyOfferListenerEntityMap.remove("itemCount");

    log.d(jsonEncode(modifyOfferListenerEntityMap));

    var uri = Uri.parse('$BASE_URL/modify_shopping_list_item');

    var response = await _httpClient.patch(uri,
        body: jsonEncode(modifyOfferListenerEntityMap), headers: BASE_HEADER);

    log.d("response:${response.body}");

    choosenShoppingList.value.offerModelList.add(modifiedOfferModelList);

    choosenShoppingList.value.offerModelList.sort((b, a) =>
        a.offerListenerEntity.crDate.compareTo(b.offerListenerEntity.crDate));
  }

  Future<void> modifyItemCountOnOfferListener(
      String offerListenerEntityId, int itemCount, int index) async {
    ModifyOfferListener modifyOfferListener = ModifyOfferListener(
        id: choosenShoppingList.value.id.oid,
        offerListenerEntityId: offerListenerEntityId);

    Map<String, dynamic> modifyOfferListenerEntityMap =
        modifyOfferListener.toJson();

    OfferModelList removedOfferModelList =
        choosenShoppingList.value.offerModelList.removeAt(index);

    OfferModelList modifiedOfferModelList =
        createModifiedOfferModelList(removedOfferModelList, "itemCount");

    modifyOfferListenerEntityMap['itemCount'] = itemCount;
    modifyOfferListenerEntityMap.remove("boolId");
    modifyOfferListenerEntityMap.remove("checkFlag");
    modifiedOfferModelList.offerListenerEntity.itemCount =
        modifiedOfferModelList.offerListenerEntity.itemCount + itemCount;

    log.d(jsonEncode(modifyOfferListenerEntityMap));

    var uri = Uri.parse('$BASE_URL/modify_shopping_list_item');

    var response = await _httpClient.patch(uri,
        body: jsonEncode(modifyOfferListenerEntityMap), headers: BASE_HEADER);

    log.d("response:${response.body}");

    choosenShoppingList.value.offerModelList.add(modifiedOfferModelList);

    choosenShoppingList.value.offerModelList.sort((b, a) =>
        a.offerListenerEntity.crDate.compareTo(b.offerListenerEntity.crDate));
  }

  Future<void> removeItemFromShoppingList(String offerListenerEntityId) async {
    ModifyOfferListener modifyOfferListener = ModifyOfferListener(
        id: choosenShoppingList.value.id.oid,
        offerListenerEntityId: offerListenerEntityId);

    modifyOfferListener.boolId = 0;

    Map<String, dynamic> modifyOfferListenerEntityMap =
        modifyOfferListener.toJson();

    modifyOfferListenerEntityMap.remove("checkFlag");
    modifyOfferListenerEntityMap.remove("itemCount");

    log.d(modifyOfferListenerEntityMap);

    var uri = Uri.parse('$BASE_URL/modify_shopping_list_item');

    var response = await _httpClient.patch(uri,
        body: jsonEncode(modifyOfferListenerEntityMap), headers: BASE_HEADER);

    log.d("response:${response.body}");
  }

  Future<void> addItemToShoppingList(
      String offerListenerEntityId, Offer offer) async {
    offer.isSelectedFlag = 1;

    ChangeOfferOnOfferListener changeOfferOnOfferListener =
        ChangeOfferOnOfferListener(
            id: choosenShoppingList.value.id.oid,
            offerListenerId: offerListenerEntityId,
            offer: offer);

    log.d(changeOfferOnOfferListenerToJson(changeOfferOnOfferListener));

    var uri = Uri.parse('$BASE_URL/add_item_to_shopping_list');

    var response = await _httpClient.post(uri,
        body: jsonEncode(changeOfferOnOfferListener), headers: BASE_HEADER);

    log.d("response:${response.body}");
  }

  Future<void> modifyOfferListener(String offerListenerEntityId,
      String operation, int? itemCount, int? checkFlag, int index) async {
    log.d("invoked on offerListener: $offerListenerEntityId");

    ModifyOfferListener modifyOfferListener = ModifyOfferListener(
        id: choosenShoppingList.value.id.oid,
        offerListenerEntityId: offerListenerEntityId);

    Map<String, dynamic> modifyOfferListenerEntityMap =
        modifyOfferListener.toJson();

    /*OfferModelList modifiedOfferModelList =
        choosenShoppingList.value.offerModelList.firstWhere((element) =>
            element.offerListenerEntity.id == offerListenerEntityId);*/

    OfferModelList removedOfferModelList =
        choosenShoppingList.value.offerModelList.removeAt(index);

    OfferListenerEntity modifiedOfferListener = OfferListenerEntity(
        id: removedOfferModelList.offerListenerEntity.id,
        uid: removedOfferModelList.offerListenerEntity.uid,
        itemName: removedOfferModelList.offerListenerEntity.itemName,
        crDate: removedOfferModelList.offerListenerEntity.crDate,
        boolId: removedOfferModelList.offerListenerEntity.boolId,
        imageColorIndex:
            removedOfferModelList.offerListenerEntity.imageColorIndex,
        shoppingListId:
            removedOfferModelList.offerListenerEntity.shoppingListId,
        itemCount: removedOfferModelList.offerListenerEntity.itemCount);

    switch (operation) {
      case "remove":
        modifyOfferListenerEntityMap['boolId'] = 0;
        modifyOfferListenerEntityMap.remove("itemCount");
        modifyOfferListenerEntityMap.remove("checkFlag");
        modifiedOfferListener.boolId = 0;

        break;
      case "itemCount":
        modifyOfferListenerEntityMap['itemCount'] = itemCount;
        modifyOfferListenerEntityMap.remove("boolId");
        modifyOfferListenerEntityMap.remove("checkFlag");
        modifiedOfferListener.itemCount =
            modifiedOfferListener.itemCount + itemCount!;
        break;
      case "checkFlag":
        if (checkFlag == 0) {
          log.d("checkFlag == 0 change to 1");
          modifyOfferListenerEntityMap['checkFlag'] = 1;
          modifiedOfferListener.checkFlag = 1;
        } else {
          log.d("checkFlag == 1 change to 0");
          modifyOfferListenerEntityMap['checkFlag'] = 0;
          modifiedOfferListener.checkFlag = 0;
        }
        modifyOfferListenerEntityMap.remove("boolId");
        modifyOfferListenerEntityMap.remove("itemCount");
        break;
      default:
        null;
    }

    log.d("modifiedOfferListener.itemCount: " +
        modifiedOfferListener.itemCount.toString());

    OfferModelList modifiedOfferModelList = OfferModelList(
        offerListenerEntity: modifiedOfferListener,
        offers: removedOfferModelList.offers);

    log.d(jsonEncode(modifyOfferListenerEntityMap));

    var uri = Uri.parse('$BASE_URL/modify_shopping_list_item');

    var response = await _httpClient.patch(uri,
        body: jsonEncode(modifyOfferListenerEntityMap), headers: BASE_HEADER);

    log.d("response:${response.body}");

    choosenShoppingList.value.offerModelList.add(modifiedOfferModelList);

    choosenShoppingList.value.offerModelList.sort((b, a) =>
        a.offerListenerEntity.crDate.compareTo(b.offerListenerEntity.crDate));
  }

  int countSumOfShoppingList() {
    int sum = 0;
    for (OfferModelList offerModelList
        in choosenShoppingList.value.offerModelList) {
      try {
        sum = sum +
            offerModelList.offerListenerEntity.itemCount *
                offerModelList.offers[0].price;
      } catch (e) {
        sum = sum + 0;
      }
    }
    return sum;
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
            operationName: 'REMOVE_USER',
            alloweUidList: alloweUidList);

    Map<String, dynamic> newShoppingListEntityMap =
        modifyShoppingListEntity.toJson();
    var uri = Uri.parse('$BASE_URL/modify_shopping_list');

    var response = await _httpClient.patch(uri,
        body: jsonEncode(newShoppingListEntityMap), headers: BASE_HEADER);
  }

  Future<void> changeShoppingListName(String listName) async {
    ModifyShoppingListEntity modifyShoppingListEntity =
        ModifyShoppingListEntity(
            id: choosenShoppingList.value.id.oid,
            operationName: 'LIST_RENAME',
            listName: listName,
            modDate: createDateString());

    Map<String, dynamic> newShoppingListEntityMap =
        modifyShoppingListEntity.toJson();

    newShoppingListEntityMap.remove("alloweUidList");
    newShoppingListEntityMap.remove("boolId");

    log.d("newShoppingListEntityMap: $newShoppingListEntityMap");

    var uri = Uri.parse('$BASE_URL/modify_shopping_list');

    var response = await _httpClient.patch(uri,
        body: jsonEncode(newShoppingListEntityMap), headers: BASE_HEADER);
  }

  Future<void> createUidAndToken(
      User user, String token, String platform) async {
    log.d("createUidAndToken with ${user.uid} token: $token");

    CreateUidAndToken createUidAndToken = CreateUidAndToken(
        uid: user.uid,
        platform: platform,
        token: token,
        crDate: createDateString(),
        boolId: 1);

    var uri = Uri.parse('$BASE_URL/create_platform_and_token_for_uid');

    var response = await _httpClient.post(uri,
        body: jsonEncode(createUidAndToken), headers: BASE_HEADER);

    log.d("response:${response.body}");
  }

  String checkUserNameExist(User user) {
    if (user.displayName == "" || user.displayName == null) {
      return user.email!.substring(0, user.email!.indexOf("@"));
    } else {
      return user.displayName!;
    }
  }

  String createDateString() {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss:m");
    String stringDate = dateFormat.format(DateTime.now());
    return stringDate;
  }
}
