import 'package:budgeting/src/screen/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
            child: const Text('Simple Budegting'),
          ),
          ListTile(
            selected: route.state == HomeScreen.route,
            leading: const Icon(Icons.attach_money),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, HomeScreen.route);
              route.state = HomeScreen.route;
            },
          ),
          ListTile(
            selected: route.state == IncomeScreen.route,
            leading: const Icon(Icons.attach_money),
            title: const Text('Income'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, IncomeScreen.route);
              route.state = IncomeScreen.route;
            },
          ),
          ListTile(
            selected: route.state == ExpenseScreen.route,
            leading: const Icon(Icons.attach_money),
            title: const Text('Expense'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, ExpenseScreen.route);
              route.state = ExpenseScreen.route;
            },
          ),
        ],
      ),
    );
  }
}
