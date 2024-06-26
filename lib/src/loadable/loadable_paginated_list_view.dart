import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:flutter/material.dart';

class LoadablePaginatedListView<T extends StoreListItem>
    extends LoadableListView<T> {
  const LoadablePaginatedListView({
    required LoadablePaginatedListViewModel<T> super.viewModel,
    super.key,
    super.scrollPhysics,
    super.cacheExtent,
    super.shrinkWrap,
    super.scrollDirection,
    super.reverse,
    super.onChangeContentOffset,
    super.progressIndicator,
    super.scrollController,
  });

  @override
  State<StatefulWidget> createState() {
    return LoadablePaginatedListState<T>();
  }
}

class LoadablePaginatedListState<T extends StoreListItem>
    extends LoadableListViewState<T> {
  @override
  LoadablePaginatedListViewModel<T> get viewModel =>
      widget.viewModel as LoadablePaginatedListViewModel<T>;

  @override
  Widget buildListItem(int index) {
    return index == viewModel.itemsCount - 1
        // ignore: avoid-returning-widgets
        ? _getLastItem(viewModel.getPaginationState())
        : super.buildListItem(index);
  }

  @override
  Widget buildFooter() {
    return SliverToBoxAdapter(
      child: viewModel.isAllItemsLoaded ? viewModel.footer : null,
    );
  }

  @override
  bool onScrollChanged(ScrollNotification scrollInfo) {
    super.onScrollChanged(scrollInfo);
    final canLoad = (viewModel.loadPageRequestState.isSucceed ||
            viewModel.loadPageRequestState.isIdle) &&
        !viewModel.isAllItemsLoaded;
    final maxScrollExtent =
        scrollInfo.metrics.maxScrollExtent - (widget.cacheExtent ?? 0);

    if (scrollInfo.metrics.pixels >= maxScrollExtent && canLoad) {
      viewModel.loadPage?.call();

      return true;
    }

    return false;
  }

  Widget _getLastItem(PaginationState state) {
    switch (state) {
      case PaginationState.loadingPage:
        return Container(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.only(top: 8),
          child: Center(child: widget.progressIndicator),
        );

      case PaginationState.errorLoadingPage:
        return viewModel.errorPageWidget;

      default:
        return const SizedBox.shrink();
    }
  }
}

class LoadablePaginatedListViewModel<Item extends StoreListItem>
    extends LoadableListViewModel<Item> {
  LoadablePaginatedListViewModel({
    required super.itemBuilder,
    required super.itemSeparator,
    required super.errorWidget,
    required super.emptyStateWidget,
    required super.loadListRequestState,
    required super.items,
    required this.loadPageRequestState,
    required this.errorPageWidget,
    required this.isAllItemsLoaded,
    super.loadList,
    super.padding,
    super.sliverHeader,
    super.header,
    super.footer,
    this.loadPage,
    super.key,
  });

  final VoidCallback? loadPage;
  final Widget errorPageWidget;
  final OperationState loadPageRequestState;
  final bool isAllItemsLoaded;

  @override
  int get itemsCount => super.itemsCount + 1;

  @override
  PaginationState getPaginationState() {
    final paginationState = super.getPaginationState();
    if (paginationState != PaginationState.idle) {
      return paginationState;
    }

    if (loadPageRequestState.isFailed) {
      return PaginationState.errorLoadingPage;
    } else if (loadPageRequestState.isInProgress) {
      return PaginationState.loadingPage;
    } else if (loadPageRequestState.isSucceed) {
      return PaginationState.succeedLoadingPage;
    }

    return PaginationState.idle;
  }
}
