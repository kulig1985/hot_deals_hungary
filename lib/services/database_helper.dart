import 'package:hot_deals_hungary/models/item.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseHelper {
  Future<Database> dataBase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'shoping_item.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE ITEM (id INTEGER PRIMARY KEY, itemName TEXT)');
      },
      version: 1,
    );
  }

  Future<void> insertItem(Item item) async {
    Database _db = await dataBase();

    await _db.insert('ITEM', item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Item>> getAllItem() async {
    Database _db = await dataBase();

    List<Map<String, dynamic>> itemMap = await _db.query('ITEM');
    return List.generate(itemMap.length, (index) {
      return Item(
          id: itemMap[index]['id'], itemName: itemMap[index]['itemName']);
    });
  }

  Future<void> deleteTask(int itemId) async {
    Database _db = await dataBase();
    await _db.rawDelete("DELETE FROM ITEM WHERE id = '$itemId'");
  }
}
