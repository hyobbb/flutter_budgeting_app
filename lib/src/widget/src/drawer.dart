import 'package:budgeting/src/screen/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_loclizations.dart';

final _route = StateProvider<String>((ref) => '/');

class AppDrawer extends HookWidget {

  const AppDrawer();

  @override
  Widget build(BuildContext context) {
    final route = useProvider(_route);
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
           DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Text(AppLocalizations.of(context)!.appTitle),
          ),
          ListTile(
            selected: route.state == HomeScreen.route,
            leading: const Icon(Icons.account_balance),
            title: Text(AppLocalizations.of(context)!.homeTitle),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, HomeScreen.route);
              route.state = HomeScreen.route;
            },
          ),
          ListTile(
            selected: route.state == IncomeScreen.route,
            leading: const Icon(Icons.attach_money),
            title: Text(AppLocalizations.of(context)!.incomeTitle),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, IncomeScreen.route);
              route.state = IncomeScreen.route;
            },
          ),
          ListTile(
            selected: route.state == ExpenseScreen.route,
            leading: const Icon(Icons.attach_money),
            title: Text(AppLocalizations.of(context)!.expenseTitle),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, ExpenseScreen.route);
              route.state = ExpenseScreen.route;
            },
          ),
          ListTile(
            selected: route.state == Preference.route,
            leading: const Icon(Icons.settings),
            title: Text(AppLocalizations.of(context)!.preference),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, Preference.route);
              route.state = Preference.route;
            },
          ),
        ],
      ),
    );
  }
}
