// To parse this JSON data, do
//
//     final changeOfferOnOfferListener = changeOfferOnOfferListenerFromJson(jsonString);

import 'dart:convert';

import 'package:hot_deals_hungary/models/mongo/shopping_list_complex_model.dart';

ChangeOfferOnOfferListener changeOfferOnOfferListenerFromJson(String str) =>
    ChangeOfferOnOfferListener.fromJson(json.decode(str));

String changeOfferOnOfferListenerToJson(ChangeOfferOnOfferListener data) =>
    json.encode(data.toJson());

class ChangeOfferOnOfferListener {
  ChangeOfferOnOfferListener({
    required this.id,
    required this.offerListenerId,
    required this.offer,
  });

  String id;
  String offerListenerId;
  Offer offer;

  factory ChangeOfferOnOfferListener.fromJson(Map<String, dynamic> json) =>
      ChangeOfferOnOfferListener(
        id: json["id"],
        offerListenerId: json["offerListenerId"],
        offer: Offer.fromJson(json["offer"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "offerListenerId": offerListenerId,
        "offer": offer.toJson(),
      };
}
