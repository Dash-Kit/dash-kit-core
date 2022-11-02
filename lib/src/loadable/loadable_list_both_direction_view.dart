import 'package:dash_kit_core/src/loadable/loadable_list_view.dart';
import 'package:dash_kit_core/src/loadable/pagination_state.dart';
import 'package:dash_kit_core/src/states/operation_state.dart';
import 'package:dash_kit_core/src/utils/store_list.dart';
import 'package:flutter/material.dart';

class LoadableListBothDirectionView<T extends StoreListItem>
    extends StatefulWidget {
  const LoadableListBothDirectionView({
    required this.headerViewModel,
    required this.footerViewModel,
    required this.emptyStateWidget,
    required this.errorWidget,
    required this.startWidget,
    this.anchor = 0.5,
    this.scrollPhysics = const AlwaysScrollableScrollPhysics(),
    this.onChangeContentOffset,
    this.cacheExtent,
    this.shrinkWrap = false,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.progressIndicator = const CircularProgressIndicator(),
    this.padding,
    Key? key,
  }) : super(key: key);

  final LoadableListViewModel<T> headerViewModel;
  final LoadableListViewModel<T> footerViewModel;
  final double anchor;
  final ScrollPhysics scrollPhysics;
  final void Function(double offset)? onChangeContentOffset;
  final double? cacheExtent;
  final bool shrinkWrap;
  final Axis scrollDirection;
  final bool reverse;
  final Widget progressIndicator;
  final Widget emptyStateWidget;
  final Widget errorWidget;
  final Widget? startWidget;
  final EdgeInsets? padding;

  @override
  State<StatefulWidget> createState() =>
      LoadableListBothDirectionViewState<T>();
}

class LoadableListBothDirectionViewState<T extends StoreListItem>
    extends State<LoadableListBothDirectionView> {
  final ScrollController scrollController = ScrollController();

  LoadableListViewModel<T> get headerViewModel =>
      widget.headerViewModel as LoadableListViewModel<T>;
  LoadableListViewModel<T> get footerViewModel =>
      widget.footerViewModel as LoadableListViewModel<T>;

  @override
  void initState() {
    super.initState();
    if (headerViewModel.loadListRequestState.isIdle) {
      headerViewModel.loadList?.call();
    }

    if (footerViewModel.loadListRequestState.isIdle) {
      footerViewModel.loadList?.call();
    }

    scrollController.addListener(_onScrollChanged);
  }

  @override
  Widget build(BuildContext context) {
    final centerKey = UniqueKey();
    final headerState = headerViewModel.getPaginationState();
    final footerState = footerViewModel.getPaginationState();

    if (headerState == PaginationState.loading ||
        footerState == PaginationState.loading) {
      return _ProgressSate(
        progressIndicator: widget.progressIndicator,
        padding: widget.padding,
      );
    }

    if (headerState == PaginationState.empty &&
        footerState == PaginationState.empty) {
      return widget.emptyStateWidget;
    }

    if (headerState == PaginationState.error ||
        footerState == PaginationState.error) {
      return widget.errorWidget;
    }

    return CustomScrollView(
      key: widget.key,
      center: centerKey,
      anchor: widget.anchor,
      shrinkWrap: widget.shrinkWrap,
      physics: widget.scrollPhysics,
      controller: scrollController,
      cacheExtent: widget.cacheExtent,
      scrollDirection: widget.scrollDirection,
      reverse: widget.reverse,
      slivers: [
        SliverPadding(
          padding: widget.padding ?? EdgeInsets.zero,
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => buildListItem(index, headerViewModel),
              childCount: headerViewModel.itemsCount,
            ),
          ),
        ),
        if (headerViewModel.endListWidget != null)
          SliverToBoxAdapter(child: footerViewModel.endListWidget),
        SliverToBoxAdapter(
          key: centerKey,
          child: widget.startWidget ?? const SizedBox.shrink(),
        ),
        SliverPadding(
          padding: widget.padding ?? EdgeInsets.zero,
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => buildListItem(index, footerViewModel),
              childCount: footerViewModel.itemsCount,
            ),
          ),
        ),
        if (footerViewModel.endListWidget != null)
          SliverToBoxAdapter(child: footerViewModel.endListWidget),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.removeListener(_onScrollChanged);
    scrollController.dispose();
  }

  void _onScrollChanged() {
    widget.onChangeContentOffset?.call(scrollController.position.pixels);
  }

  Widget buildListItem(int index, LoadableListViewModel model) =>
      _ListItem(index: index, model: model);
}

class _ProgressSate extends StatelessWidget {
  const _ProgressSate({required this.progressIndicator, this.padding});

  final Widget progressIndicator;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      alignment: Alignment.center,
      child: progressIndicator,
    );
  }
}

class _ListItem extends StatelessWidget {
  const _ListItem({required this.index, required this.model});

  final int index;
  final LoadableListViewModel model;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          model.itemBuilder(index),
          if (index != model.itemsCount - 1) model.itemSeparator(index),
        ],
      );
}
