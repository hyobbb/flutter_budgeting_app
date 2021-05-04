import 'dart:collection';
import 'package:budgeting/src/model/model.dart';
import 'package:budgeting/src/providers/src/locale_provider.dart';
import 'package:budgeting/src/service/budget_function.dart';
import 'package:budgeting/src/service/date_handler.dart';
import 'package:budgeting/src/widget/widgets.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PieChartView extends HookWidget {
  final Map<Category?, double> data;

  const PieChartView(this.data);

  @override
  Widget build(BuildContext context) {
    double totalSum = 0.0;
    List<Category?> keys = [];
    List<double> values = [];
    useEffect(() {
      final sortedKeys = data.keys.toList()
        ..sort((k1, k2) => data[k2]?.compareTo(data[k1] ?? 0) ?? 0);
      final LinkedHashMap<Category?, double> items = LinkedHashMap.fromIterable(
          sortedKeys,
          key: (k) => k,
          value: (k) => data[k] ?? 0);
      totalSum = items.values.reduce((value, element) => value + element);
      keys = items.keys.toList();
      values = items.values.toList();
      return null;
    }, [data]);
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Text(
                    'Total: ' + totalSum.toString() + ' ‎€',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff000000),
                    ),
                  ),
                ),
                AspectRatio(
                  aspectRatio: 1,
                  child: PieChart(
                    PieChartData(
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: 0,
                      centerSpaceRadius: 20,
                      sections: List.generate(keys.length, (i) {
                        final double fontSize = 16;
                        final double radius = 100;
                        return PieChartSectionData(
                          color: keys[i] == null
                              ? Colors.white.withOpacity(0.8)
                              : Color(keys[i]!.color).withOpacity(0.8),
                          value: values[i],
                          title:
                              '${(values[i]/totalSum * 100).toStringAsFixed(1)}%',
                          radius: radius,
                          titleStyle: TextStyle(
                              fontSize: fontSize,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xff000000)),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: Column(
                  children: List.generate(
                    keys.length,
                    (i) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          CategoryTag(keys[i]),
                          Expanded(child: Container()),
                          const SizedBox(width: 20),
                          Text(values[i].toString() + ' ‎€'),
                          const SizedBox(width: 20),
                          Text((values[i] / totalSum * 100).toStringAsFixed(1) +
                              ' %'),
                        ],
                      ),
                    ),
                  ).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BalanceBar extends HookWidget {
  final double income;
  final double expense;
  static const height = 15.0;
  static const radius = Radius.circular(8.0);

  const BalanceBar({
    required this.income,
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
    final totalSum = income + expense;
    final balance = income - expense;
    final locale = useProvider(localeProvider);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Text(
            'Total Balance: ' + locale.printIncome(balance),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: const Color(0xff000000),
            ),
          ),
          const SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              height: height,
              width:
                  MediaQuery.of(context).size.width * 0.8 * (income / totalSum),
              decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius:
                      BorderRadius.only(topLeft: radius, bottomLeft: radius)),
            ),
            Container(
              height: height,
              width: MediaQuery.of(context).size.width *
                  0.8 *
                  (expense / totalSum),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius:
                    BorderRadius.only(topRight: radius, bottomRight: radius),
              ),
            ),
          ]),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class BarChartView extends HookWidget {
  final DateTime endDate;
  final List<BudgetData> incomes;
  final List<BudgetData> expenses;

  final int length = 6;

  const BarChartView(
    this.endDate,
    this.incomes,
    this.expenses,
  );

  @override
  Widget build(BuildContext context) {
    final touchedGroupIndex = useState(-1);
    return AspectRatio(
      aspectRatio: 1.3,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFF59D),
              Colors.white,
              Colors.white,
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: BarChart(
            BarChartData(
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  tooltipBgColor: Colors.black,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                        'income: ' +
                            group.barRods.first.y.toStringAsFixed(1) +
                            '\n',
                        TextStyle(
                          color: Colors.green,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'expense: ' +
                                group.barRods.last.y.toStringAsFixed(1),
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                        textAlign: TextAlign.left);
                  },
                ),
                touchCallback: (response) {
                  if (response.spot != null &&
                      response.touchInput is! PointerUpEvent &&
                      response.touchInput is! PointerExitEvent) {
                    touchedGroupIndex.value =
                        response.spot!.touchedBarGroupIndex;
                  } else {
                    touchedGroupIndex.value = -1;
                  }
                },
              ),
              titlesData: FlTitlesData(
                bottomTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 12,
                  getTextStyles: (value) => const TextStyle(
                    color: Color(0xff72719b),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  margin: 20,
                  getTitles: (value) {
                    final date = DateTime(
                        endDate.year, endDate.month - 5 + value.toInt());
                    return DateHandler.toText(
                      date,
                      shortYear: true,
                      includeDay: false,
                      join: '/',
                    );
                  },
                ),
                leftTitles: SideTitles(
                  showTitles: true,
                  getTextStyles: (value) => const TextStyle(
                      color: Color(0xff7589a2),
                      fontWeight: FontWeight.bold,
                      fontSize: 10),
                  margin: 40,
                  reservedSize: 10,
                  interval: 100,
                  getTitles: (value) {
                    return '${value.toInt()}';
                  },
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: const Border(
                  bottom: BorderSide(
                    color: Color(0xff4e4965),
                    width: 2,
                  ),
                  left: BorderSide(
                    color: Colors.transparent,
                  ),
                  right: BorderSide(
                    color: Colors.transparent,
                  ),
                  top: BorderSide(
                    color: Colors.transparent,
                  ),
                ),
              ),
              barGroups: List.generate(
                length,
                (index) {
                  final date =
                      DateTime(endDate.year, endDate.month - 5 + index);
                  final income = BudgetFunction.sum(incomes
                      .where((i) =>
                          i.date.year == date.year &&
                          i.date.month == date.month)
                      .toList());
                  final expense = BudgetFunction.sum(expenses
                      .where((e) =>
                          e.date.year == date.year &&
                          e.date.month == date.month)
                      .toList());
                  return BarChartGroupData(
                    barsSpace: 2,
                    x: index,
                    barRods: [
                      //income
                      BarChartRodData(
                        y: income,
                        colors: [Colors.green],
                        width: 8,
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                      //expense
                      BarChartRodData(
                        y: expense,
                        colors: [Colors.red],
                        width: 8,
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LineChartView extends StatelessWidget {
  final DateTime endDate;
  final List<BudgetData> incomes;
  final List<BudgetData> expenses;

  final int length = 6;

  const LineChartView(
    this.endDate,
    this.incomes,
    this.expenses,
  );

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(18)),
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFF59D),
              Colors.white,
              Colors.white,
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        padding: const EdgeInsets.all(30),
        child: LineChart(
          lineChartData(),
        ),
      ),
    );
  }

  LineChartData lineChartData() {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 100,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 12,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff72719b),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          margin: 20,
          getTitles: (value) {
            final date =
                DateTime(endDate.year, endDate.month - 5 + value.toInt());
            return DateHandler.toText(
              date,
              shortYear: true,
              includeDay: false,
              join: '/',
            );
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
              color: Color(0xff7589a2),
              fontWeight: FontWeight.bold,
              fontSize: 10),
          margin: 40,
          reservedSize: 10,
          interval: 100,
          getTitles: (value) {
            return '${value.toInt()}';
          },
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(
            color: Color(0xff4e4965),
            width: 2,
          ),
          left: BorderSide(
            color: Colors.transparent,
          ),
          right: BorderSide(
            color: Colors.transparent,
          ),
          top: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      minX: 0,
      maxX: length.toDouble() - 1,
      lineBarsData: [
        LineChartBarData(
          spots: List.generate(
            length,
            (index) {
              final date = DateTime(endDate.year, endDate.month - 5 + index);
              final income = BudgetFunction.sum(incomes
                  .where((i) =>
                      i.date.year == date.year && i.date.month == date.month)
                  .toList());
              final expense = BudgetFunction.sum(expenses
                  .where((e) =>
                      e.date.year == date.year && e.date.month == date.month)
                  .toList());
              return FlSpot(index.toDouble(), income - expense);
            },
          ),
          isCurved: true,
          curveSmoothness: 0,
          colors: const [
            Colors.orange,
          ],
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: false,
          ),
        ),
      ],
    );
  }
}
