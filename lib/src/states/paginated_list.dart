import 'package:flutter/material.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';
import 'package:flutter_platform_core/src/states/refreshable_request_state.dart';
import 'package:flutter_platform_core/src/states/request_state.dart';

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
          loadListRequestState: RefreshableRequestState.idle,
          loadPageRequestState: RequestState.idle,
          isAllItemsLoaded: false,
        );
  final StoreList<T> items;
  final RefreshableRequestState loadListRequestState;
  final RequestState loadPageRequestState;
  final bool isAllItemsLoaded;

  PaginatedList<T> update({
    StoreList<T> items,
    RefreshableRequestState loadListRequestState,
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
