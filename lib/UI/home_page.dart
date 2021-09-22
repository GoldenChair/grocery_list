import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_list/Bloc/cubit/grocery_list_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Widgets/home_widget.dart';
import 'Widgets/error_widget.dart';
import 'package:grocery_list/UI/Widgets/add_row_page_widget.dart';
import 'package:grocery_list/UI/hamburger_menu_features.dart';
import 'package:grocery_list/Model/item.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key, required this.title, required this.prefs})
      : super(key: key);

  final String title;
  final List<RowItem> initialItemList = [];
  final HamburgerMenuFeatures hmf = HamburgerMenuFeatures();
  SharedPreferences prefs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: buildBody(context),
      ),
    );
  }

  BlocProvider<GroceryListCubit> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => GroceryListCubit(initialItemList, prefs),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Column(children: <Widget>[
            Expanded(
              child: BlocBuilder<GroceryListCubit, GroceryListState>(
                builder: (context, state) {
                  if (state is GroceryListStateInitial) {
                    return HomeWidget(state.prefs);
                  }
                  if (state is GroceryListStateAddRowPage) {
                    return AddRowPageWidget();
                  }
                  if (state is GroceryListStateAdded) {
                    return HomeWidget(state.prefs);
                  }
                  {
                    return const ErrorWidgetMine();
                  }
                },
              ),
            )
          ]),
        ),
      ),
    );
  }
}
