import 'package:budgeting/src/model/model.dart';
import 'package:budgeting/src/providers/src/locale_provider.dart';
import 'package:budgeting/src/service/budget_function.dart';
import 'package:budgeting/src/service/date_handler.dart';
import 'package:budgeting/src/widget/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:budgeting/src/providers/providers.dart';
import 'package:flutter_gen/gen_l10n/app_loclizations.dart';

class Preference extends HookWidget {
  static const String route = '/preference';

  const Preference();

  @override
  Widget build(BuildContext context) {
    final locale = useProvider(localeProvider.state);
    final index = useState(locale.languageCode=='es' ? 1: 0);
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(AppLocalizations.of(context)!.preference),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(AppLocalizations.of(context)!.english),
              leading: Radio<int>(
                value: 0,
                groupValue: index.value,
                onChanged: (value) {
                  if (value != null) {
                    index.value = value;
                    context.read(appLocale).state = Locale('en');
                  }
                },
              ),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.spanish),
              leading: Radio<int>(
                value: 1,
                groupValue: index.value,
                onChanged: (value) {
                  print(value);
                  if (value != null) {
                    index.value = value;
                    context.read(appLocale).state = Locale('es');
                  }
                },
              ),
            ),
          ],
        ),
      ),
      drawer: const AppDrawer(),
    );
  }
}

