// To parse this JSON data, do
//
//     final shoppingListComplexModel = shoppingListComplexModelFromJson(jsonString);

import 'dart:convert';

List<ShoppingListComplexModel> shoppingListComplexModelFromJson(String str) =>
    List<ShoppingListComplexModel>.from(
        json.decode(str).map((x) => ShoppingListComplexModel.fromJson(x)));

String shoppingListComplexModelToJson(List<ShoppingListComplexModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

List<Offer> offerFromJson(String str) =>
    List<Offer>.from(json.decode(str).map((x) => Offer.fromJson(x)));

String offerToJson(List<Offer> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ShoppingListComplexModel {
  ShoppingListComplexModel({
    required this.id,
    required this.listName,
    required this.alloweUidList,
    required this.offerModelList,
    required this.crDate,
    required this.modDate,
    required this.boolId,
    required this.imageColorIndex,
  });

  IdScm id;
  String listName;
  List<AllowedUidList> alloweUidList;
  List<OfferModelList> offerModelList;
  String crDate;
  String modDate;
  int boolId;
  int imageColorIndex;

  factory ShoppingListComplexModel.fromJson(Map<String, dynamic> json) =>
      ShoppingListComplexModel(
          id: IdScm.fromJson(json["_id"]),
          listName: json["listName"],
          alloweUidList: List<AllowedUidList>.from(
              json["alloweUidList"].map((x) => AllowedUidList.fromJson(x))),
          offerModelList: List<OfferModelList>.from(
              json["offerModelList"].map((x) => OfferModelList.fromJson(x))),
          crDate: json["crDate"],
          modDate: json["modDate"],
          boolId: json["boolId"],
          imageColorIndex: json["imageColorIndex"]);

  Map<String, dynamic> toJson() => {
        "_id": id.toJson(),
        "listName": listName,
        "alloweUidList":
            List<dynamic>.from(alloweUidList.map((x) => x.toJson())),
        "offerModelList":
            List<dynamic>.from(offerModelList.map((x) => x.toJson())),
        "crDate": crDate,
        "modDate": modDate,
        "boolId": boolId,
        "imageColorIndex": imageColorIndex
      };
}

class AllowedUidList {
  AllowedUidList({
    required this.uid,
    required this.role,
    required this.boolId,
    required this.crDate,
    this.modDate,
  });

  String uid;
  String role;
  int boolId;
  String crDate;
  String? modDate;

  factory AllowedUidList.fromJson(Map<String, dynamic> json) => AllowedUidList(
        uid: json["uid"],
        role: json["role"],
        boolId: json["boolId"],
        crDate: json["crDate"],
        modDate: json["modDate"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "role": role,
        "boolId": boolId,
        "crDate": crDate,
        "modDate": modDate,
      };
}

class IdScm {
  IdScm({
    required this.oid,
  });

  String oid;

  factory IdScm.fromJson(Map<String, dynamic> json) => IdScm(
        oid: json["\u0024oid"],
      );

  Map<String, dynamic> toJson() => {
        "\u0024oid": oid,
      };
}

class OfferModelList {
  OfferModelList({
    required this.offerListenerEntity,
    required this.offers,
  });

  OfferListenerEntity offerListenerEntity;
  List<Offer> offers;

  factory OfferModelList.fromJson(Map<String, dynamic> json) => OfferModelList(
        offerListenerEntity:
            OfferListenerEntity.fromJson(json["offerListenerEntity"]),
        offers: List<Offer>.from(json["offers"].map((x) => Offer.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "offerListenerEntity": offerListenerEntity.toJson(),
        "offers": List<dynamic>.from(offers.map((x) => x.toJson())),
      };
}

class OfferListenerEntity {
  OfferListenerEntity(
      {required this.id,
      required this.uid,
      required this.itemName,
      required this.crDate,
      required this.boolId,
      this.modDate,
      required this.imageColorIndex,
      required this.shoppingListId,
      this.checkFlag,
      required this.itemCount});

  String id;
  String uid;
  String itemName;
  String crDate;
  int boolId;
  dynamic modDate;
  int imageColorIndex;
  String shoppingListId;
  int? checkFlag;
  int itemCount;

  factory OfferListenerEntity.fromJson(Map<String, dynamic> json) =>
      OfferListenerEntity(
          id: json["_id"],
          uid: json["uid"],
          itemName: json["itemName"],
          crDate: json["crDate"],
          boolId: json["boolId"],
          modDate: json["modDate"],
          imageColorIndex: json["imageColorIndex"],
          shoppingListId: json["shoppingListId"],
          checkFlag: json["checkFlag"],
          itemCount: json["itemCount"]);

  Map<String, dynamic> toJson() => {
        "_id": id,
        "uid": uid,
        "itemName": itemName,
        "crDate": crDate,
        "boolId": boolId,
        "modDate": modDate,
        "imageColorIndex": imageColorIndex,
        "shoppingListId": shoppingListId,
        "checkFlag": checkFlag,
        "itemCount": itemCount
      };
}

class Offer {
  Offer(
      {required this.id,
      required this.itemId,
      required this.itemName,
      required this.itemCleanName,
      required this.imageUrl,
      required this.price,
      required this.measure,
      required this.salesStart,
      required this.source,
      required this.runDate,
      required this.shopName,
      required this.isSales,
      required this.insertType,
      required this.timeKey,
      required this.isSelectedFlag,
      required this.selectedBy});

  String id;
  dynamic itemId;
  String itemName;
  String itemCleanName;
  String imageUrl;
  int price;
  String measure;
  String salesStart;
  String source;
  String runDate;
  String shopName;
  int isSales;
  String insertType;
  String timeKey;
  int isSelectedFlag;
  String selectedBy;

  factory Offer.fromJson(Map<String, dynamic> json) => Offer(
      id: json["id"],
      itemId: json["itemId"],
      itemName: json["itemName"],
      itemCleanName: json["itemCleanName"],
      imageUrl: json["imageUrl"],
      price: json["price"],
      measure: json["measure"],
      salesStart: json["salesStart"],
      source: json["source"],
      runDate: json["runDate"],
      shopName: json["shopName"],
      isSales: json["isSales"],
      insertType: json["insertType"],
      timeKey: json["timeKey"],
      isSelectedFlag: json["isSelectedFlag"],
      selectedBy: json["selectedBy"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "itemId": itemId,
        "itemName": itemName,
        "itemCleanName": itemCleanName,
        "imageUrl": imageUrl,
        "price": price,
        "measure": measure,
        "salesStart": salesStart,
        "source": source,
        "runDate": runDate,
        "shopName": shopName,
        "isSales": isSales,
        "insertType": insertType,
        "timeKey": timeKey,
        "isSelectedFlag": isSelectedFlag,
        "selectedBy": selectedBy
      };
}
