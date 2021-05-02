import 'package:budgeting/src/model/model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final editingData = StateNotifierProvider.autoDispose
    .family<EditingDataNotifier, BudgetData>(
        (ref, data) => EditingDataNotifier(data));

class EditingDataNotifier extends StateNotifier<BudgetData> {
  EditingDataNotifier(data) : super(data);

  void setCategory(Category? category) {
    state = state.copyWith(category: category);
  }

  void setDate(DateTime date) {
    state = state.copyWith(date: date);
  }

  void setTitle(String title) {
    state = state.copyWith(title: title);
  }

  void setValue(String value) {
    if (double.tryParse(value) != null) {
      state = state.copyWith(value: double.parse(value));
    } else {
      state = state.copyWith(value: 0.0);
    }
  }

  bool isValid() {
    return (state.title.isNotEmpty && state.value != 0.0);
  }

  void onDeleteCategory(Category cat) {
    if (state.category == cat) {
      state = state.copyWith(category: null);
    }
  }

  void setIfCash(bool cash) {
    state = state.copyWith(cash: cash);
  }
}

