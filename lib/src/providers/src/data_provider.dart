import 'package:budgeting/src/model/model.dart';
import 'package:budgeting/src/service/budget_function.dart';
import 'package:budgeting/src/service/db_api.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final budgetListCache = StateNotifierProvider<BudgetListCache>(
  (ref) => BudgetListCache(
      DatabaseAPI().budgetData.map((e) => BudgetFunction.fromJson(e)).toList()),
);

final categoryListCache = StateNotifierProvider<CategoryListCache>((ref) {
  return CategoryListCache(
      DatabaseAPI().categories.map((e) => Category.fromJson(e)).toList());
});

class BudgetListCache extends StateNotifier<List<BudgetData>> {
  BudgetListCache(List<BudgetData> state) : super(state);

  final api = DatabaseAPI();
  static const table = DatabaseAPI.budget;

  DateTime get firstDate => state.isEmpty ? DateTime.now() : state.last.date;

  DateTime get lastDate => state.isEmpty ? DateTime.now() : state.first.date;

  Future<void> update(BudgetData data) async {
    if (data.id == null) {
      await api
          .create(table: table, value: BudgetFunction.toJson(data))
          .then((value) => data = data.copyWith(id: value));
      state = [...state, data]..sort((a, b) => b.date.compareTo(a.date));
    } else {
      await api.update(
          table: table, id: data.id!, value: BudgetFunction.toJson(data));
      state = state.map((e) => e.id == data.id ? data : e).toList();
    }
  }

  Future<void> remove(int id) async {
    await api.delete(table: table, id: id);
    state.removeWhere((element) => element.id == id);
  }

  void onCategoryDeleted(int catID) {
    state = state.map((e) {
      if (e.category?.id == catID) {
        api.update(
            table: table,
            id: e.id!,
            value: BudgetFunction.toJson(e.copyWith(category: null)));
        return e.copyWith(category: null);
      }
      return e;
    }).toList();
  }

  void onCategoryUpdated(Category category) {
    state = state.map((e) {
      if (e.category?.id == category.id) {
        api.update(
            table: table,
            id: e.id!,
            value: BudgetFunction.toJson(e.copyWith(category: category)));
        return e.copyWith(category: category);
      }
      return e;
    }).toList();
  }

  void onImportCsv() {
    state = DatabaseAPI()
        .budgetData
        .map((e) => BudgetFunction.fromJson(e))
        .toList();
  }
}

class CategoryListCache extends StateNotifier<List<Category>> {
  final api = DatabaseAPI();
  static const table = DatabaseAPI.category;

  CategoryListCache(List<Category> state) : super(state);

  Future<bool> _sanityCheck(Category category) async {
    if (category.id != null) {
      return false;
    }

    final result = await api.read(
        table: table, columnName: 'name', columnValue: category.name);

    return result == null;
  }

  Future<Category> create(Category category) async {
    if (await _sanityCheck(category)) {
      final newId = await api.create(table: table, value: category.toJson());
      category = category.copyWith(id: newId);
      state = [...state, category];
      return category;
    } else {
      throw Exception('This Category Is Already Exists');
    }
  }

  Future<void> update(Category category) async {
    await api.update(table: table, id: category.id!, value: category.toJson());
    state = state.map((e) => e.id == category.id ? category : e).toList();
  }

  Future<void> remove(int id) async {
    await api.delete(table: table, id: id);
    state = state.where((element) => element.id != id).toList();
  }

  Category getCategory(String name) {
    return state.firstWhere((element) => element.name == name);
  }

  void onImportCsv() {
    state = DatabaseAPI().categories.map((e) => Category.fromJson(e)).toList();
  }
}
