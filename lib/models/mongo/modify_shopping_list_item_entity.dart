// To parse this JSON data, do
//
//     final modifyShoppingListItemEntity = modifyShoppingListItemEntityFromJson(jsonString);

import 'dart:convert';

ModifyShoppingListItemEntity modifyShoppingListItemEntityFromJson(String str) =>
    ModifyShoppingListItemEntity.fromJson(json.decode(str));

String modifyShoppingListItemEntityToJson(ModifyShoppingListItemEntity data) =>
    json.encode(data.toJson());

class ModifyShoppingListItemEntity {
  ModifyShoppingListItemEntity({
    required this.id,
    required this.offerCollectionId,
    this.volume,
    this.modDate,
    this.crDate,
    this.checkFlag,
    this.boolId,
  });
  String id;
  String offerCollectionId;
  int? volume;
  String? modDate;
  String? crDate;
  int? checkFlag;
  int? boolId;

  factory ModifyShoppingListItemEntity.fromJson(Map<String, dynamic> json) =>
      ModifyShoppingListItemEntity(
        id: json["id"],
        offerCollectionId: json["offerCollectionId"],
        volume: json["volume"],
        modDate: json["modDate"],
        crDate: json["crDate"],
        checkFlag: json["checkFlag"],
        boolId: json["boolId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "offerCollectionId": offerCollectionId,
        "volume": volume,
        "modDate": modDate,
        "crDate": crDate,
        "checkFlag": checkFlag,
        "boolId": boolId,
      };
}
