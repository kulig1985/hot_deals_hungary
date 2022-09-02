// To parse this JSON data, do
//
//     final shoppingListEntity = shoppingListEntityFromJson(jsonString);

import 'dart:convert';

List<ShoppingListEntity> shoppingListEntityFromJson(String str) =>
    List<ShoppingListEntity>.from(
        json.decode(str).map((x) => ShoppingListEntity.fromJson(x)));

String shoppingListEntityToJson(List<ShoppingListEntity> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ShoppingListEntity {
  ShoppingListEntity(
      {this.id,
      required this.listName,
      required this.alloweUidList,
      required this.itemList,
      required this.crDate,
      required this.modDate,
      required this.boolId,
      required this.imageColorIndex});

  SlId? id;
  String listName;
  List<AlloweUidList> alloweUidList;
  List<ItemList> itemList;
  String crDate;
  String modDate;
  int boolId;
  int imageColorIndex;

  factory ShoppingListEntity.fromJson(Map<String, dynamic> json) =>
      ShoppingListEntity(
          id: SlId.fromJson(json["_id"]),
          listName: json["listName"],
          alloweUidList: List<AlloweUidList>.from(
              json["alloweUidList"].map((x) => AlloweUidList.fromJson(x))),
          itemList: List<ItemList>.from(
              json["itemList"].map((x) => ItemList.fromJson(x))),
          crDate: json["crDate"],
          modDate: json["modDate"],
          boolId: json["boolId"],
          imageColorIndex: json["imageColorIndex"]);

  Map<String, dynamic> toJson() => {
        "_id": id?.toJson(),
        "listName": listName,
        "alloweUidList":
            List<dynamic>.from(alloweUidList.map((x) => x.toJson())),
        "itemList": List<dynamic>.from(itemList.map((x) => x.toJson())),
        "crDate": crDate,
        "modDate": modDate,
        "boolId": boolId,
        "imageColorIndex": imageColorIndex
      };
}

class AlloweUidList {
  AlloweUidList({
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

  factory AlloweUidList.fromJson(Map<String, dynamic> json) => AlloweUidList(
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

class SlId {
  SlId({
    required this.oid,
  });

  String oid;

  factory SlId.fromJson(Map<String, dynamic> json) => SlId(
        oid: json["\u0024oid"],
      );

  Map<String, dynamic> toJson() => {
        "\u0024oid": oid,
      };
}

class ItemList {
  ItemList({
    required this.itemDetail,
    required this.crDate,
    required this.checkFlag,
    required this.boolId,
    required this.volume,
    this.modDate,
  });

  ItemDetail itemDetail;
  String crDate;
  int checkFlag;
  int boolId;
  int volume;
  String? modDate;

  factory ItemList.fromJson(Map<String, dynamic> json) => ItemList(
        itemDetail: ItemDetail.fromJson(json["itemDetail"]),
        crDate: json["crDate"],
        checkFlag: json["checkFlag"],
        boolId: json["boolId"],
        volume: json["volume"],
        modDate: json["modDate"],
      );

  Map<String, dynamic> toJson() => {
        "itemDetail": itemDetail.toJson(),
        "crDate": crDate,
        "checkFlag": checkFlag,
        "boolId": boolId,
        "volume": volume,
        "modDate": modDate,
      };
}

class ItemDetail {
  ItemDetail({
    required this.offerCollectionId,
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
    required this.timeKey,
  });

  String offerCollectionId;
  dynamic? itemId;
  String itemName;
  String itemCleanName;
  String imageUrl;
  int price;
  String measure;
  String salesStart;
  String source;
  String runDate;
  String shopName;
  String timeKey;

  factory ItemDetail.fromJson(Map<String, dynamic> json) => ItemDetail(
        offerCollectionId: json["offerCollectionId"],
        itemId: json["itemId"].toString(),
        itemName: json["itemName"],
        itemCleanName: json["itemCleanName"],
        imageUrl: json["imageUrl"],
        price: json["price"],
        measure: json["measure"],
        salesStart: json["salesStart"],
        source: json["source"],
        runDate: json["runDate"],
        shopName: json["shopName"],
        timeKey: json["timeKey"],
      );

  Map<String, dynamic> toJson() => {
        "offerCollectionId": offerCollectionId,
        "itemId": itemId.toString(),
        "itemName": itemName,
        "itemCleanName": itemCleanName,
        "imageUrl": imageUrl,
        "price": price,
        "measure": measure,
        "salesStart": salesStart,
        "source": source,
        "runDate": runDate,
        "shopName": shopName,
        "timeKey": timeKey,
      };
}
