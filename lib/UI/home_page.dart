import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_list/Bloc/cubit/grocery_list_cubit.dart';
import 'package:grocery_list/UI/Widgets/item_description_page.dart';
import 'package:grocery_list/UI/Widgets/loading_widget.dart';

import 'Widgets/home_widget.dart';
import 'Widgets/error_widget.dart';
import 'package:grocery_list/UI/Widgets/add_row_page_widget.dart';
import 'package:grocery_list/Model/hamburger_menu_features.dart';
import 'package:grocery_list/Model/item.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({
    Key? key,
  }) : super(key: key);

  final List<RowItem> items = [];
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
      create: (_) => GroceryListCubit(items)..init(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Column(children: <Widget>[
            Expanded(
              child: BlocBuilder<GroceryListCubit, GroceryListState>(
                builder: (context, state) {
                  if (state is GroceryListStateInitial) {
                    return HomeWidget(state.emptyItemsList);
                  }
                  if (state is GroceryListStateAdded) {
                    return HomeWidget(state.items);
                  }
                  if (state is GroceryListStateItemDescription) {
                    return ItemDescriptionPage(state.item);
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
