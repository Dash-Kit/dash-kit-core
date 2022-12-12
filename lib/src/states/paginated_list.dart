import 'package:dash_kit_core/dash_kit_core.dart';

class PaginatedList<T extends StoreListItem> extends StoreList<T> {
  PaginatedList({
    required List<T> items,
    required this.totalCount,
  }) : super(items);

  PaginatedList.empty()
      : this(
          items: <T>[],
          totalCount: 0,
        );

  final int totalCount;

  late final bool isAllItemsLoaded = items.length >= totalCount;

  PaginatedList<T> update({
    List<T>? items,
    int? totalCount,
  }) {
    return PaginatedList(
      items: items ?? this.items.toList(),
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
