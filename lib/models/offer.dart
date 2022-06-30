// To parse this JSON data, do
//
//     final offer = offerFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<Offer> offerFromJson(String str) =>
    List<Offer>.from(json.decode(str).map((x) => Offer.fromJson(x)));

String offerToJson(List<Offer> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Offer {
  Offer({
    required this.id,
    required this.itemId,
    required this.itemName,
    required this.itemCleanName,
    required this.price,
    required this.measure,
    required this.salesStart,
    required this.source,
    required this.runDate,
    required this.shopName,
  });

  Id id;
  dynamic itemId;
  String itemName;
  String itemCleanName;
  dynamic price;
  String measure;
  String salesStart;
  String source;
  String runDate;
  String shopName;

  factory Offer.fromJson(Map<String, dynamic> json) => Offer(
        id: Id.fromJson(json["_id"]),
        itemId: json["itemId"],
        itemName: json["itemName"],
        itemCleanName: json["itemCleanName"],
        price: json["price"],
        measure: json["measure"],
        salesStart: json["salesStart"],
        source: json["source"],
        runDate: json["runDate"],
        shopName: json["shopName"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id.toJson(),
        "itemId": itemId,
        "itemName": itemName,
        "itemCleanName": itemCleanName,
        "price": price,
        "measure": measure,
        "salesStart": salesStart,
        "source": source,
        "runDate": runDate,
        "shopName": shopName,
      };
}

class Id {
  Id({
    required this.oid,
  });

  String oid;

  factory Id.fromJson(Map<String, dynamic> json) => Id(
        oid: json["\u0024oid"],
      );

  Map<String, dynamic> toJson() => {
        "\u0024oid": oid,
      };
}
