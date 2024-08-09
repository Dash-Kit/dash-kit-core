import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:flutter/material.dart';

class LoadableGridView extends StatefulWidget {
  const LoadableGridView({
    required this.viewModel,
    this.onChangeContentOffset,
    this.scrollController,
    super.key,
  });

  final LoadableGridViewModel viewModel;
  final ScrollListener? onChangeContentOffset;
  final ScrollController? scrollController;

  @override
  State<StatefulWidget> createState() {
    return LoadableGridViewState();
  }
}

class LoadableGridViewState extends State<LoadableGridView> {
  LoadableGridViewModel get viewModel => widget.viewModel;

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
            padding: viewModel.padding ?? EdgeInsets.zero,
            sliver: SliverGrid(
              gridDelegate: viewModel.gridDelegate,
              delegate: SliverChildBuilderDelegate(
                buildListItem,
                childCount: viewModel.itemCount,
              ),
            ),
          ),
          SliverToBoxAdapter(
            // ignore: avoid-returning-widgets
            child: buildLastItem(),
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

  Widget buildListItem(BuildContext context, int index) {
    return viewModel.itemBuilder(context, index);
  }

  Widget buildLastItem() {
    return const SizedBox.shrink();
  }

  bool onScrollChanged(ScrollNotification scrollInfo) =>
      widget.onChangeContentOffset?.call(
        offset: scrollInfo.metrics.pixels,
        maxScrollExtent: scrollInfo.metrics.maxScrollExtent,
      ) ??
      false;
}

class LoadableGridViewModel {
  const LoadableGridViewModel({
    required this.itemBuilder,
    required this.itemCount,
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
  final IndexedWidgetBuilder itemBuilder;
  final VoidCallback? loadList;
  final EdgeInsets? padding;
  final int itemCount;
  final OperationState loadListRequestState;
  final OperationState? loadPageRequestState;
  final SliverGridDelegate gridDelegate;
  final ScrollPhysics? physics;
  final Widget? header;
  final bool shrinkWrap;

  PaginationState getPaginationState() {
    if (loadListRequestState.isFailed) {
      return PaginationState.error;
    } else if (loadListRequestState.isInProgress) {
      return PaginationState.loading;
    } else if (loadListRequestState.isSucceed && itemCount == 0) {
      return PaginationState.empty;
    }

    return PaginationState.idle;
  }
}
