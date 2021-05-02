import 'package:budgeting/src/model/model.dart';
import 'package:budgeting/src/providers/providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final incomeFilterProvider = StateNotifierProvider(
    (ref) => FilterNotifier(const BudgetFilter(type: BudgetType.Income)));

final expenseFilterProvider = StateNotifierProvider(
    (ref) => FilterNotifier(const BudgetFilter(type: BudgetType.Expense)));

final balanceFilterProvider =
    StateNotifierProvider((ref) => FilterNotifier(const BudgetFilter()));

class FilterNotifier extends StateNotifier<BudgetFilter> {
  FilterNotifier(BudgetFilter state) : super(state);

  void setDate({DateTime? start, end}) {
    state = state.copyWith(startDate: start, endDate: end);
  }

  void setPrice({double? start, end}) {
    state = state.copyWith(lessThan: end, moreThan: start);
  }

  void excludeCategory(Category? cat) {
    if (state.categoryID == null) {
      state = state.copyWith(categoryID: [cat?.id]);
    } else {
      state = state.copyWith(categoryID: [...state.categoryID!, cat?.id]);
    }
  }

  void includeCategory(Category? cat) {
    if (state.categoryID != null) {
      final result = state.categoryID!.where((id) => id != cat?.id).toList();
      state = state.copyWith(categoryID: result);
    }
  }

  bool included(Category? category) {
    if (state.categoryID == null) {
      return true;
    }

    if (category == null) {
      return !state.categoryID!.contains(null);
    }
    return !state.categoryID!.contains(category.id);
  }

  void setIfCash(bool? cash) {
    state = state.copyWith(cash: cash);
  }

  void setFilter(BudgetFilter filter) {
    state = filter;
  }

  void reset(BudgetType? type) {
    state = BudgetFilter(type: type);
  }
}
