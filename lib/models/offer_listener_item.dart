class OfferListenerItem {
  final int? id;
  final String itemName;

  OfferListenerItem({this.id, required this.itemName});

  Map<String, dynamic> toMap() {
    return {'id': id, 'itemName': itemName};
  }
}
