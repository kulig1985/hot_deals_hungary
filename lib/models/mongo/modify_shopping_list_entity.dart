// To parse this JSON data, do
//
//     final modifyShoppingListEntity = modifyShoppingListEntityFromJson(jsonString);

import 'dart:convert';

import 'package:hot_deals_hungary/models/mongo/shopping_list_entity.dart';

ModifyShoppingListEntity modifyShoppingListEntityFromJson(String str) =>
    ModifyShoppingListEntity.fromJson(json.decode(str));

String modifyShoppingListEntityToJson(ModifyShoppingListEntity data) =>
    json.encode(data.toJson());

class ModifyShoppingListEntity {
  ModifyShoppingListEntity({
    required this.id,
    this.alloweUidList,
    required this.removeUser,
    this.boolId,
  });

  String id;
  AlloweUidList? alloweUidList;
  String removeUser;
  int? boolId;

  factory ModifyShoppingListEntity.fromJson(Map<String, dynamic> json) =>
      ModifyShoppingListEntity(
        id: json["id"],
        alloweUidList: AlloweUidList.fromJson(json["alloweUidList"]),
        removeUser: json["removeUser"],
        boolId: json["boolId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "alloweUidList": alloweUidList?.toJson(),
        "removeUser": removeUser,
        "boolId": boolId,
      };
}
