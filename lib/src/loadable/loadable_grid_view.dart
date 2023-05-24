import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:flutter/material.dart';

class LoadableGridView<T extends StoreListItem> extends StatefulWidget {
  const LoadableGridView({
    required this.viewModel,
    this.onChangeContentOffset,
    this.scrollController,
    super.key,
  });

  final LoadableGridViewModel<T> viewModel;
  final ScrollListener? onChangeContentOffset;
  final ScrollController? scrollController;

  @override
  State<StatefulWidget> createState() {
    return LoadableGridViewState<T>();
  }
}

class LoadableGridViewState<T extends StoreListItem>
    extends State<LoadableGridView> {
  LoadableGridViewModel<T> get viewModel =>
      widget.viewModel as LoadableGridViewModel<T>;

  @override
  void initState() {
    super.initState();
    if (viewModel.loadList != null && viewModel.loadListRequestState.isIdle) {
      viewModel.loadList!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = viewModel.getPaginationState();

    switch (state) {
      case PaginationState.loading:
        return Container(
          padding: viewModel.padding,
          alignment: Alignment.center,
          child: const CircularProgressIndicator(),
        );
      case PaginationState.empty:
        return viewModel.emptyStateWidget;
      case PaginationState.error:
        return viewModel.errorWidget;
      default:
        break;
    }

    return NotificationListener<ScrollEndNotification>(
      onNotification: onScrollChanged,
      child: CustomScrollView(
        key: viewModel.key,
        shrinkWrap: viewModel.shrinkWrap,
        physics: viewModel.physics ?? const AlwaysScrollableScrollPhysics(),
        controller: widget.scrollController,
        slivers: <Widget>[
          if (viewModel.header != null) viewModel.header!,
          SliverPadding(
            padding: viewModel.padding!,
            sliver: SliverGrid(
              gridDelegate: viewModel.gridDelegate,
              delegate: SliverChildBuilderDelegate(
                buildListItem,
                childCount: viewModel.itemsCount,
              ),
            ),
          ),
          SliverToBoxAdapter(
            // ignore: avoid-returning-widgets
            child: getLastItem(),
          ),
        ],
      ),
    );
  }

  Widget getLoadingWidget() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildListItem(BuildContext _, int index) {
    return viewModel.itemBuilder(index);
  }

  Widget getLastItem() {
    return const SizedBox.shrink();
  }

  bool onScrollChanged(ScrollNotification scrollInfo) =>
      widget.onChangeContentOffset?.call(
        offset: scrollInfo.metrics.pixels,
        maxScrollExtent: scrollInfo.metrics.maxScrollExtent,
      ) ??
      false;
}

class LoadableGridViewModel<Item extends StoreListItem> {
  const LoadableGridViewModel({
    required this.itemBuilder,
    required this.items,
    required this.loadListRequestState,
    required this.errorWidget,
    required this.emptyStateWidget,
    required this.gridDelegate,
    this.loadPageRequestState,
    this.key,
    this.loadList,
    this.physics,
    this.padding,
    this.header,
    this.shrinkWrap = false,
  });

  final Key? key;
  final Widget errorWidget;
  final Widget emptyStateWidget;
  final Widget Function(int) itemBuilder;
  final VoidCallback? loadList;
  final EdgeInsets? padding;
  final StoreList<Item> items;
  final OperationState loadListRequestState;
  final OperationState? loadPageRequestState;
  final SliverGridDelegate gridDelegate;
  final ScrollPhysics? physics;
  final Widget? header;
  final bool shrinkWrap;

  int get itemsCount => items.items.length;

  PaginationState getPaginationState() {
    if (loadListRequestState.isFailed) {
      return PaginationState.error;
    } else if (loadListRequestState.isInProgress) {
      return PaginationState.loading;
    } else if (loadListRequestState.isSucceed && items.items.isEmpty) {
      return PaginationState.empty;
    }

    return PaginationState.idle;
  }
}
