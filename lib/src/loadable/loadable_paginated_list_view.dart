import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:flutter/material.dart';

class LoadablePaginatedListView extends LoadableListView {
  const LoadablePaginatedListView({
    required LoadablePaginatedListViewModel super.viewModel,
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
    return LoadablePaginatedListState();
  }
}

class LoadablePaginatedListState extends LoadableListViewState {
  @override
  LoadablePaginatedListViewModel get viewModel =>
      widget.viewModel as LoadablePaginatedListViewModel;

  @override
  int get actualItemsCount => viewModel.itemCount + 1;

  @override
  Widget buildListItem(int index) {
    return index == actualItemsCount - 1
        // ignore: avoid-returning-widgets
        ? buildLastItem(viewModel.getPaginationState())
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

  @override
  Widget buildLastItem(PaginationState state) {
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

class LoadablePaginatedListViewModel extends LoadableListViewModel {
  LoadablePaginatedListViewModel({
    required super.itemBuilder,
    required super.separatorBuilder,
    required super.errorWidget,
    required super.emptyStateWidget,
    required super.loadListRequestState,
    required super.itemCount,
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
