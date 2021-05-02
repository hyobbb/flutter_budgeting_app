import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'model.freezed.dart';

part 'model.g.dart';

///Supported SQLite types
// No validity check is done on values yet so please avoid non supported types https://www.sqlite.org/datatype3.html
//
// DateTime is not a supported SQLite type. Personally I store them as int (millisSinceEpoch) or string (iso8601). SQLite TIMESTAMP type sometimes requires using date functions. TIMESTAMP values are read as String that the application needs to parse.
//
// bool is not a supported SQLite type. Use INTEGER and 0 and 1 values.
//
// INTEGER
// SQLite type: INTEGER
// Dart type: int
// Supported values: from -2^63 to 2^63 - 1
// REAL
// SQLite type: REAL
// Dart type: num
// TEXT
// SQLite type: TEXT
// Dart type: String
// BLOB
// SQLite typ: BLOB
// Dart type: Uint8List

enum BudgetType {
  Income,
  Expense,
}

@freezed
class BudgetData with _$BudgetData {
  const factory BudgetData({
    int? id,
    Category? category,
    bool? cash,
    required BudgetType type,
    required DateTime date,
    required String title,
    required double value,
  }) = _BudgetData;
}

@freezed
class BudgetFilter with _$BudgetFilter {
  const factory BudgetFilter({
    BudgetType? type,
    DateTime? startDate,
    DateTime? endDate,
    List<int?>? categoryID,
    double? lessThan,
    double? moreThan,
    bool? cash,
  }) = _BudgetFilter;
}

@freezed
class Category with _$Category {
  @JsonSerializable(includeIfNull: false)
  const factory Category({
    int? id,
    required String name,
    @Default(0xFFFFFFFF) int color,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
}
