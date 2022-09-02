import 'package:hot_deals_hungary/models/mongo/offer.dart';
import 'package:hot_deals_hungary/models/offer_listener_item.dart';
import 'package:hot_deals_hungary/models/shopping_list_item.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseHelper {
  Future<Database> dataBase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'hot_deals_v7.db'),
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE OFFER_LISTENER (ofitId INTEGER PRIMARY KEY AUTOINCREMENT, itemName TEXT, crDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP, boolId INTEGER DEFAULT 1)');
        await db.execute(
            'CREATE TABLE SHOPPING_LIST_INSTANCE (shliId INTEGER PRIMARY KEY AUTOINCREMENT, listName TEXT, crDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP, boolId INTEGER DEFAULT 1)');
        return await db.execute(
            'CREATE TABLE SHOPPING_LIST_ITEM (offerId INTEGER PRIMARY KEY AUTOINCREMENT, shliId INTEGER, oid TEXT, itemName TEXT, itemCleanName TEXT, imageUrl TEXT, price INTEGER, measure TEXT, salesStart TEXT, source TEXT, runDate TEXT, shopName TEXT, crDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP, boolId INTEGER DEFAULT 1)');
      },
      version: 1,
    );
  }

  Future<void> insertOfferListenerItem(
      OfferListenerItem offerListenerItem) async {
    Database _db = await dataBase();

    await _db.insert('OFFER_LISTENER', offerListenerItem.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertOfferToShopingList(ShoppingListItem offer) async {
    Database _db = await dataBase();

    await _db.insert('SHOPPING_LIST_ITEM', offer.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<OfferListenerItem>> getAllOfferListenerItem() async {
    Database _db = await dataBase();
    print("getAllItem invoked!");
    List<Map<String, dynamic>> itemMap = await _db.query('OFFER_LISTENER');
    return List.generate(itemMap.length, (index) {
      print(itemMap[index]);
      return OfferListenerItem(
          ofitId: itemMap[index]['ofitId'],
          itemName: itemMap[index]['itemName'],
          crDate: itemMap[index]['crDate']);
    });
  }

  Future<List<ShoppingListItem>> getAllShoppingListItem(String shliId) async {
    Database _db = await dataBase();
    print("getAllShoppingListItem invoked!");
    List<Map<String, dynamic>> itemMap = await _db.query('OFFER');
    return List.generate(itemMap.length, (index) {
      print(itemMap[index]);
      return ShoppingListItem(
          shitId: itemMap[index]['shitId'],
          shliId: itemMap[index]['shliId'],
          oid: itemMap[index]['shliId'],
          itemName: itemMap[index]['itemName'],
          price: itemMap[index]['price'],
          shopName: itemMap[index]['shopName'],
          crDate: itemMap[index]['crDate']);
    });
  }

  Future<void> deleteOfferListenerItem(int itemId) async {
    Database _db = await dataBase();
    print("deleteTask invoked with itemId: $itemId");
    await _db.rawDelete("DELETE FROM OFFER_LISTENER WHERE ofitId = '$itemId'");
  }
}
