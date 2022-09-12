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
  ModifyShoppingListEntity(
      {required this.id,
      this.alloweUidList,
      required this.operationName,
      this.boolId,
      this.listName,
      this.modDate});

  String id;
  AlloweUidList? alloweUidList;
  String operationName;
  int? boolId;
  String? listName;
  String? modDate;

  factory ModifyShoppingListEntity.fromJson(Map<String, dynamic> json) =>
      ModifyShoppingListEntity(
          id: json["id"],
          alloweUidList: AlloweUidList.fromJson(json["alloweUidList"]),
          operationName: json["operationName"],
          boolId: json["boolId"],
          listName: json["listName"],
          modDate: json["modDate"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "alloweUidList": alloweUidList?.toJson(),
        "operationName": operationName,
        "boolId": boolId,
        "listName": listName,
        "modDate": modDate
      };
}
