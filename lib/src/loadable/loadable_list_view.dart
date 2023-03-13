import 'package:dash_kit_core/src/loadable/pagination_state.dart';
import 'package:dash_kit_core/src/states/operation_state.dart';
import 'package:dash_kit_core/src/utils/store_list.dart';
import 'package:flutter/material.dart';

typedef ScrollListener = void Function({
  required double offset,
  required double maxScrollExtent,
});

class LoadableListView<T extends StoreListItem> extends StatefulWidget {
  const LoadableListView({
    required this.viewModel,
    this.scrollPhysics = const AlwaysScrollableScrollPhysics(),
    this.onChangeContentOffset,
    this.cacheExtent,
    this.shrinkWrap = false,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.progressIndicator = const CircularProgressIndicator(),
    this.scrollController,
    super.key,
  });

  final LoadableListViewModel<T> viewModel;
  final ScrollPhysics scrollPhysics;
  final ScrollListener? onChangeContentOffset;
  final double? cacheExtent;
  final bool shrinkWrap;
  final Axis scrollDirection;
  final bool reverse;
  final Widget progressIndicator;
  final ScrollController? scrollController;

  @override
  State<StatefulWidget> createState() {
    return LoadableListViewState<T>();
  }
}

class LoadableListViewState<T extends StoreListItem>
    extends State<LoadableListView> {
  late final ScrollController scrollController;

  LoadableListViewModel<T> get viewModel =>
      widget.viewModel as LoadableListViewModel<T>;

  @override
  void initState() {
    super.initState();
    if (viewModel.loadListRequestState.isIdle) {
      viewModel.loadList?.call();
    }

    scrollController = widget.scrollController ?? ScrollController();
    scrollController.addListener(_onScrollChanged);
  }

  @override
  Widget build(BuildContext context) {
    final state = viewModel.getPaginationState();

    switch (state) {
      case PaginationState.loading:
        return buildProgressState();
      case PaginationState.empty:
        return buildEmptyState();
      case PaginationState.error:
        return buildErrorState();
      default:
        break;
    }

    return CustomScrollView(
        key: viewModel.key,
        shrinkWrap: widget.shrinkWrap,
        physics: widget.scrollPhysics,
        controller: scrollController,
        cacheExtent: widget.cacheExtent,
        scrollDirection: widget.scrollDirection,
        reverse: widget.reverse,
        slivers: [
          if (viewModel.header != null)
            SliverToBoxAdapter(child: viewModel.header),
          SliverPadding(
            padding: viewModel.padding ?? EdgeInsets.zero,
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Column(
                    children: [
                      buildListItem(context, index),
                      if (index != viewModel.itemsCount - 1)
                        buildSeparator(context, index),
                    ],
                  );
                },
                childCount: viewModel.itemsCount,
              ),
            ),
          ),
          if (viewModel.footer != null) buildFooter(),
        ]);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController
      ..removeListener(_onScrollChanged)
      ..dispose();
  }

  Widget buildProgressState() {
    return Container(
      padding: viewModel.padding,
      alignment: Alignment.center,
      child: widget.progressIndicator,
    );
  }

  Widget buildErrorState() {
    return viewModel.errorWidget;
  }

  Widget buildEmptyState() {
    return viewModel.emptyStateWidget;
  }

  Widget getLoadingWidget() {
    return Center(
      child: widget.progressIndicator,
    );
  }

  Widget buildListItem(BuildContext context, int index) {
    return viewModel.itemBuilder(index);
  }

  Widget buildSeparator(BuildContext context, int index) {
    return viewModel.itemSeparator(index);
  }

  Widget buildFooter() {
    return SliverToBoxAdapter(child: viewModel.footer);
  }

  void _onScrollChanged() {
    widget.onChangeContentOffset?.call(
      offset: scrollController.position.pixels,
      maxScrollExtent: scrollController.position.maxScrollExtent,
    );
  }
}

class LoadableListViewModel<Item extends StoreListItem> {
  const LoadableListViewModel({
    required this.items,
    required this.itemBuilder,
    required this.emptyStateWidget,
    required this.loadListRequestState,
    required this.errorWidget,
    required this.itemSeparator,
    this.loadList,
    this.padding,
    this.header,
    this.footer,
    this.key,
  });

  final StoreList<Item> items;
  final Widget Function(int) itemBuilder;
  final Widget Function(int) itemSeparator;
  final Widget errorWidget;
  final Widget emptyStateWidget;
  final OperationState loadListRequestState;
  final VoidCallback? loadList;
  final EdgeInsets? padding;
  final Widget? header;
  final Widget? footer;
  final Key? key;

  int get itemsCount => items.items.length;

  PaginationState getPaginationState() {
    if (loadListRequestState.isFailed) {
      return PaginationState.error;
    }

    if (loadListRequestState.isInProgress) {
      return PaginationState.loading;
    }

    if (loadListRequestState.isSucceed && items.items.isEmpty) {
      return PaginationState.empty;
    }

    return PaginationState.idle;
  }
}
