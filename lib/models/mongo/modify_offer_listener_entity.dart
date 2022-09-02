// To parse this JSON data, do
//
//     final modifyShoppingListEntity = modifyShoppingListEntityFromJson(jsonString);

import 'dart:convert';

ModifyOfferListenerEntity modifyShoppingListEntityFromJson(String str) =>
    ModifyOfferListenerEntity.fromJson(json.decode(str));

String modifyShoppingListEntityToJson(ModifyOfferListenerEntity data) =>
    json.encode(data.toJson());

class ModifyOfferListenerEntity {
  ModifyOfferListenerEntity({
    required this.id,
    required this.boolId,
    required this.modDate,
  });

  String id;
  int boolId;
  String modDate;

  factory ModifyOfferListenerEntity.fromJson(Map<String, dynamic> json) =>
      ModifyOfferListenerEntity(
        id: json["id"],
        boolId: json["boolId"],
        modDate: json["modDate"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "boolId": boolId,
        "modDate": modDate,
      };
}
