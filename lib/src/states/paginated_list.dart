import 'package:flutter/material.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:dash_kit_core/src/states/request_state.dart';

class PaginatedList<T extends StoreListItem> {
  const PaginatedList({
    @required this.items,
    @required this.loadListRequestState,
    @required this.loadPageRequestState,
    @required this.isAllItemsLoaded,
  })  : assert(items != null),
        assert(loadListRequestState != null),
        assert(loadPageRequestState != null),
        assert(isAllItemsLoaded != null);

  PaginatedList.empty()
      : this(
          items: StoreList<T>(),
          loadListRequestState: RequestState.idle,
          loadPageRequestState: RequestState.idle,
          isAllItemsLoaded: false,
        );

  final StoreList<T> items;
  final RequestState loadListRequestState;
  final RequestState loadPageRequestState;
  final bool isAllItemsLoaded;

  PaginatedList<T> update({
    StoreList<T> items,
    RequestState loadListRequestState,
    RequestState loadPageRequestState,
    bool isAllItemsLoaded,
  }) {
    return PaginatedList(
      items: items ?? this.items,
      loadListRequestState: loadListRequestState ?? this.loadListRequestState,
      loadPageRequestState: loadPageRequestState ?? this.loadPageRequestState,
      isAllItemsLoaded: isAllItemsLoaded ?? this.isAllItemsLoaded,
    );
  }
}
