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
  final void Function(double offset)? onChangeContentOffset;
  final ScrollController? scrollController;

  @override
  State<StatefulWidget> createState() {
    return LoadableGridViewState<T>();
  }
}

class LoadableGridViewState<T extends StoreListItem>
    extends State<LoadableGridView> {
  late final ScrollController scrollController;

  LoadableGridViewModel<T> get viewModel =>
      widget.viewModel as LoadableGridViewModel<T>;

  @override
  void initState() {
    super.initState();
    if (viewModel.loadList != null && viewModel.loadListRequestState.isIdle) {
      viewModel.loadList!();
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
        shrinkWrap: viewModel.shrinkWrap,
        physics: const AlwaysScrollableScrollPhysics(),
        controller: scrollController,
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
            child: getLastItem(),
          ),
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
      child: const CircularProgressIndicator(),
    );
  }

  Widget buildErrorState() {
    return viewModel.errorWidget;
  }

  Widget buildEmptyState() {
    return viewModel.emptyStateWidget;
  }

  Widget getLoadingWidget() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildListItem(BuildContext context, int index) {
    return viewModel.itemBuilder(index);
  }

  Widget getLastItem() {
    return const SizedBox.shrink();
  }

  void _onScrollChanged() {
    widget.onChangeContentOffset?.call(scrollController.position.pixels);
  }
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
