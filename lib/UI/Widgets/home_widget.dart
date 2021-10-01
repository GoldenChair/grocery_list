import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_list/Bloc/cubit/grocery_list_cubit.dart';
import 'package:grocery_list/Database/database.dart';
import 'package:grocery_list/UI/Widgets/build_row_widget.dart';
import 'package:grocery_list/Model/hamburger_menu_features.dart';
import 'package:grocery_list/Model/item.dart';
import 'package:path_provider/path_provider.dart';

// replace return BuildRowWidget with return every item in rows.
class HomeWidget extends StatelessWidget {
  HomeWidget(
    this.itemsList, {
    Key? key,
  }) : super(key: key);
  List<RowItem> itemsList;
  final HamburgerMenuFeatures hmf = HamburgerMenuFeatures();
  final myController = TextEditingController();
  final DatabaseProvider db = DatabaseProvider();
  var bool = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grocery List'),
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
                height: 100.0,
                child: const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Text(''),
                )),
            ListTile(
              title: const Text('Delete All Rows'),
              onTap: () => hmf.removeAllItems(context),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ListView.separated(
                itemBuilder: (_, index) {
                  final item = itemsList[index];
                  return Dismissible(
                      direction: DismissDirection.horizontal,
                      key: Key(item.id.toString()),
                      onDismissed: (direction) {
                        removeItem(context, item);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(item.itemName + ' removed'),
                        ));
                      },
                      child: ListTile(
                        tileColor: Color.fromARGB(100, 0, 100, 0),
                        title: BuildRowWidget(item),
                      ));
                },
                itemCount: itemsList != null ? itemsList.length : 0,
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Item',
        onPressed: () => {
          showDialog(
              context: context,
              builder: (BuildContext context2) {
                return AlertDialog(
                    content: Container(
                        width: double.maxFinite,
                        child: ListView(children: <Widget>[
                          Container(
                              width: MediaQuery.of(context).size.width,
                              child: const Text(
                                "Name of Item and Aisle Number",
                                textAlign: TextAlign.left,
                              )),
                          TextField(
                            controller: myController,
                            textInputAction: TextInputAction.search,
                            onSubmitted: (value) {
                              addItemOverlay(context, value);
                            },
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Apple ,1'),
                          ),
                          FloatingActionButton(
                            tooltip: "Add Item",
                            onPressed: () => {
                              addItemOverlay(context, myController.text),
                              Navigator.pop(context2),
                            },
                            child: Icon(Icons.add),
                          ),
                        ])));
              })
        },
        //addItem(context), // Display widget tht adds to array in cubit
        child: const Icon(Icons.add),
      ),
    );
  }

  void removeItem(BuildContext context, row) {
    final grocerylistcubit = context.read<GroceryListCubit>();
    grocerylistcubit.removeItem(row);
  }

  void addItemOverlay(BuildContext context, String input) {
    //TODO display error message instand of simply returning to home added doesnt work
    final grocerylistcubit = context.read<GroceryListCubit>();
    if (input.contains(',')) {
      var inputSplit = input.split(',');
      if (inputSplit[0].isNotEmpty && inputSplit[1].isNotEmpty) {
        grocerylistcubit.addrow(inputSplit);
      } else {
        grocerylistcubit.returnToHome();
      }
    } else {
      grocerylistcubit.returnToHome();
    }
  }
}
