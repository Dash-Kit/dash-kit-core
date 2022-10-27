import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:flutter_test/flutter_test.dart';

class NumberStoreListItem extends StoreListItem {
  NumberStoreListItem(this.id);

  @override
  final int id;
}

void main() {
  test('Initialisation with empty list', () {
    final storeList1 = StoreList(<StoreListItem>[]);
    expect(storeList1.items.isEmpty, true);
  });

  test('Initialisation with not empty list', () {
    final storeList = StoreList([
      NumberStoreListItem(1),
      NumberStoreListItem(2),
      NumberStoreListItem(3),
    ]);

    expect(storeList.itemsIds, equals([1, 2, 3]));
    expect(storeList.items.map((i) => i.id), equals([1, 2, 3]));

    final itemMapKeys = storeList.itemsMap.keys.toList();
    itemMapKeys.sort();
    expect(itemMapKeys, equals([1, 2, 3]));
  });

  test('Null item is ignored on adding it to list', () {
    final storeList = StoreList(<StoreListItem>[NumberStoreListItem(1)]);

    storeList.addItem(null, null);

    expect(storeList.itemsIds, equals([1]));
    expect(storeList.items.map((i) => i.id), equals([1]));
    expect(storeList.itemsMap.keys.toList(), equals([1]));
  });

  test('Incorrect id is ignored on updating item in list', () {
    final storeList = StoreList(<StoreListItem>[NumberStoreListItem(1)]);

    expect(storeList.itemsIds, equals([1]));
    expect(storeList.items.map((i) => i.id), equals([1]));

    final updatedStoreList = storeList.updateItem(2, NumberStoreListItem(3));

    expect(updatedStoreList.itemsIds, equals([1]));
    expect(updatedStoreList.items.map((i) => i.id), equals([1]));
  });

  test('Item is deleted from list', () {
    final storeList = StoreList([
      NumberStoreListItem(1),
      NumberStoreListItem(2),
      NumberStoreListItem(3),
    ]);

    final updatedStoreList = storeList.deleteItem(2);

    expect(updatedStoreList.itemsIds, equals([1, 3]));
    expect(updatedStoreList.items.map((i) => i.id), equals([1, 3]));
  });

  test('Incorrect id is ignored on deleting item from list', () {
    final storeList = StoreList([
      NumberStoreListItem(1),
      NumberStoreListItem(2),
      NumberStoreListItem(3),
    ]);

    expect(storeList.itemsIds, equals([1, 2, 3]));
    expect(storeList.items.map((i) => i.id), equals([1, 2, 3]));

    storeList.deleteItem(4);

    expect(storeList.itemsIds, equals([1, 2, 3]));
    expect(storeList.items.map((i) => i.id), equals([1, 2, 3]));
  });

  test('All of items were added', () {
    final storeList = StoreList([
      NumberStoreListItem(1),
      NumberStoreListItem(2),
      NumberStoreListItem(3),
    ]);

    expect(storeList.itemsIds, equals([1, 2, 3]));
    expect(storeList.items.map((i) => i.id), equals([1, 2, 3]));

    final updatedStoreList = storeList.addAll([
      NumberStoreListItem(4),
      NumberStoreListItem(5),
      NumberStoreListItem(6),
    ]);

    expect(updatedStoreList.itemsIds, equals([1, 2, 3, 4, 5, 6]));
    expect(updatedStoreList.items.map((i) => i.id), equals([1, 2, 3, 4, 5, 6]));
  });
}
