part of 'grocery_list_cubit.dart';

@immutable
abstract class GroceryListState {
  const GroceryListState();
}

class GroceryListStateInitial extends GroceryListState {
  final List<RowItem> emptyItemsList;
  const GroceryListStateInitial(this.emptyItemsList);
}

class GroceryListStateAdded extends GroceryListState {
  final List<RowItem> items;
  const GroceryListStateAdded(this.items);

  @override //?
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is GroceryListStateAdded && o.items == items;
  }

  @override
  int get hashCode => items.hashCode;
}

class GroceryListStateItemDescription extends GroceryListState {
  final RowItem item;
  const GroceryListStateItemDescription(this.item);

  @override //?
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is GroceryListStateAdded && o.items == item;
  }

  @override
  int get hashCode => item.hashCode;
}
