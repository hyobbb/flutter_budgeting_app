import 'package:budgeting/src/model/model.dart';
import 'package:budgeting/src/screen/screens.dart';
import 'package:budgeting/src/service/budget_function.dart';
import 'package:budgeting/src/widget/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:budgeting/src/providers/providers.dart';
import 'package:flutter_gen/gen_l10n/app_loclizations.dart';


class IncomeScreen extends HookWidget {
  static const String route = '/income';

  @override
  Widget build(BuildContext context) {
    final navigationIndex = useState(0);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(AppLocalizations.of(context)!.incomeTitle),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(
                context,
                EditData.route,
                arguments: BudgetData(
                  type: BudgetType.Income,
                  date: DateTime.now(),
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
                arguments: BudgetType.Income,
              );

              context
                  .read(incomeFilterProvider)
                  .setFilter(filter as BudgetFilter);
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: HookBuilder(
        builder: (context) {
          final data = BudgetFunction.applyFilter(
            data: useProvider(budgetListCache.state),
            filter: useProvider(incomeFilterProvider.state),
          );
          if (data.isNotEmpty) {
            if (navigationIndex.value == 0) {
              return BudgetListView(data);
            } else {
              final items = BudgetFunction.groupByCategory(data).map(
                  (key, value) => MapEntry(key, BudgetFunction.sum(value)));
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
        ],
        currentIndex: navigationIndex.value,
        onTap: (index) => navigationIndex.value = index,
      ),
    );
  }
}
