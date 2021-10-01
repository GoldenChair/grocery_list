import 'package:bloc/bloc.dart';
import 'package:grocery_list/Database/Database.dart';
import 'package:grocery_list/Model/item.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'grocery_list_state.dart';

class GroceryListCubit extends Cubit<GroceryListState> {
  final DatabaseProvider db = DatabaseProvider();

  GroceryListCubit(List<RowItem> empty)
      : super(
          GroceryListStateInitial(empty),
        );

  void init() async {
    List<RowItem> items = await db.getAllItems();
    emit(GroceryListStateAdded(items));
  }

  void checkItem(RowItem item) async {
    // flip value of isDone to 1 if 0 and to 0 if 1
    int checkval = (item.isDone == 0) ? 1 : 0;
    RowItem tempItem = RowItem(
        itemName: item.itemName,
        rowId: item.rowId,
        id: item.id,
        isDone: checkval);
    await db.updateItem(tempItem);
    List<RowItem> items = await db.getAllItems();
    emit(GroceryListStateAdded(items));
  }

  void addrow(List<String> inputRow) async {
    RowItem item =
        RowItem(itemName: inputRow[0], rowId: inputRow[1], id: 0, isDone: 0);
    db.insertItem(item);
    List<RowItem> items = await db.getAllItems();

    emit(GroceryListStateAdded(items));
  }

  void removeItem(RowItem item) async {
    db.deleteItem(item.id);
    List<RowItem> items = await db.getAllItems();
    emit(GroceryListStateAdded(items));
  }

  void returnToHome() async {
    List<RowItem> items = await db.getAllItems();
    emit(GroceryListStateAdded(items));
  }

  void removeAllItems() async {
    db.deleteAllItems();
    List<RowItem> items = await db.getAllItems();
    emit(GroceryListStateAdded(items));
  }

  void showItemDescription(RowItem item) {
    emit(GroceryListStateItemDescription(item));
  }
}
