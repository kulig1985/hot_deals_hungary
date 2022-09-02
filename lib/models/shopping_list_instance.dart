class ShoppingLisInstancetModel {
  final int? shliId;
  final String? listName;
  final String? crDate;

  ShoppingLisInstancetModel({this.shliId, this.listName, this.crDate});

  Map<String, dynamic> toMap() {
    return {'shliId': shliId, 'listName': listName, 'crDate': crDate};
  }
}
