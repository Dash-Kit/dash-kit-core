import 'package:dash_kit_core/dash_kit_core.dart';

class PaginatedList<T extends StoreListItem> {
  PaginatedList({
    required this.items,
    required this.totalCount,
  });

  PaginatedList.empty()
      : this(
          items: StoreList<T>(),
          totalCount: 0,
        );

  final StoreList<T> items;
  final int totalCount;

  late final bool isAllItemsLoaded = items.items.length >= totalCount;

  PaginatedList<T> update({
    StoreList<T>? items,
    int? totalCount,
  }) {
    return PaginatedList(
      items: items ?? this.items,
      totalCount: totalCount ?? this.totalCount,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaginatedList &&
          runtimeType == other.runtimeType &&
          items == other.items &&
          totalCount == other.totalCount;

  @override
  int get hashCode => items.hashCode ^ totalCount.hashCode;
}
