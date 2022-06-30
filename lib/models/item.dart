class Item {
  final int? id;
  final String itemName;

  Item({this.id, required this.itemName});

  Map<String, dynamic> toMap() {
    return {'id': id, 'itemName': itemName};
  }
}
