class OfferListenerItem {
  final int? ofitId;
  final String itemName;
  final String? crDate;

  OfferListenerItem({this.ofitId, required this.itemName, this.crDate});

  Map<String, dynamic> toMap() {
    return {'ofitId': ofitId, 'itemName': itemName, 'crDate': crDate};
  }
}
