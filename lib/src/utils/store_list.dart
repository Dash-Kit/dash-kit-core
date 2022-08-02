import 'package:built_collection/built_collection.dart';
import 'package:dash_kit_core/dash_kit_core.dart';

abstract class StoreListItem {
  Object get id;
}

class StoreList<T extends StoreListItem> {
  BuiltList<T>? _itemListCache;

  BuiltList<Object> _itemsIds;
  BuiltMap<Object, T> _items;

  StoreList._(this._itemsIds, this._items, this._itemListCache);

  factory StoreList([Iterable<T> list = const []]) {
    final filteredItems = list.toBuiltList();

    final itemListCache = filteredItems;
    final itemsIds = filteredItems.map((i) => i.id).toBuiltList();
    final items = Map<Object, T>.fromIterable(
      filteredItems,
      key: (v) => v.id,
      value: (v) => v,
    ).build();

    return StoreList._(itemsIds, items, itemListCache);
  }

  BuiltList<T> get items {
    _itemListCache ??= _itemsIds.map((id) => _items[id]!).toBuiltList();

    return _itemListCache!;
  }

  BuiltList<Object> get itemsIds => _itemsIds;

  BuiltMap<Object, T> get itemsMap => _items;

  T? getItem(Object id) => _items[id];

  StoreList<T> addItem(Object? id, T? value) {
    if (id == null || value == null) {
      return this;
    }

    final updatedItems = items.rebuild((b) => b.add(value));

    return StoreList(updatedItems);
  }

  StoreList<T> addAll(Iterable<T> values) {
    if (values.isEmpty) {
      return this;
    }

    final updatedItems = items.rebuild((b) => b.addAll(values));

    return StoreList(updatedItems);
  }

  StoreList<T> updateItem(Object? id, T? value) {
    if (id == null || value == null) {
      return this;
    }

    final updateIndex = items.indexWhere((e) => e.id == id);

    if (updateIndex < 0) {
      return this;
    }

    final updatedItems = items.rebuild((b) => b[updateIndex] = value);

    return StoreList(updatedItems);
  }

  StoreList<T> deleteItem(Object id) {
    final updatedItems = items.rebuild((b) => b.removeWhere((e) => e.id == id));

    return StoreList(updatedItems);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoreList &&
          runtimeType == other.runtimeType &&
          _items == other._items;

  @override
  int get hashCode => _items.hashCode;
}
