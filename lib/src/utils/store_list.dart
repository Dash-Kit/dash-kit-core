import 'package:built_collection/built_collection.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:flutter/material.dart';

@immutable
class StoreList<T extends StoreListItem> {
  factory StoreList([Iterable<T> list = const []]) {
    final filteredItems = list.toBuiltList();

    final itemListCache = filteredItems;
    final itemsIds = filteredItems.map((i) => i.id).toBuiltList();
    final items = {for (final v in filteredItems) v.id: v}.build();

    return StoreList._(itemsIds, items, itemListCache);
  }

  const StoreList._(this._itemsIds, this._items, this._itemListCache);

  final BuiltList<T> _itemListCache;
  final BuiltList<Object> _itemsIds;
  final BuiltMap<Object, T> _items;

  /// Returns a [BuiltList] objects type of [T].
  BuiltList<T> get items => _itemListCache;

  /// Returns a [BuiltList] items id`s type of [Object].
  BuiltList<Object> get itemsIds => _itemsIds;

  /// Returns a [BuiltMap] objects with key [Object] and type [T].
  BuiltMap<Object, T> get itemsMap => _items;

  @override
  int get hashCode => _items.hashCode;

  /// Returns a [T] object by [id].
  T? getItem(Object id) => _items[id];

  /// Returns a [StoreList] with added [value] object.
  StoreList<T> addItem(Object? id, T? value) {
    final self = this;

    if (id == null || value == null) {
      return self;
    }

    final updatedItems = items.rebuild((b) => b.add(value));

    return StoreList(updatedItems);
  }

  /// Returns a [StoreList] with added [values] objects.
  StoreList<T> addAll(Iterable<T> values) {
    final self = this;

    if (values.isEmpty) {
      return self;
    }

    final updatedItems = items.rebuild((b) => b.addAll(values));

    return StoreList(updatedItems);
  }

  /// Returns a [StoreList] with updated by [id] identificator [value] object.
  StoreList<T> updateItem(Object? id, T? value) {
    final self = this;

    if (id == null || value == null) {
      return self;
    }

    final updateIndex = items.indexWhere((e) => e.id == id);

    if (updateIndex < 0) {
      return self;
    }

    final updatedItems = items.rebuild((b) => b[updateIndex] = value);

    return StoreList(updatedItems);
  }

  /// Returns a [StoreList] with removed by [id] object.
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
}

abstract class StoreListItem {
  // ignore: no-object-declaration
  Object get id;
}
