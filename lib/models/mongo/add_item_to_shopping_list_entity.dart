// To parse this JSON data, do
//
//     final addItemToShoppingListEntity = addItemToShoppingListEntityFromJson(jsonString);

import 'dart:convert';

import 'package:hot_deals_hungary/models/mongo/shopping_list_entity.dart';

String addItemToShoppingListEntityToJson(AddItemToShoppingListEntity data) =>
    json.encode(data.toJson());

class AddItemToShoppingListEntity {
  AddItemToShoppingListEntity({
    required this.id,
    required this.newItem,
  });

  String id;
  ItemList newItem;

  Map<String, dynamic> toJson() => {
        "id": id.toString(),
        "newItem": newItem.toJson(),
      };
}
