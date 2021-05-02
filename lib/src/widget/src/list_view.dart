import 'package:budgeting/src/model/model.dart';
import 'package:budgeting/src/screen/screens.dart';
import 'package:budgeting/src/service/budget_function.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:budgeting/src/widget/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class BudgetListView extends HookWidget {
  final List<BudgetData> data;

  const BudgetListView(this.data);

  @override
  Widget build(BuildContext context) {
    final start = data.first.date.year;
    final end = data.last.date.year;
    return ListView(
      children: List.generate(
        end - start + 1,
        (index) {
          final thisYear = start + index;
          final dataOfThisYear =
              data.where((e) => e.date.year == thisYear).toList();
          final sum = BudgetFunction.sum(dataOfThisYear);
          return ExpansionTile(
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    thisYear.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  sum.toString() + ' ‎€',
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            initiallyExpanded: true,
            maintainState: true,
            collapsedBackgroundColor: data.first.type == BudgetType.Income
                ? Colors.green.withOpacity(0.1)
                : Colors.red.withOpacity(0.1),
            backgroundColor: data.first.type == BudgetType.Income
                ? Colors.green.withOpacity(0.1)
                : Colors.red.withOpacity(0.1),
            // Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
            //     .withOpacity(0.1),
            children: _makeMonthTile(dataOfThisYear, thisYear),
          );
        },
      ),
    );
  }

  List<Widget> _makeMonthTile(List<BudgetData> data, int year) {
    final context = useContext();
    return List.generate(
      12,
      (index) {
        final thisMonth = 1 + index;
        final dataOfThisMonth =
            data.where((e) => e.date.month == thisMonth).toList();
        final sum = BudgetFunction.sum(dataOfThisMonth);
        if (sum != 0) {
          return ExpansionTile(
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    DateFormat.MMMM('es-ES').format(DateTime(year, thisMonth)),
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Text(
                  sum.toString() + ' ‎€',
                  style: Theme.of(context).textTheme.subtitle1?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            initiallyExpanded: true,
            collapsedBackgroundColor: data.first.type == BudgetType.Income
                ? Colors.green.withOpacity(0.1)
                : Colors.red.withOpacity(0.1),
            backgroundColor: data.first.type == BudgetType.Income
                ? Colors.green.withOpacity(0.1)
                : Colors.red.withOpacity(0.1),
            children: dataOfThisMonth
                .map(
                  (e) => ProviderScope(
                    overrides: [_scoped.overrideWithValue(e)],
                    child: const BudgetTile(),
                  ),
                )
                .toList(),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

final _scoped = ScopedProvider<BudgetData>(null);

class BudgetTile extends HookWidget {
  const BudgetTile();

  @override
  Widget build(BuildContext context) {
    final data = useProvider(_scoped);
    final date = data.date;
    return ListTile(
      leading: CircleAvatar(
        child: Text(
          date.day.toString(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      title: Row(
        //crossAxisAlignment:  CrossAxisAlignment.baseline,
        children: [
          Expanded(
              child: Text(
            data.title,
            overflow: TextOverflow.ellipsis,
          )),
          if (data.cash != null)
            data.cash!
                ? Icon(Icons.monetization_on_outlined)
                : Icon(Icons.credit_card),
          const SizedBox(width: 5),
          Text(data.value.toString() + ' ‎€'),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: SizedBox(
          height: 40,
          child: Align(
              alignment: Alignment.centerLeft,
              child: CategoryTag(data.category)),
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, EditData.route, arguments: data);
      },
    );
  }
}
