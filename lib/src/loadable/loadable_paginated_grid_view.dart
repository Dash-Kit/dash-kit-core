import 'package:dash_kit_core/src/loadable/loadable_grid_view.dart';
import 'package:dash_kit_core/src/loadable/pagination_state.dart';
import 'package:flutter/material.dart';
import 'package:dash_kit_core/dash_kit_core.dart' hide PaginationState;

class LoadablePaginatedGridView<T extends StoreListItem>
    extends LoadableGridView<T> {
  const LoadablePaginatedGridView({
    Key? key,
    required LoadablePaginatedGridViewModel<T> viewModel,
    void Function(double offset)? onChangeContentOffset,
  }) : super(
    key: key,
    viewModel: viewModel,
    onChangeContentOffset: onChangeContentOffset,
  );

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
  void initState() {
    super.initState();

    scrollController.addListener(() {
      final canLoad = viewModel.loadPageRequestState == null
          ? false
          : (viewModel.loadPageRequestState!.isSucceed ||
          viewModel.loadPageRequestState!.isIdle) &&
          viewModel.paginatedList.isAllItemsLoaded == false;

      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent &&
          canLoad) {
        viewModel.loadPage!();
      }
    });
  }

  @override
  Widget getLastItem() {
    switch (viewModel.getPaginationState()) {
      case PaginationState.loadingPage:
        return _getProgressPageWidget(scrollController);

      case PaginationState.errorLoadingPage:
        return _getErrorPageWidget();

      default:
        return Container();
    }
  }

  Widget _getProgressPageWidget(ScrollController scrollController) {
    WidgetsBinding.instance!
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
}

class LoadablePaginatedGridViewModel<Item extends StoreListItem>
    extends LoadableGridViewModel<Item> {
  LoadablePaginatedGridViewModel({
    Key? key,
    required Widget errorWidget,
    required Widget emptyStateWidget,
    required Widget Function(int) itemBuilder,
    required SliverGridDelegate gridDelegate,
    required OperationState loadListRequestState,
    required OperationState loadPageRequestState,
    required this.paginatedList,
    required this.errorPageWidget,
    VoidCallback? loadList,
    EdgeInsets? padding,
    Widget? header,
    this.loadPage,
  }) : super(
    items: paginatedList.items,
    loadListRequestState: loadListRequestState,
    loadPageRequestState: loadPageRequestState,
    itemBuilder: itemBuilder,
    loadList: loadList,
    errorWidget: errorWidget,
    emptyStateWidget: emptyStateWidget,
    padding: padding,
    key: key,
    gridDelegate: gridDelegate,
    header: header,
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
