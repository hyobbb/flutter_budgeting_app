// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$BudgetDataTearOff {
  const _$BudgetDataTearOff();

  _BudgetData call(
      {int? id,
      Category? category,
      bool? cash,
      required BudgetType type,
      required DateTime date,
      required String title,
      required double value}) {
    return _BudgetData(
      id: id,
      category: category,
      cash: cash,
      type: type,
      date: date,
      title: title,
      value: value,
    );
  }
}

/// @nodoc
const $BudgetData = _$BudgetDataTearOff();

/// @nodoc
mixin _$BudgetData {
  int? get id => throw _privateConstructorUsedError;
  Category? get category => throw _privateConstructorUsedError;
  bool? get cash => throw _privateConstructorUsedError;
  BudgetType get type => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  double get value => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BudgetDataCopyWith<BudgetData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BudgetDataCopyWith<$Res> {
  factory $BudgetDataCopyWith(
          BudgetData value, $Res Function(BudgetData) then) =
      _$BudgetDataCopyWithImpl<$Res>;
  $Res call(
      {int? id,
      Category? category,
      bool? cash,
      BudgetType type,
      DateTime date,
      String title,
      double value});

  $CategoryCopyWith<$Res>? get category;
}

/// @nodoc
class _$BudgetDataCopyWithImpl<$Res> implements $BudgetDataCopyWith<$Res> {
  _$BudgetDataCopyWithImpl(this._value, this._then);

  final BudgetData _value;
  // ignore: unused_field
  final $Res Function(BudgetData) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? category = freezed,
    Object? cash = freezed,
    Object? type = freezed,
    Object? date = freezed,
    Object? title = freezed,
    Object? value = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      category: category == freezed
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as Category?,
      cash: cash == freezed
          ? _value.cash
          : cash // ignore: cast_nullable_to_non_nullable
              as bool?,
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as BudgetType,
      date: date == freezed
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      value: value == freezed
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }

  @override
  $CategoryCopyWith<$Res>? get category {
    if (_value.category == null) {
      return null;
    }

    return $CategoryCopyWith<$Res>(_value.category!, (value) {
      return _then(_value.copyWith(category: value));
    });
  }
}

/// @nodoc
abstract class _$BudgetDataCopyWith<$Res> implements $BudgetDataCopyWith<$Res> {
  factory _$BudgetDataCopyWith(
          _BudgetData value, $Res Function(_BudgetData) then) =
      __$BudgetDataCopyWithImpl<$Res>;
  @override
  $Res call(
      {int? id,
      Category? category,
      bool? cash,
      BudgetType type,
      DateTime date,
      String title,
      double value});

  @override
  $CategoryCopyWith<$Res>? get category;
}

/// @nodoc
class __$BudgetDataCopyWithImpl<$Res> extends _$BudgetDataCopyWithImpl<$Res>
    implements _$BudgetDataCopyWith<$Res> {
  __$BudgetDataCopyWithImpl(
      _BudgetData _value, $Res Function(_BudgetData) _then)
      : super(_value, (v) => _then(v as _BudgetData));

  @override
  _BudgetData get _value => super._value as _BudgetData;

  @override
  $Res call({
    Object? id = freezed,
    Object? category = freezed,
    Object? cash = freezed,
    Object? type = freezed,
    Object? date = freezed,
    Object? title = freezed,
    Object? value = freezed,
  }) {
    return _then(_BudgetData(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      category: category == freezed
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as Category?,
      cash: cash == freezed
          ? _value.cash
          : cash // ignore: cast_nullable_to_non_nullable
              as bool?,
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as BudgetType,
      date: date == freezed
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      value: value == freezed
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
class _$_BudgetData implements _BudgetData {
  const _$_BudgetData(
      {this.id,
      this.category,
      this.cash,
      required this.type,
      required this.date,
      required this.title,
      required this.value});

  @override
  final int? id;
  @override
  final Category? category;
  @override
  final bool? cash;
  @override
  final BudgetType type;
  @override
  final DateTime date;
  @override
  final String title;
  @override
  final double value;

  @override
  String toString() {
    return 'BudgetData(id: $id, category: $category, cash: $cash, type: $type, date: $date, title: $title, value: $value)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _BudgetData &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.category, category) ||
                const DeepCollectionEquality()
                    .equals(other.category, category)) &&
            (identical(other.cash, cash) ||
                const DeepCollectionEquality().equals(other.cash, cash)) &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)) &&
            (identical(other.date, date) ||
                const DeepCollectionEquality().equals(other.date, date)) &&
            (identical(other.title, title) ||
                const DeepCollectionEquality().equals(other.title, title)) &&
            (identical(other.value, value) ||
                const DeepCollectionEquality().equals(other.value, value)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(category) ^
      const DeepCollectionEquality().hash(cash) ^
      const DeepCollectionEquality().hash(type) ^
      const DeepCollectionEquality().hash(date) ^
      const DeepCollectionEquality().hash(title) ^
      const DeepCollectionEquality().hash(value);

  @JsonKey(ignore: true)
  @override
  _$BudgetDataCopyWith<_BudgetData> get copyWith =>
      __$BudgetDataCopyWithImpl<_BudgetData>(this, _$identity);
}

abstract class _BudgetData implements BudgetData {
  const factory _BudgetData(
      {int? id,
      Category? category,
      bool? cash,
      required BudgetType type,
      required DateTime date,
      required String title,
      required double value}) = _$_BudgetData;

  @override
  int? get id => throw _privateConstructorUsedError;
  @override
  Category? get category => throw _privateConstructorUsedError;
  @override
  bool? get cash => throw _privateConstructorUsedError;
  @override
  BudgetType get type => throw _privateConstructorUsedError;
  @override
  DateTime get date => throw _privateConstructorUsedError;
  @override
  String get title => throw _privateConstructorUsedError;
  @override
  double get value => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$BudgetDataCopyWith<_BudgetData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
class _$BudgetFilterTearOff {
  const _$BudgetFilterTearOff();

  _BudgetFilter call(
      {BudgetType? type,
      DateTime? startDate,
      DateTime? endDate,
      List<int?>? categoryID,
      double? lessThan,
      double? moreThan,
      bool? cash}) {
    return _BudgetFilter(
      type: type,
      startDate: startDate,
      endDate: endDate,
      categoryID: categoryID,
      lessThan: lessThan,
      moreThan: moreThan,
      cash: cash,
    );
  }
}

/// @nodoc
const $BudgetFilter = _$BudgetFilterTearOff();

/// @nodoc
mixin _$BudgetFilter {
  BudgetType? get type => throw _privateConstructorUsedError;
  DateTime? get startDate => throw _privateConstructorUsedError;
  DateTime? get endDate => throw _privateConstructorUsedError;
  List<int?>? get categoryID => throw _privateConstructorUsedError;
  double? get lessThan => throw _privateConstructorUsedError;
  double? get moreThan => throw _privateConstructorUsedError;
  bool? get cash => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BudgetFilterCopyWith<BudgetFilter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BudgetFilterCopyWith<$Res> {
  factory $BudgetFilterCopyWith(
          BudgetFilter value, $Res Function(BudgetFilter) then) =
      _$BudgetFilterCopyWithImpl<$Res>;
  $Res call(
      {BudgetType? type,
      DateTime? startDate,
      DateTime? endDate,
      List<int?>? categoryID,
      double? lessThan,
      double? moreThan,
      bool? cash});
}

/// @nodoc
class _$BudgetFilterCopyWithImpl<$Res> implements $BudgetFilterCopyWith<$Res> {
  _$BudgetFilterCopyWithImpl(this._value, this._then);

  final BudgetFilter _value;
  // ignore: unused_field
  final $Res Function(BudgetFilter) _then;

  @override
  $Res call({
    Object? type = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? categoryID = freezed,
    Object? lessThan = freezed,
    Object? moreThan = freezed,
    Object? cash = freezed,
  }) {
    return _then(_value.copyWith(
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as BudgetType?,
      startDate: startDate == freezed
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: endDate == freezed
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      categoryID: categoryID == freezed
          ? _value.categoryID
          : categoryID // ignore: cast_nullable_to_non_nullable
              as List<int?>?,
      lessThan: lessThan == freezed
          ? _value.lessThan
          : lessThan // ignore: cast_nullable_to_non_nullable
              as double?,
      moreThan: moreThan == freezed
          ? _value.moreThan
          : moreThan // ignore: cast_nullable_to_non_nullable
              as double?,
      cash: cash == freezed
          ? _value.cash
          : cash // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
abstract class _$BudgetFilterCopyWith<$Res>
    implements $BudgetFilterCopyWith<$Res> {
  factory _$BudgetFilterCopyWith(
          _BudgetFilter value, $Res Function(_BudgetFilter) then) =
      __$BudgetFilterCopyWithImpl<$Res>;
  @override
  $Res call(
      {BudgetType? type,
      DateTime? startDate,
      DateTime? endDate,
      List<int?>? categoryID,
      double? lessThan,
      double? moreThan,
      bool? cash});
}

/// @nodoc
class __$BudgetFilterCopyWithImpl<$Res> extends _$BudgetFilterCopyWithImpl<$Res>
    implements _$BudgetFilterCopyWith<$Res> {
  __$BudgetFilterCopyWithImpl(
      _BudgetFilter _value, $Res Function(_BudgetFilter) _then)
      : super(_value, (v) => _then(v as _BudgetFilter));

  @override
  _BudgetFilter get _value => super._value as _BudgetFilter;

  @override
  $Res call({
    Object? type = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? categoryID = freezed,
    Object? lessThan = freezed,
    Object? moreThan = freezed,
    Object? cash = freezed,
  }) {
    return _then(_BudgetFilter(
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as BudgetType?,
      startDate: startDate == freezed
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: endDate == freezed
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      categoryID: categoryID == freezed
          ? _value.categoryID
          : categoryID // ignore: cast_nullable_to_non_nullable
              as List<int?>?,
      lessThan: lessThan == freezed
          ? _value.lessThan
          : lessThan // ignore: cast_nullable_to_non_nullable
              as double?,
      moreThan: moreThan == freezed
          ? _value.moreThan
          : moreThan // ignore: cast_nullable_to_non_nullable
              as double?,
      cash: cash == freezed
          ? _value.cash
          : cash // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
class _$_BudgetFilter implements _BudgetFilter {
  const _$_BudgetFilter(
      {this.type,
      this.startDate,
      this.endDate,
      this.categoryID,
      this.lessThan,
      this.moreThan,
      this.cash});

  @override
  final BudgetType? type;
  @override
  final DateTime? startDate;
  @override
  final DateTime? endDate;
  @override
  final List<int?>? categoryID;
  @override
  final double? lessThan;
  @override
  final double? moreThan;
  @override
  final bool? cash;

  @override
  String toString() {
    return 'BudgetFilter(type: $type, startDate: $startDate, endDate: $endDate, categoryID: $categoryID, lessThan: $lessThan, moreThan: $moreThan, cash: $cash)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _BudgetFilter &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)) &&
            (identical(other.startDate, startDate) ||
                const DeepCollectionEquality()
                    .equals(other.startDate, startDate)) &&
            (identical(other.endDate, endDate) ||
                const DeepCollectionEquality()
                    .equals(other.endDate, endDate)) &&
            (identical(other.categoryID, categoryID) ||
                const DeepCollectionEquality()
                    .equals(other.categoryID, categoryID)) &&
            (identical(other.lessThan, lessThan) ||
                const DeepCollectionEquality()
                    .equals(other.lessThan, lessThan)) &&
            (identical(other.moreThan, moreThan) ||
                const DeepCollectionEquality()
                    .equals(other.moreThan, moreThan)) &&
            (identical(other.cash, cash) ||
                const DeepCollectionEquality().equals(other.cash, cash)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(type) ^
      const DeepCollectionEquality().hash(startDate) ^
      const DeepCollectionEquality().hash(endDate) ^
      const DeepCollectionEquality().hash(categoryID) ^
      const DeepCollectionEquality().hash(lessThan) ^
      const DeepCollectionEquality().hash(moreThan) ^
      const DeepCollectionEquality().hash(cash);

  @JsonKey(ignore: true)
  @override
  _$BudgetFilterCopyWith<_BudgetFilter> get copyWith =>
      __$BudgetFilterCopyWithImpl<_BudgetFilter>(this, _$identity);
}

abstract class _BudgetFilter implements BudgetFilter {
  const factory _BudgetFilter(
      {BudgetType? type,
      DateTime? startDate,
      DateTime? endDate,
      List<int?>? categoryID,
      double? lessThan,
      double? moreThan,
      bool? cash}) = _$_BudgetFilter;

  @override
  BudgetType? get type => throw _privateConstructorUsedError;
  @override
  DateTime? get startDate => throw _privateConstructorUsedError;
  @override
  DateTime? get endDate => throw _privateConstructorUsedError;
  @override
  List<int?>? get categoryID => throw _privateConstructorUsedError;
  @override
  double? get lessThan => throw _privateConstructorUsedError;
  @override
  double? get moreThan => throw _privateConstructorUsedError;
  @override
  bool? get cash => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$BudgetFilterCopyWith<_BudgetFilter> get copyWith =>
      throw _privateConstructorUsedError;
}

Category _$CategoryFromJson(Map<String, dynamic> json) {
  return _Category.fromJson(json);
}

/// @nodoc
class _$CategoryTearOff {
  const _$CategoryTearOff();

  _Category call({int? id, required String name, int color = 0xFFFFFFFF}) {
    return _Category(
      id: id,
      name: name,
      color: color,
    );
  }

  Category fromJson(Map<String, Object> json) {
    return Category.fromJson(json);
  }
}

/// @nodoc
const $Category = _$CategoryTearOff();

/// @nodoc
mixin _$Category {
  int? get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get color => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CategoryCopyWith<Category> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryCopyWith<$Res> {
  factory $CategoryCopyWith(Category value, $Res Function(Category) then) =
      _$CategoryCopyWithImpl<$Res>;
  $Res call({int? id, String name, int color});
}

/// @nodoc
class _$CategoryCopyWithImpl<$Res> implements $CategoryCopyWith<$Res> {
  _$CategoryCopyWithImpl(this._value, this._then);

  final Category _value;
  // ignore: unused_field
  final $Res Function(Category) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? color = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      color: color == freezed
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
abstract class _$CategoryCopyWith<$Res> implements $CategoryCopyWith<$Res> {
  factory _$CategoryCopyWith(_Category value, $Res Function(_Category) then) =
      __$CategoryCopyWithImpl<$Res>;
  @override
  $Res call({int? id, String name, int color});
}

/// @nodoc
class __$CategoryCopyWithImpl<$Res> extends _$CategoryCopyWithImpl<$Res>
    implements _$CategoryCopyWith<$Res> {
  __$CategoryCopyWithImpl(_Category _value, $Res Function(_Category) _then)
      : super(_value, (v) => _then(v as _Category));

  @override
  _Category get _value => super._value as _Category;

  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? color = freezed,
  }) {
    return _then(_Category(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      color: color == freezed
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

@JsonSerializable(includeIfNull: false)

/// @nodoc
class _$_Category implements _Category {
  const _$_Category({this.id, required this.name, this.color = 0xFFFFFFFF});

  factory _$_Category.fromJson(Map<String, dynamic> json) =>
      _$_$_CategoryFromJson(json);

  @override
  final int? id;
  @override
  final String name;
  @JsonKey(defaultValue: 0xFFFFFFFF)
  @override
  final int color;

  @override
  String toString() {
    return 'Category(id: $id, name: $name, color: $color)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Category &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.color, color) ||
                const DeepCollectionEquality().equals(other.color, color)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(color);

  @JsonKey(ignore: true)
  @override
  _$CategoryCopyWith<_Category> get copyWith =>
      __$CategoryCopyWithImpl<_Category>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_CategoryToJson(this);
  }
}

abstract class _Category implements Category {
  const factory _Category({int? id, required String name, int color}) =
      _$_Category;

  factory _Category.fromJson(Map<String, dynamic> json) = _$_Category.fromJson;

  @override
  int? get id => throw _privateConstructorUsedError;
  @override
  String get name => throw _privateConstructorUsedError;
  @override
  int get color => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$CategoryCopyWith<_Category> get copyWith =>
      throw _privateConstructorUsedError;
}
