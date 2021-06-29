import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

final appLocale = StateProvider<Locale>((ref) => Locale('en'));

final localeProvider = StateNotifierProvider<LocaleNotifier>(
    (ref) => LocaleNotifier(ref.watch(appLocale).state));

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier(Locale state) : super(state) {
    if (state.languageCode == 'en') {
      moneyFormat = NumberFormat.simpleCurrency(locale: 'en_US');
      percentageFormat = NumberFormat.percentPattern('en_US');
    } else {
      moneyFormat = NumberFormat.simpleCurrency(locale: 'es_ES');
      percentageFormat =
          NumberFormat.percentPattern('es_ES');
    }
  }

  late final NumberFormat moneyFormat;
  late final NumberFormat percentageFormat;

  String printIncome(num num) {
    return moneyFormat.format(num);
  }

  String printExpense(num num) {
    return '-' + moneyFormat.format(num);
  }

  String printPercentage(num num) {
    return percentageFormat.format(num);
  }
}
