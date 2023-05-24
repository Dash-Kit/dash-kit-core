import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:flutter/material.dart';

class LoadablePaginatedGridView<T extends StoreListItem>
    extends LoadableGridView<T> {
  const LoadablePaginatedGridView({
    required LoadablePaginatedGridViewModel<T> super.viewModel,
    super.onChangeContentOffset,
    super.scrollController,
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return LoadablePaginatedGridViewState<T>();
  }
}

class LoadablePaginatedGridViewState<T extends StoreListItem>
    extends LoadableGridViewState<T> {
  @override
  LoadablePaginatedGridViewModel<T> get viewModel =>
      widget.viewModel as LoadablePaginatedGridViewModel<T>;

  @override
  Widget getLastItem() {
    switch (viewModel.getPaginationState()) {
      case PaginationState.loadingPage:
        return Container(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.only(top: 8),
          child: const Center(child: CircularProgressIndicator()),
        );

      case PaginationState.errorLoadingPage:
        return viewModel.errorPageWidget;

      default:
        return Container();
    }
  }

  @override
  bool onScrollChanged(ScrollNotification scrollInfo) {
    super.onScrollChanged(scrollInfo);

    final loadPageRequestState = viewModel.loadPageRequestState;
    bool canLoad;
    if (loadPageRequestState == null) {
      canLoad = false;
    } else {
      final isSucceed = loadPageRequestState.isSucceed;
      final isIdle = loadPageRequestState.isIdle;
      final isAllItemsNotLoaded = !viewModel.paginatedList.isAllItemsLoaded;

      canLoad = (isSucceed || isIdle) && isAllItemsNotLoaded;
    }

    final currentPixelsPosition = scrollInfo.metrics.pixels;
    final maxScrollExtent = scrollInfo.metrics.maxScrollExtent;
    final isCurrentPixelsPositionEnd = currentPixelsPosition == maxScrollExtent;
    if (isCurrentPixelsPositionEnd && canLoad) {
      viewModel.loadPage!();

      return true;
    }

    return false;
  }
}

class LoadablePaginatedGridViewModel<Item extends StoreListItem>
    extends LoadableGridViewModel<Item> {
  LoadablePaginatedGridViewModel({
    required super.errorWidget,
    required super.emptyStateWidget,
    required super.itemBuilder,
    required super.gridDelegate,
    required super.loadListRequestState,
    required OperationState super.loadPageRequestState,
    required this.paginatedList,
    required this.errorPageWidget,
    super.loadList,
    super.padding,
    super.header,
    super.physics,
    this.loadPage,
    super.key,
  }) : super(
          items: paginatedList.items,
        );

  final VoidCallback? loadPage;
  final PaginatedList<Item> paginatedList;
  final Widget errorPageWidget;

  @override
  PaginationState getPaginationState() {
    final paginationState = super.getPaginationState();
    if (paginationState != PaginationState.idle) {
      return paginationState;
    }

    if (loadPageRequestState == null) {
      return PaginationState.idle;
    }

    if (loadPageRequestState!.isFailed) {
      return PaginationState.errorLoadingPage;
    } else if (loadPageRequestState!.isInProgress) {
      return PaginationState.loadingPage;
    }

    return PaginationState.idle;
  }
}
