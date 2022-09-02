// To parse this JSON data, do
//
//     final shoppingListCreationDoneEntity = shoppingListCreationDoneEntityFromJson(jsonString);

import 'dart:convert';

ShoppingListCreationDoneEntity shoppingListCreationDoneEntityFromJson(
        String str) =>
    ShoppingListCreationDoneEntity.fromJson(json.decode(str));

String shoppingListCreationDoneEntityToJson(
        ShoppingListCreationDoneEntity data) =>
    json.encode(data.toJson());

class ShoppingListCreationDoneEntity {
  ShoppingListCreationDoneEntity({
    required this.id,
  });

  String id;

  factory ShoppingListCreationDoneEntity.fromJson(Map<String, dynamic> json) =>
      ShoppingListCreationDoneEntity(
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}
