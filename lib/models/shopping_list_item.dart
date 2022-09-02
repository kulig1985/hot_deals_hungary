class ShoppingListItem {
  final int? shitId;
  final int shliId;
  final String oid;
  final String itemName;
  final int price;
  final String shopName;
  final String crDate;

  ShoppingListItem(
      {this.shitId,
      required this.shliId,
      required this.oid,
      required this.itemName,
      required this.price,
      required this.shopName,
      required this.crDate});

  Map<String, dynamic> toMap() {
    return {
      'shitId': shitId,
      'shliId': shliId,
      'oid': oid,
      'itemName': itemName,
      'price': price,
      'shopName': shopName,
      'crDate': crDate
    };
  }
}
