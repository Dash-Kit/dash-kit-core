import 'package:built_collection/built_collection.dart';

abstract class StoreListItem {
  Object get id;
}

class StoreList<T extends StoreListItem> {
  BuiltList<T> _itemListCache;

  BuiltList<Object> _itemsIds;
  BuiltMap<Object, T> _items;

  StoreList([List<T> items = const []]) {
    final filteredItems =
        (items ?? <T>[]).where((i) => i != null).toBuiltList();

    _itemListCache = filteredItems;
    _itemsIds = filteredItems.map((i) => i.id).toBuiltList();
    _items = Map<Object, T>.fromIterable(
      filteredItems,
      key: (v) => v.id,
      value: (v) => v,
    ).build();
  }

  BuiltList<T> get items {
    _itemListCache ??= _itemsIds.map((id) => _items[id]).toBuiltList();

    return _itemListCache;
  }

  BuiltList<Object> get itemsIds => _itemsIds;

  BuiltMap<Object, T> get itemsMap => _items;

  T getItem(Object id) => _items[id];

  void updateList(List<T> items) {
    final filteredItems = items.where((i) => i != null).toBuiltList();

    _itemListCache = filteredItems;
    _itemsIds = filteredItems.map((i) => i.id).toBuiltList();

    filteredItems.forEach((i) => _items = _items.rebuild((b) => b[i.id] = i));
  }

  void addItem(Object id, T value) {
    if (id == null || value == null) {
      return;
    }

    _itemListCache = _itemListCache.rebuild((b) => b.add(value));

    _items = _items.rebuild((b) => b[id] = value);
    _itemsIds = _itemsIds.rebuild((b) => b.add(id));
  }

  void addAll(List<T> values) {
    if (values == null || values.isEmpty) {
      return;
    }

    _itemListCache = _itemListCache.rebuild((b) => b.addAll(values));

    _items = _items.rebuild(
      (b) => values.forEach((value) => b[value.id] = value),
    );

    _itemsIds = _itemsIds.rebuild(
      (b) => b.addAll(values.map((item) => item.id).toList()),
    );
  }

  void updateItem(Object id, T value) {
    _itemListCache = null;
    _items = _items.rebuild((b) => b[id] = value);
  }

  void deleteItem(Object id) {
    _itemListCache = null;

    _items = _items.rebuild((b) => b.remove(id));
    _itemsIds = _itemsIds.rebuild((b) => b.removeWhere((i) => i == id));
  }

  void clear() {
    _itemListCache = null;

    _items = _items.rebuild((b) => b.clear());
    _itemsIds = _itemsIds.rebuild((b) => b.clear());
  }
}
