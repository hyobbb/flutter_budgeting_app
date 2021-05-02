import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseAPI {
  late final Database _db;
  late final List<Map<String, dynamic>> _budgetData;
  late final List<Map<String, dynamic>> _categories;

  static final DatabaseAPI _singleton = DatabaseAPI._internal();

  factory DatabaseAPI() {
    return _singleton;
  }

  DatabaseAPI._internal();

  List<Map<String, dynamic>> get budgetData => _budgetData;

  List<Map<String, dynamic>> get categories => _categories;

  Future<void> init() async {
    var databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'app.db');
    //await deleteDatabase(path);
    _db = await openDatabase(path, version: 1,
        onCreate: (database, version) async {
      await database.execute('CREATE TABLE IF NOT EXISTS category ('
          'id INTEGER PRIMARY KEY, '
          'name TEXT, '
          'color INTEGER)');
      await database.execute('CREATE TABLE IF NOT EXISTS data ('
          'id INTEGER PRIMARY KEY, '
          'type TEXT, '
          'title TEXT, '
          'category_id INTEGER, '
          'value REAL, '
          'date INTEGER, '
          'cash INTEGER, '
          'FOREIGN KEY(category_id) REFERENCES category(id))');
    }, onOpen: (database) async {
      _budgetData = await database.rawQuery(
          'SELECT data.*, category.id as category_id, category.name, category.color '
          'FROM data JOIN category '
          'ON category.id = data.category_id '
          'ORDER BY date ASC');
      _categories = await database.rawQuery('SELECT * FROM category');
    });
  }

  Future<int> create({
    required String table,
    required Map<String, dynamic> value,
  }) async {
    return await _db.insert(table, value).then((value) => value);
  }

  Future<int> update({
    required String table,
    required int id,
    required Map<String, dynamic> value,
  }) async {
    return await _db
        .update(table, value, whereArgs: [id], where: 'id=?')
        .then((value) => value);
  }

  Future<Map<String, dynamic>?> read({
    required String table,
    required String columnName,
    required dynamic columnValue,
  }) async {
    final result = await _db.query(table,
        whereArgs: [columnValue], where: '$columnName = ?');
    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }

  Future<void> delete({required String table, required int id}) async {
    await _db.delete(table, where: 'id=?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>?> query({
    required String sql,
  }) async {
    return await _db.rawQuery(sql).then((value) => value);
  }
}
