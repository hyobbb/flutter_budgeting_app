import 'package:budgeting/src/model/model.dart';
import 'package:budgeting/src/service/date_handler.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class BudgetFunction {
  /// collection of pure functions to handle BudgetData

  static List<BudgetData> applyFilter(
      {required List<BudgetData> data, required BudgetFilter filter}) {
    if (filter.type != null) {
      data = data.where((element) => element.type == filter.type).toList();
    }

    if (filter.startDate != null) {
      data = data
          .where((element) =>
              element.date.isAfter(filter.startDate!) ||
              element.date.isAtSameMomentAs(filter.startDate!))
          .toList();
    }

    if (filter.endDate != null) {
      data = data
          .where((element) =>
              element.date.isBefore(filter.endDate!) ||
              element.date.isAtSameMomentAs(filter.startDate!))
          .toList();
    }

    if (filter.categoryID != null && filter.categoryID!.isNotEmpty) {
      data = data
          .where(
              (element) => !filter.categoryID!.contains(element.category?.id))
          .toList();
    }

    if (filter.lessThan != null) {
      data = data.where((element) => element.value < filter.lessThan!).toList();
    }

    if (filter.moreThan != null) {
      data = data.where((element) => element.value > filter.moreThan!).toList();
    }

    if(filter.cash!=null){
      data = data.where((element) => element.cash == filter.cash).toList();
    }

    return data;
  }

  static double sum(List<BudgetData> dataList) {
    var result = 0.0;
    dataList.forEach((element) {
      result += element.value;
    });
    return result;
  }

  static Map<Category?, List<BudgetData>> groupByCategory(
      List<BudgetData> dataList) {
    return groupBy(dataList, (BudgetData data) => data.category);
  }

  static Map<bool?, List<BudgetData>> groupByCashUse(
      List<BudgetData> dataList) {
    return groupBy(dataList, (BudgetData data) => data.cash);
  }

  static Map<BudgetType, List<BudgetData>> groupByType(
      List<BudgetData> dataList) {
    return groupBy(dataList, (BudgetData data) => data.type);
  }

  static BudgetData fromJson(Map<String, dynamic> data) {
    return BudgetData(
      type: data['type'] == 'income' ? BudgetType.Income : BudgetType.Expense,
      id: data['id'],
      category: Category(
          id: data['category_id'], name: data['name'], color: data['color']),
      date: DateTime.parse(data['date'].toString()),
      cash: data['cash'] == null ? null : data['cash'] == 1,
      title: data['title'],
      value: data['value'],
    );
  }

  static Map<String, dynamic> toJson(BudgetData data) {
    final json = <String, dynamic>{};
    if (data.category != null) {
      json['category_id'] = data.category!.id;
    }

    if (data.type == BudgetType.Income) {
      json['type'] = 'income';
    } else {
      json['type'] = 'expense';
    }

    if (data.cash != null) {
      json['cash'] = data.cash! ? 1 : 0;
    }
    json['date'] = DateHandler.toInt(data.date);
    json['title'] = data.title;
    json['value'] = data.value;
    return json;
  }
}
