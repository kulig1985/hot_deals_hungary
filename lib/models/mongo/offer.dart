// To parse this JSON data, do
//
//     final offer = offerFromJson(jsonString);

import 'dart:convert';

List<OfferOld> offerOldFromJson(String str) =>
    List<OfferOld>.from(json.decode(str).map((x) => OfferOld.fromJson(x)));

String offerOldToJson(List<OfferOld> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OfferOld {
  OfferOld({
    required this.id,
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
    required this.insertType,
  });

  IdOf id;
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
  String timeKey;
  String insertType;

  factory OfferOld.fromJson(Map<String, dynamic> json) => OfferOld(
      id: IdOf.fromJson(json["_id"]),
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
      timeKey: json["timeKey"],
      insertType: json["insertType"]);

  Map<String, dynamic> toJson() => {
        "_id": id.toJson(),
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
        "timeKey": timeKey,
        "insertType": insertType
      };
}

class IdOf {
  IdOf({
    required this.oid,
  });

  String oid;

  factory IdOf.fromJson(Map<String, dynamic> json) => IdOf(
        oid: json["\u0024oid"],
      );

  Map<String, dynamic> toJson() => {
        "\u0024oid": oid,
      };
}
