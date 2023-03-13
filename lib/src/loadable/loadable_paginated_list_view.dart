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
  void initState() {
    super.initState();

    scrollController.addListener(_onScrollChanged);
  }

  @override
  Widget buildListItem(BuildContext context, int index) {
    return index == viewModel.itemsCount - 1
        ? _getLastItem(viewModel.getPaginationState())
        : super.buildListItem(context, index);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.removeListener(_onScrollChanged);
  }

  @override
  Widget buildFooter() {
    return SliverToBoxAdapter(
      child: viewModel.paginatedList.isAllItemsLoaded ? viewModel.footer : null,
    );
  }

  Widget _getLastItem(PaginationState state) {
    switch (state) {
      case PaginationState.loadingPage:
        return _getProgressPageWidget(scrollController);

      case PaginationState.errorLoadingPage:
        return _getErrorPageWidget();

      default:
        return const SizedBox.shrink();
    }
  }

  Widget _getProgressPageWidget(ScrollController scrollController) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(top: 8),
      child: Center(child: widget.progressIndicator),
    );
  }

  Widget _getErrorPageWidget() {
    return viewModel.errorPageWidget;
  }

  void _onScrollChanged() {
    final canLoad = (viewModel.loadPageRequestState.isSucceed ||
            viewModel.loadPageRequestState.isIdle) &&
        viewModel.paginatedList.isAllItemsLoaded == false;
    final maxScrollExtent =
        scrollController.position.maxScrollExtent - (widget.cacheExtent ?? 0);

    if (scrollController.position.pixels >= maxScrollExtent && canLoad) {
      viewModel.loadPage?.call();
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
    required this.loadPageRequestState,
    required this.paginatedList,
    required this.errorPageWidget,
    super.loadList,
    super.padding,
    super.sliverHeader,
    super.header,
    super.footer,
    this.loadPage,
    super.key,
  }) : super(items: paginatedList.items);

  final VoidCallback? loadPage;
  final PaginatedList<Item> paginatedList;
  final Widget errorPageWidget;
  final OperationState loadPageRequestState;

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
