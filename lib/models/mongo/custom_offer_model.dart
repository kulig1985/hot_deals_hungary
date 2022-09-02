import 'dart:convert';

import 'package:hot_deals_hungary/models/mongo/offer.dart';
import 'package:hot_deals_hungary/models/mongo/offer_listener_entity.dart';

List<CustomOfferListenerAndOfferWrapper>
    customOfferListenerAndOfferWrapperFromJson(String str) =>
        List<CustomOfferListenerAndOfferWrapper>.from(json
            .decode(str)
            .map((x) => CustomOfferListenerAndOfferWrapper.fromJson(x)));

String customOfferListenerAndOfferWrapperToJson(
        List<CustomOfferListenerAndOfferWrapper> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CustomOfferListenerAndOfferWrapper {
  CustomOfferListenerAndOfferWrapper({
    required this.offerListenerEntity,
    this.offers,
  });

  OfferListenerEntityOld offerListenerEntity;
  List<OfferOld>? offers;

  factory CustomOfferListenerAndOfferWrapper.fromJson(
          Map<String, dynamic> json) =>
      CustomOfferListenerAndOfferWrapper(
        offerListenerEntity:
            OfferListenerEntityOld.fromJson(json["offerListenerEntity"]),
        offers: List<OfferOld>.from(
            json["offers"].map((x) => OfferOld.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "offerListenerEntity": offerListenerEntity.toJson(),
        "offers": List<dynamic>.from(offers!.map((x) => x.toJson())),
      };
}
