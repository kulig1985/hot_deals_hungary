// To parse this JSON data, do
//
//     final offerCreationDoneEntity = offerCreationDoneEntityFromJson(jsonString);

import 'dart:convert';

OfferCreationDoneEntity offerCreationDoneEntityFromJson(String str) =>
    OfferCreationDoneEntity.fromJson(json.decode(str));

String offerCreationDoneEntityToJson(OfferCreationDoneEntity data) =>
    json.encode(data.toJson());

class OfferCreationDoneEntity {
  OfferCreationDoneEntity({
    required this.id,
  });

  String id;

  factory OfferCreationDoneEntity.fromJson(Map<String, dynamic> json) =>
      OfferCreationDoneEntity(
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}
