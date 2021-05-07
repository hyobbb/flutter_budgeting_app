import 'package:budgeting/src/model/model.dart';
import 'package:budgeting/src/screen/screens.dart';
import 'package:budgeting/src/screen/src/edit_data.dart';
import 'package:budgeting/src/service/budget_function.dart';
import 'package:budgeting/src/widget/src/chart.dart';
import 'package:budgeting/src/widget/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:budgeting/src/providers/providers.dart';
import 'package:flutter_gen/gen_l10n/app_loclizations.dart';

class ExpenseScreen extends HookWidget {
  static const String route = '/expense';

  @override
  Widget build(BuildContext context) {
    final navigationIndex = useState(0);
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(AppLocalizations.of(context)!.expenseTitle),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(
                context,
                EditData.route,
                arguments: BudgetData(
                  type: BudgetType.Expense,
                  date: DateTime.now(),
                  cash: false,
                  title: '',
                  value: 0.0,
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () async {
              final filter = await Navigator.pushNamed(
                context,
                EditFilter.route,
                arguments: BudgetType.Expense,
              );
              if (filter != null) {
                context
                    .read(expenseFilterProvider)
                    .setFilter(filter as BudgetFilter);
              }
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: HookBuilder(
        builder: (context) {
          final data = BudgetFunction.applyFilter(
            data: useProvider(budgetListCache.state),
            filter: useProvider(expenseFilterProvider.state),
          );
          if (data.isNotEmpty) {
            if (navigationIndex.value == 0) {
              return BudgetListView(data);
            } else if (navigationIndex.value == 1) {
              final items = BudgetFunction.groupByCategory(data).map(
                  (key, value) => MapEntry(key, BudgetFunction.sum(value)));
              return PieChartView(items);
            } else {
              final items =
                  BudgetFunction.groupByCashUse(data).map((key, value) {
                Category category;
                if (key == null || key) {
                  category = Category(name: AppLocalizations.of(context)!.cash, color: Colors.blue.value);
                } else {
                  category =
                      Category(name: AppLocalizations.of(context)!.card, color: Colors.red.value);
                }
                return MapEntry(category, BudgetFunction.sum(value));
              });
              return PieChartView(items);
            }
          } else {
            return Center(child: Text(AppLocalizations.of(context)!.noData));
          }
        },
      ),
      drawer: const AppDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: AppLocalizations.of(context)!.list),
          BottomNavigationBarItem(
              icon: Icon(Icons.pie_chart), label: AppLocalizations.of(context)!.category),
          BottomNavigationBarItem(
              icon: Icon(Icons.pie_chart), label: AppLocalizations.of(context)!.cash),
        ],
        currentIndex: navigationIndex.value,
        onTap: (index) => navigationIndex.value = index,
      ),
    );
  }
}
