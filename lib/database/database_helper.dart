import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:locate_test/model/database_model.dart';

class DataBaseHelper {
  DataBaseHelper? database;
  Future<Database> initializedDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'mydatabase.db'),
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          "CREATE TABLE mytest(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, konum TEXT NOT NULL,enlem TEXT NOT NULL,boylam TEXT NOT NULL,zaman TEXT NOT NULL)",
        );
      },
    );
  }

  // insert data
  Future<int> insertTable(List<DatabaseModel> planets) async {
    if (database != null) initializedDB();
    int result = 0;
    final Database db = await initializedDB();
    for (var planet in planets) {
      result = await db.insert('mytest', planet.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }

    return result;
  }

  // retrieve data
  Future<List<DatabaseModel>> retrieveTable() async {
    if (database != null) initializedDB();
    final Database db = await initializedDB();
    final List<Map<String, Object?>> queryResult = await db.query('mytest');
    return queryResult.map((e) => DatabaseModel.fromMap(e)).toList();
  }

  // delete user
  Future<void> deleteRow(int id) async {
    if (database != null) initializedDB();
    final db = await initializedDB();
    await db.delete(
      'mytest',
    );
  }
}
