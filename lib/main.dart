import 'package:budgeting/src/model/model.dart';
import 'package:budgeting/src/providers/src/locale_provider.dart';
import 'package:budgeting/src/screen/screens.dart';
import 'package:budgeting/src/service/db_api.dart';
import 'package:budgeting/src/service/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_gen/gen_l10n/app_loclizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:intl/date_symbol_data_local.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
  //await initializeDateFormatting();
  await DatabaseAPI().init();
  runApp(ProviderScope(observers: [ProviderLogger()], child: MyApp()));
}

class MyApp extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final locale = useProvider(localeProvider.state);
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        iconTheme: IconThemeData(color: Colors.black),
        primarySwatch: Colors.amber,
        accentColor: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      locale: locale,
      initialRoute: ExpenseScreen.route,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case HomeScreen.route:
            return MaterialPageRoute(builder: (_) => HomeScreen());
          case IncomeScreen.route:
            return MaterialPageRoute(builder: (_) => IncomeScreen());
          case ExpenseScreen.route:
            return MaterialPageRoute(builder: (_) => ExpenseScreen());
          case EditData.route:
            final data = settings.arguments as BudgetData;
            return MaterialPageRoute(builder: (_) => EditData(data));
          case EditFilter.route:
            final data = settings.arguments as BudgetType;
            return MaterialPageRoute(builder: (_) => EditFilter(data));
          case Preference.route:
            return MaterialPageRoute(builder: (_) => Preference());
          default:
            return null;
        }
      },
    );
  }
}
