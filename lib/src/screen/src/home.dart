import 'package:budgeting/src/model/model.dart';
import 'package:budgeting/src/service/budget_function.dart';
import 'package:budgeting/src/service/date_handler.dart';
import 'package:budgeting/src/widget/src/chart.dart';
import 'package:budgeting/src/widget/src/drawer.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:budgeting/src/providers/providers.dart';

class HomeScreen extends HookWidget {
  static const String route = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Align(
            alignment: Alignment.centerLeft,
            child: const Text('Balance'),
          ),
        ),
        body: HookBuilder(
          builder: (context) {
            final _data = BudgetFunction.applyFilter(
              data: useProvider(budgetListCache.state),
              filter: useProvider(balanceFilterProvider.state),
            );
            if (_data.isNotEmpty) {
              final items = BudgetFunction.groupByType(_data);
              final incomes = items[BudgetType.Income];
              final expenses = items[BudgetType.Expense];
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Column(
                    children: [
                      BalanceBar(
                        income: BudgetFunction.sum(incomes!),
                        expense: BudgetFunction.sum(expenses!),
                      ),
                      const Text(
                        'Monthly Balance',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.6,
                        ),
                        textAlign: TextAlign.center,
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
              return const Center(child: Text('No data'));
            }
          },
        ),
        drawer: const AppDrawer());
  }
}

