import 'dart:math';

import 'package:dash_kit_core/src/loadable/pagination_state.dart';
import 'package:dash_kit_core/src/states/operation_state.dart';
import 'package:flutter/material.dart';

typedef ScrollListener = bool Function({
  required double offset,
  required double maxScrollExtent,
});

class LoadableListView extends StatefulWidget {
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

  final LoadableListViewModel viewModel;
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
    return LoadableListViewState();
  }
}

class LoadableListViewState extends State<LoadableListView> {
  LoadableListViewModel get viewModel => widget.viewModel;

  @override
  void initState() {
    super.initState();
    if (viewModel.loadListRequestState.isIdle) {
      viewModel.loadList?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollEndNotification>(
      onNotification: onScrollChanged,
      child: CustomScrollView(
        key: viewModel.key,
        shrinkWrap: widget.shrinkWrap,
        physics: widget.scrollPhysics,
        controller: widget.scrollController,
        cacheExtent: widget.cacheExtent,
        scrollDirection: widget.scrollDirection,
        reverse: widget.reverse,
        slivers: [
          if (viewModel.sliverHeader != null) viewModel.sliverHeader!,
          // ignore: avoid-returning-widgets
          ...buildSliver(),
        ],
      ),
    );
  }

  List<Widget> buildSliver() {
    final state = viewModel.getPaginationState();

    if (state == PaginationState.loading) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: _ProgressState(
            padding: viewModel.padding,
            progressIndicator: widget.progressIndicator,
          ),
        ),
      ];
    }

    if (state == PaginationState.empty) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: viewModel.emptyStateWidget,
        ),
      ];
    }

    if (state == PaginationState.error) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: viewModel.errorWidget,
        ),
      ];
    }

    return [
      if (viewModel.header != null) SliverToBoxAdapter(child: viewModel.header),
      SliverPadding(
        padding: viewModel.padding ?? EdgeInsets.zero,
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            sliverDelegateBuilder,
            childCount: _computeActualChildCount(viewModel.itemCount),
          ),
        ),
      ),
      // ignore: avoid-returning-widgets
      if (viewModel.footer != null) buildFooter(),
    ];
  }

  Widget sliverDelegateBuilder(BuildContext _, int index) {
    final itemIndex = index ~/ 2;
    final Widget? widget;
    if (index.isEven) {
      // ignore: avoid-returning-widgets
      widget = buildListItem(itemIndex);
    } else {
      // ignore: avoid-returning-widgets
      widget = buildSeparator(itemIndex);
    }

    return widget;
  }

  Widget buildListItem(int index) {
    return viewModel.itemBuilder(context, index);
  }

  Widget buildSeparator(int index) {
    return viewModel.separatorBuilder(context, index);
  }

  Widget buildFooter() {
    return SliverToBoxAdapter(child: viewModel.footer);
  }

  bool onScrollChanged(ScrollNotification scrollInfo) =>
      widget.onChangeContentOffset?.call(
        offset: scrollInfo.metrics.pixels,
        maxScrollExtent: scrollInfo.metrics.maxScrollExtent,
      ) ??
      false;

  static int _computeActualChildCount(int itemCount) {
    return max(0, itemCount * 2 - 1);
  }

  Widget buildLastItem(PaginationState state) {
    return const SizedBox();
  }
}

class LoadableListViewModel {
  const LoadableListViewModel({
    required this.itemCount,
    required this.itemBuilder,
    required this.emptyStateWidget,
    required this.loadListRequestState,
    required this.errorWidget,
    required this.separatorBuilder,
    this.loadList,
    this.padding,
    this.sliverHeader,
    this.header,
    this.footer,
    this.key,
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final IndexedWidgetBuilder separatorBuilder;
  final Widget errorWidget;
  final Widget emptyStateWidget;
  final OperationState loadListRequestState;
  final VoidCallback? loadList;
  final EdgeInsets? padding;
  final Widget? sliverHeader;
  final Widget? header;
  final Widget? footer;
  final Key? key;

  PaginationState getPaginationState() {
    if (loadListRequestState.isFailed) {
      return PaginationState.error;
    }

    if (loadListRequestState.isInProgress) {
      return PaginationState.loading;
    }

    if ((loadListRequestState.isSucceed || loadListRequestState.isRefreshing) &&
        itemCount == 0) {
      return PaginationState.empty;
    }

    return PaginationState.idle;
  }
}

class _ProgressState extends StatelessWidget {
  const _ProgressState({
    required this.padding,
    required this.progressIndicator,
  });

  final EdgeInsets? padding;
  final Widget progressIndicator;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      alignment: Alignment.center,
      child: progressIndicator,
    );
  }
}
