import 'dart:io';

import 'package:budgeting/src/model/model.dart';
import 'package:budgeting/src/service/budget_function.dart';
import 'package:budgeting/src/service/db_api.dart';
import 'package:budgeting/src/widget/src/chart.dart';
import 'package:budgeting/src/widget/src/drawer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:budgeting/src/providers/providers.dart';
import 'package:flutter_gen/gen_l10n/app_loclizations.dart';
import 'package:share/share.dart';

class HomeScreen extends HookWidget {
  static const String route = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text(AppLocalizations.of(context)!.homeTitle),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.upload_rounded),
              onPressed: () async {
                final api = DatabaseAPI();
                final budget = await api.budgetToCsv();
                final category = await api.categoryToCsv();
                await Share.shareFiles([budget.path, category.path]);
              },
            ),
            IconButton(
              icon: Icon(Icons.download_rounded),
              onPressed: () async {
                final result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['csv'],
                  allowMultiple: true,
                );

                if (result != null) {
                  List<File> files =
                      result.paths.map((path) => File(path ?? '')).toList();
                  for(final file in files) {
                    await DatabaseAPI().importCsv(file);
                  }
                  context.read(budgetListCache).onImportCsv();
                  context.read(categoryListCache).onImportCsv();
                }
              },
            )
          ],
        ),
        body: HookBuilder(
          builder: (context) {
            final _data = BudgetFunction.applyFilter(
              data: useProvider(budgetListCache.state),
              filter: useProvider(balanceFilterProvider.state),
            );
            if (_data.isNotEmpty) {
              final items = BudgetFunction.groupByType(_data);
              final incomes = items[BudgetType.Income] ?? [];
              final expenses = items[BudgetType.Expense] ?? [];
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Column(
                    children: [
                      BalanceBar(
                        income: BudgetFunction.sum(incomes),
                        expense: BudgetFunction.sum(expenses),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      LineChartView(
                        DateTime.now(),
                        incomes,
                        expenses,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      BarChartView(
                        DateTime.now(),
                        incomes,
                        expenses,
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Center(child: Text(AppLocalizations.of(context)!.noData));
            }
          },
        ),
        drawer: const AppDrawer());
  }
}
