abstract class StoreListItem {
  Object get id;
}

class StoreList<T extends StoreListItem> {
  List<T> _itemListCache;

  List<Object> _itemsIds;
  Map<Object, T> _items;

  StoreList([List<T> items = const []]) {
    final filteredItems = (items ?? <T>[]).where((i) => i != null).toList();

    _itemListCache = filteredItems;
    _itemsIds = filteredItems.map((i) => i.id).toList();
    _items = Map<Object, T>.fromIterable(filteredItems,
        key: (v) => v.id, value: (v) => v);
  }

  List<T> get items {
    if (_itemListCache == null) {
      _itemListCache = _itemsIds.map((id) => _items[id]).toList();
    }
    return _itemListCache;
  }

  List<Object> get itemsIds => _itemsIds.toList();
  Map<Object, T> get itemsMap => Map<Object, T>.from(_items);

  T getItem(Object id) => _items[id];

  void updateList(List<T> items) {
    final filteredItems = items.where((i) => i != null).toList();

    _itemListCache = filteredItems;
    _itemsIds = filteredItems.map((i) => i.id).toList();

    filteredItems.forEach((i) => _items[i.id] = i);
  }

  void addItem(Object id, T value) {
    if (id == null || value == null) {
      return;
    }

    _itemListCache.add(value);

    _items[id] = value;
    _itemsIds.add(id);
  }

  void updateItem(Object id, T value) {
    _itemListCache = null;
    _items[id] = value;
  }

  void deleteItem(Object id) {
    _itemListCache = null;

    _items.remove(id);
    _itemsIds = _itemsIds.where((i) => i != id).toList();
  }
}
