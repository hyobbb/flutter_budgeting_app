import 'package:budgeting/src/model/model.dart';
import 'package:budgeting/src/screen/screens.dart';
import 'package:budgeting/src/service/budget_function.dart';
import 'package:budgeting/src/widget/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:budgeting/src/providers/providers.dart';

class IncomeScreen extends HookWidget {
  static const String route = '/income';

  @override
  Widget build(BuildContext context) {
    final navigationIndex = useState(0);
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: const Text('Income'),
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
            return const Center(child: Text('No data'));
          }
        },
      ),
      drawer: const AppDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'List'),
          BottomNavigationBarItem(
              icon: Icon(Icons.pie_chart), label: 'By Category'),
        ],
        currentIndex: navigationIndex.value,
        onTap: (index) => navigationIndex.value = index,
      ),
    );
  }
}
