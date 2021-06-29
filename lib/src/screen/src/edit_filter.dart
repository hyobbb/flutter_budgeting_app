import 'package:budgeting/src/model/model.dart';
import 'package:budgeting/src/service/budget_function.dart';
import 'package:budgeting/src/service/date_handler.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:budgeting/src/providers/providers.dart';
import 'package:flutter_gen/gen_l10n/app_loclizations.dart';

final _currentFilter = StateNotifierProvider.autoDispose
    .family<FilterNotifier, BudgetType?>((ref, type) {
  if (type == null) {
    return FilterNotifier(ref.read(balanceFilterProvider.state));
  } else if (type == BudgetType.Income) {
    return FilterNotifier(ref.read(incomeFilterProvider.state));
  } else {
    return FilterNotifier(ref.read(expenseFilterProvider.state));
  }
});

class EditFilter extends HookWidget {
  final BudgetType? type;
  static const String route = '/edit_filter';

  const EditFilter(this.type);

  @override
  Widget build(BuildContext context) {
    final provider = useProvider(_currentFilter(type));
    final group =
        BudgetFunction.groupByType(useProvider(budgetListCache.state));
    final categories =
        BudgetFunction.groupByCategory(group[type] ?? []).keys.toList();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(AppLocalizations.of(context)!.editFilter),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever_outlined),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  content: Text(AppLocalizations.of(context)!.confirmReset),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(AppLocalizations.of(context)!.cancel),
                    ),
                    TextButton(
                      onPressed: () async {
                        provider.reset(type);
                        Navigator.pop(context);
                      },
                      child: Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.done),
            onPressed: () {
              Navigator.pop(context, context.read(_currentFilter(type).state));
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _dateFilter(),
            const Divider(),
            _categoryFilter(categories),
            const Divider(),
            if (type == BudgetType.Expense) _cashFilter(),
          ],
        ),
      ),
    );
  }

  Widget _dateFilter() {
    final context = useContext();
    final budgetList = useProvider(budgetListCache);
    final provider = useProvider(_currentFilter(type));
    final filter = useProvider(_currentFilter(type).state);
    final start = filter.startDate ?? budgetList.firstDate;
    final end = filter.endDate ?? budgetList.lastDate;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: InkWell(
        onTap: () async {
          final selected = await showDateRangePicker(
              context: context,
              initialDateRange: DateTimeRange(
                start: start,
                end: end,
              ),
              firstDate: budgetList.firstDate,
              lastDate: budgetList.lastDate
          );

          if (selected != null) {
            provider.setDate(start: selected.start, end: selected.end);
          }
        },
        child: Text(
          '${DateHandler.toText(start, join: '/')} - ${DateHandler.toText(end, join: '/')}',
          style: Theme.of(context)
              .textTheme
              .headline5
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      leading: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Icon(
          Icons.date_range,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _categoryFilter(List<Category?> categories) {
    final context = useContext();
    final provider = useProvider(_currentFilter(type));
    return Column(
        children: List.generate(
      categories.length + 1,
      (index) => HookBuilder(
        builder: (_) {
          if (index == 0) {
            return ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                AppLocalizations.of(context)!.category,
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              leading: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Icon(
                  Icons.category_outlined,
                  color: Colors.black,
                ),
              ),
            );
          }
          final category = categories[index - 1];
          final isChecked = useState<bool>(provider.included(category));
          return ListTile(
            title: Text(category?.name ?? 'Etc'),
            leading: Checkbox(
              value: isChecked.value,
              onChanged: (checked) {
                if (checked != null) {
                  isChecked.value = checked;
                  if (checked) {
                    provider.includeCategory(category);
                  } else {
                    provider.excludeCategory(category);
                  }
                }
              },
            ),
          );
        },
      ),
    ));
  }

  Widget _cashFilter() {
    final context = useContext();
    final provider = useProvider(_currentFilter(type));
    final filter = useProvider(_currentFilter(type).state);
    final enabled = useState<bool>(filter.cash != null);
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            AppLocalizations.of(context)!.cash,
            style: Theme.of(context)
                .textTheme
                .headline5
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          leading: Checkbox(
            value: enabled.value,
            onChanged: (checked) {
              if (checked != null) {
                enabled.value = checked;
              }

              if (!enabled.value) {
                provider.setIfCash(null);
              }
            },
          ),
        ),
        if (enabled.value == true)
          HookBuilder(builder: (_) {
            final index = useState(filter.cash == null
                ? -1
                : (filter.cash!)
                    ? 0
                    : 1);
            return Column(children: [
              ListTile(
                title: Text(AppLocalizations.of(context)!.cash),
                leading: Radio<int>(
                  value: 0,
                  groupValue: index.value,
                  onChanged: (value) {
                    if (value != null) {
                      index.value = value;
                      provider.setIfCash(true);
                    }
                  },
                ),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.card),
                leading: Radio<int>(
                  value: 1,
                  groupValue: index.value,
                  onChanged: (value) {
                    print(value);
                    if (value != null) {
                      index.value = value;
                      provider.setIfCash(false);
                    }
                  },
                ),
              ),
            ]);
          }),
      ],
    );
  }
}

@deprecated
class PriceFilter extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final maxValue = 1000000.0;
    final range = useState<RangeValues>(RangeValues(0.0, maxValue));
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                range.value.start.toStringAsFixed(1),
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: const Text('-'),
              ),
              Text(
                range.value.end == maxValue
                    ? 'Limitless'
                    : range.value.end.toStringAsFixed(1),
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          leading: Icon(
            Icons.monetization_on_outlined,
            color: Colors.black,
          ),
        ),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: Theme.of(context).primaryColor,
            inactiveTrackColor: Theme.of(context).hintColor,
            trackShape: const RectangularSliderTrackShape(),
            activeTickMarkColor: Colors.white,
            inactiveTickMarkColor: Colors.white,
            thumbShape: const RoundSliderThumbShape(),
            overlayColor: Theme.of(context).primaryColor.withOpacity(0.3),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 10),
            thumbColor: Colors.white,
          ),
          child: RangeSlider(
            values: range.value,
            min: 0,
            max: maxValue,
            divisions: (maxValue / 10).round(),
            onChanged: (val) {
              range.value = val;
            },
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
