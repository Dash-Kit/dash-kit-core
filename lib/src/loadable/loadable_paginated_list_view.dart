import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:flutter/material.dart';

class LoadablePaginatedListView<T extends StoreListItem>
    extends LoadableListView<T> {
  const LoadablePaginatedListView({
    required LoadablePaginatedListViewModel<T> viewModel,
    Key? key,
    ScrollPhysics scrollPhysics = const AlwaysScrollableScrollPhysics(),
    double? cacheExtent,
    bool shrinkWrap = false,
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    void Function(double offset)? onChangeContentOffset,
  }) : super(
          key: key,
          viewModel: viewModel,
          scrollPhysics: scrollPhysics,
          onChangeContentOffset: onChangeContentOffset,
          cacheExtent: cacheExtent,
          shrinkWrap: shrinkWrap,
          scrollDirection: scrollDirection,
          reverse: reverse,
        );

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

  Widget _getLastItem(PaginationState state) {
    switch (state) {
      case PaginationState.loadingPage:
        return _getProgressPageWidget(scrollController);

      case PaginationState.errorLoadingPage:
        return _getErrorPageWidget();

      case PaginationState.succeedLoadingPage:
        if (viewModel.paginatedList.isAllItemsLoaded) {
          return viewModel.endListWidget ?? const SizedBox.shrink();
        }

        return const SizedBox.shrink();

      default:
        return const SizedBox.shrink();
    }
  }

  Widget _getProgressPageWidget(ScrollController scrollController) {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => scrollController.animateTo(
              scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 100),
              curve: Curves.linear,
            ));

    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(top: 8),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _getErrorPageWidget() {
    return viewModel.errorPageWidget;
  }

  void _onScrollChanged() {
    final canLoad = (viewModel.loadPageRequestState.isSucceed ||
            viewModel.loadPageRequestState.isIdle) &&
        viewModel.paginatedList.isAllItemsLoaded == false;

    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        canLoad) {
      viewModel.loadPage?.call();
    }
  }
}

class LoadablePaginatedListViewModel<Item extends StoreListItem>
    extends LoadableListViewModel<Item> {
  LoadablePaginatedListViewModel({
    Key? key,
    required Widget Function(int) itemBuilder,
    required Widget Function(int) itemSeparator,
    required Widget errorWidget,
    required Widget emptyStateWidget,
    required OperationState loadListRequestState,
    required OperationState loadPageRequestState,
    required this.paginatedList,
    required this.errorPageWidget,
    VoidCallback? loadList,
    EdgeInsets? padding,
    Widget? endListWidget,
    this.loadPage,
  }) : super(
          items: paginatedList.items,
          itemBuilder: itemBuilder,
          itemSeparator: itemSeparator,
          errorWidget: errorWidget,
          emptyStateWidget: emptyStateWidget,
          loadListRequestState: loadListRequestState,
          loadPageRequestState: loadPageRequestState,
          loadList: loadList,
          padding: padding,
          endListWidget: endListWidget,
          key: key,
        );

  final VoidCallback? loadPage;
  final PaginatedList<Item> paginatedList;
  final Widget errorPageWidget;

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
