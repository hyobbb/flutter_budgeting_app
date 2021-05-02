// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Category _$_$_CategoryFromJson(Map<String, dynamic> json) {
  return _$_Category(
    id: json['id'] as int?,
    name: json['name'] as String,
    color: json['color'] as int? ?? 4294967295,
  );
}

Map<String, dynamic> _$_$_CategoryToJson(_$_Category instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['name'] = instance.name;
  val['color'] = instance.color;
  return val;
}
