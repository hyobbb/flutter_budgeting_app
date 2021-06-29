import 'dart:io';
import 'package:budgeting/src/model/model.dart';
import 'package:budgeting/src/service/budget_function.dart';
import 'package:budgeting/src/service/csv_util.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseAPI {
  late final Database _db;
  List<Map<String, dynamic>> _budgetData = [];
  List<Map<String, dynamic>> _categories = [];
  static const budget = 'budget';
  static const category = 'category';

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
      await database.execute('CREATE TABLE $category ('
          'id INTEGER PRIMARY KEY, '
          'name TEXT, '
          'color INTEGER)');
      await database.execute('CREATE TABLE $budget ('
          'id INTEGER PRIMARY KEY, '
          'type TEXT, '
          'title TEXT, '
          'category_id INTEGER, '
          'value REAL, '
          'date INTEGER, '
          'cash INTEGER, '
          'FOREIGN KEY(category_id) REFERENCES $category(id))');
    }, onOpen: (database) async {
          await database.execute('CREATE TABLE IF NOT EXISTS $category ('
              'id INTEGER PRIMARY KEY, '
              'name TEXT, '
              'color INTEGER)');
          await database.execute('CREATE TABLE IF NOT EXISTS $budget ('
              'id INTEGER PRIMARY KEY, '
              'type TEXT, '
              'title TEXT, '
              'category_id INTEGER, '
              'value REAL, '
              'date INTEGER, '
              'cash INTEGER, '
              'FOREIGN KEY(category_id) REFERENCES $category(id))');
      _budgetData = await database.rawQuery(
          'SELECT $budget.*, $category.id as category_id, $category.name, $category.color '
          'FROM $budget JOIN $category '
          'ON $category.id = $budget.category_id '
          'ORDER BY date DESC');
      _categories = await database.rawQuery('SELECT * FROM $category');
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

  Future<File> budgetToCsv() async {
    final data = await _db.rawQuery(
        'SELECT $budget.*, $category.id as category_id, $category.name, $category.color '
            'FROM $budget JOIN $category '
            'ON $category.id = $budget.category_id '
            'ORDER BY date DESC');

    var csv = mapListToCsv(data) ?? '';
    var dir = await getApplicationDocumentsDirectory();
    var path = '${dir.path}/$budget.csv';
    var file = File(path);
    file = await file.writeAsString(csv);
    return file;
  }

  Future<File> categoryToCsv() async {
    final data = await _db.rawQuery('SELECT * FROM category');
    var csv = mapListToCsv(data) ?? '';
    var dir = await getApplicationDocumentsDirectory();
    var path = '${dir.path}/$category.csv';
    var file = File(path);
    file = await file.writeAsString(csv);
    return file;
  }

  Future<void> importCsv(File file) async {
    final table = basenameWithoutExtension(file.path);
    final csv = await file.readAsString();
    final data = csvToMap(csv);

    if (table == category) {
      await writeBatchCategory(data);
    } else {
      await writeBatchBudget(data);
    }
  }

  Future<void> writeBatchBudget(List<Map<String, dynamic>> data) async {
    await _db.delete(budget);
    final batch = _db.batch();
    data
        .map((e) => BudgetFunction.fromJson(e))
        .forEach((e) => batch.insert(budget, BudgetFunction.toJson(e)));
    await batch.commit(noResult: true);
    _budgetData = await _db.rawQuery(
        'SELECT $budget.*, $category.id as category_id, $category.name, $category.color '
            'FROM $budget JOIN $category '
            'ON $category.id = $budget.category_id '
            'ORDER BY date DESC');
  }

  Future<void> writeBatchCategory(List<Map<String, dynamic>> data) async {
    await _db.delete(category);
    _categories = await _db.rawQuery('SELECT * FROM $category');

    final batch = _db.batch();
    data
        .map((e) => Category.fromJson(e))
        .forEach((cat) => batch.insert(category, cat.toJson()));
    await batch.commit(noResult: true);
    _categories = await _db.rawQuery('SELECT * FROM $category');
  }
}
