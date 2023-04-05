import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:flutter/material.dart';

@immutable
class PaginatedList<T extends StoreListItem> {
  const PaginatedList({
    required this.items,
    required this.isAllItemsLoaded,
  });

  PaginatedList.withTotalCount({
    required this.items,
    required int totalCount,
  }) : isAllItemsLoaded = items.items.length >= totalCount;

  PaginatedList.empty()
      : this(
          items: StoreList<T>(),
          isAllItemsLoaded: true,
        );

  final StoreList<T> items;
  final bool isAllItemsLoaded;

  @override
  int get hashCode => items.hashCode ^ isAllItemsLoaded.hashCode;

  PaginatedList<T> update({
    StoreList<T>? items,
    bool? isAllItemsLoaded,
  }) {
    assert(items != null, 'You should update the list first');

    return PaginatedList(
      items: items ?? this.items,
      isAllItemsLoaded: isAllItemsLoaded ?? this.isAllItemsLoaded,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaginatedList &&
          runtimeType == other.runtimeType &&
          items == other.items &&
          isAllItemsLoaded == other.isAllItemsLoaded;
}
