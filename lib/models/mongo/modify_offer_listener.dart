// To parse this JSON data, do
//
//     final modifyOfferListener = modifyOfferListenerFromJson(jsonString);

import 'dart:convert';

ModifyOfferListener modifyOfferListenerFromJson(String str) =>
    ModifyOfferListener.fromJson(json.decode(str));

String modifyOfferListenerToJson(ModifyOfferListener data) =>
    json.encode(data.toJson());

class ModifyOfferListener {
  ModifyOfferListener({
    required this.id,
    required this.offerListenerEntityId,
    this.itemCount,
    this.checkFlag,
    this.boolId,
  });

  String id;
  String offerListenerEntityId;
  int? itemCount;
  int? checkFlag;
  int? boolId;

  factory ModifyOfferListener.fromJson(Map<String, dynamic> json) =>
      ModifyOfferListener(
        id: json["id"],
        offerListenerEntityId: json["offerListenerEntityId"],
        itemCount: json["itemCount"],
        checkFlag: json["checkFlag"],
        boolId: json["boolId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "offerListenerEntityId": offerListenerEntityId,
        "itemCount": itemCount,
        "checkFlag": checkFlag,
        "boolId": boolId,
      };
}
