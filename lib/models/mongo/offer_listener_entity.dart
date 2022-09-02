// To parse this JSON data, do
//
//     final offerListenerEntity = offerListenerEntityFromJson(jsonString);

import 'dart:convert';

List<OfferListenerEntityOld> offerListenerEntityOldFromJson(String str) =>
    List<OfferListenerEntityOld>.from(
        json.decode(str).map((x) => OfferListenerEntityOld.fromJson(x)));

String offerListenerEntityOldToJson(List<OfferListenerEntityOld> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OfferListenerEntityOld {
  OfferListenerEntityOld(
      {this.id,
      required this.uid,
      required this.itemName,
      required this.crDate,
      required this.boolId,
      this.modDate,
      required this.imageColorIndex});

  Id? id;
  String uid;
  String itemName;
  String crDate;
  int boolId;
  String? modDate;
  int imageColorIndex;

  factory OfferListenerEntityOld.fromJson(Map<String, dynamic> json) =>
      OfferListenerEntityOld(
          id: Id.fromJson(json["_id"]),
          uid: json["uid"],
          itemName: json["itemName"],
          crDate: json["crDate"],
          boolId: json["boolId"],
          modDate: json["modDate"] == null ? null : json["modDate"],
          imageColorIndex: json["imageColorIndex"]);

  Map<String, dynamic> toJson() => {
        "_id": id?.toJson(),
        "uid": uid,
        "itemName": itemName,
        "crDate": crDate,
        "boolId": boolId,
        "modDate": modDate == null ? null : modDate,
        "imageColorIndex": imageColorIndex
      };
}

class Id {
  Id({
    this.oid,
  });

  String? oid;

  factory Id.fromJson(Map<String, dynamic> json) => Id(
        oid: json["\u0024oid"],
      );

  Map<String, dynamic> toJson() => {
        "\u0024oid": oid,
      };
}
