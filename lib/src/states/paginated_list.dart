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
    int? newTotalCount,
  }) {
    return PaginatedList(
      items: items ?? this.items,
      totalCount: newTotalCount ?? totalCount,
    );
  }
}
