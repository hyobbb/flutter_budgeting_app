import 'package:budgeting/src/model/model.dart';
import 'package:budgeting/src/widget/src/search_category.dart';
import 'package:budgeting/src/service/date_handler.dart';
import 'package:budgeting/src/widget/src/category_tag.dart';
import 'package:budgeting/src/widget/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:budgeting/src/providers/providers.dart';
import 'package:flutter_gen/gen_l10n/app_loclizations.dart';

class EditData extends HookWidget {
  final BudgetData data;
  static const String route = '/edit_data';

  const EditData(this.data);

  @override
  Widget build(BuildContext context) {
    final budgetList = useProvider(budgetListCache);
    final editingProvider = useProvider(editingData(data));
    final editingParam = useProvider(editingData(data).state);
    final title = useTextEditingController();
    final value = useTextEditingController();
    useEffect(() {
      title.text = editingParam.title;
      value.text = editingParam.value.toString();
    }, const []);
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: data.type == BudgetType.Expense
              ? Text(AppLocalizations.of(context)!.editExpense)
              : Text(AppLocalizations.of(context)!.editIncome),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever_outlined),
            onPressed: () {
              if (editingParam.id != null) {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    content: Text(AppLocalizations.of(context)!.confirmDelete),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(AppLocalizations.of(context)!.cancel),
                      ),
                      TextButton(
                        onPressed: () async {
                          await budgetList.remove(editingParam.id!);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.done),
            onPressed: () async {
              if (editingProvider.isValid()) {
                await budgetList.update(editingParam);
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(AppLocalizations.of(context)!.invalidParameter)));
              }
            },
          )
        ],
      ),
      body: GestureDetector(
        onTap: () => primaryFocus?.unfocus(),
        behavior: HitTestBehavior.translucent,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: HookBuilder(
            builder: (_) => Column(
              children: [
                _titleInput(title),
                _valueInput(value),
                if (data.type == BudgetType.Expense) _checkCash(),
                _dateInput(),
                _categoryInput(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _titleInput(TextEditingController controller) {
    final context = useContext();
    return Container(
      height: 60,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.description),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
                controller: controller,
                decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.titleHint, border: InputBorder.none),
                style: Theme.of(context).textTheme.headline5,
                onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                onChanged: (title) =>
                    context.read(editingData(data)).setTitle(title)),
          )
        ],
      ),
    );
  }

  Widget _valueInput(TextEditingController controller) {
    final context = useContext();
    return Container(
      height: 60,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.euro),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                  hintText: context.read(localeProvider).printIncome(0.00),
                  border: InputBorder.none),
              keyboardType: TextInputType.number,
              style: Theme.of(context).textTheme.headline5,
              onSubmitted: (_) => FocusScope.of(context).unfocus(),
              onChanged: (value) =>
                  context.read(editingData(data)).setValue(value),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dateInput() {
    final context = useContext();
    final state = useProvider(editingData(data).state);
    final date = state.date;
    return Container(
      height: 60,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.calendar_today),
          const SizedBox(width: 10),
          Expanded(
            child: InkWell(
              onTap: () async {
                final selected = await showDatePicker(
                    context: context,
                    initialDate: date,
                    firstDate: DateTime.utc(1999),
                    lastDate: DateTime.now());

                if (selected != null) {
                  context.read(editingData(data)).setDate(selected);
                }
              },
              child: Text(DateHandler.toText(date)),
            ),
          )
        ],
      ),
    );
  }

  Widget _categoryInput() {
    final context = useContext();
    final state = useProvider(editingData(data).state);
    return Container(
      height: 60,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.category),
          const SizedBox(width: 10),
          HookBuilder(builder: (_) {
            return CategoryTag(
              state.category,
              onTap: (_) {
                showDialog(
                  context: context,
                  builder: (_) => SearchCategory(
                    onDeleted: (Category value) async {
                      await context.read(categoryListCache).remove(value.id!);
                      context.read(editingData(data)).onDeleteCategory(value);
                      context
                          .read(budgetListCache)
                          .onCategoryDeleted(value.id!);
                    },
                    onCreated: (Category value) async {
                      await context.read(categoryListCache).update(value);
                      context.read(editingData(data)).setCategory(context
                          .read(categoryListCache)
                          .getCategory(value.name));
                    },
                    onSelected: (Category? value) {
                      context.read(editingData(data)).setCategory(value);
                    },
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _checkCash() {
    final context = useContext();
    final state = useProvider(editingData(data).state);
    return Container(
      height: 60,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.monetization_on_outlined),
          const SizedBox(width: 10),
          Row(
            children: [
              Checkbox(
                value: state.cash,
                onChanged: (value) {
                  if (value != null) {
                    context.read(editingData(data)).setIfCash(value);
                  }
                },
              ),
              Text(AppLocalizations.of(context)!.cashHint)
            ],
          ),
        ],
      ),
    );
  }
}
