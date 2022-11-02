import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:dash_kit_core/src/loadable/loadable_list_both_direction_view.dart';
import 'package:flutter/material.dart';

class LoadablePaginatedListBothDirectionView<T extends StoreListItem>
    extends LoadableListBothDirectionView<T> {
  const LoadablePaginatedListBothDirectionView({
    required LoadablePaginatedListViewModel<T> headerViewModel,
    required LoadablePaginatedListViewModel<T> footerViewModel,
    required Widget emptyStateWidget,
    required Widget errorWidget,
    Key? key,
    ScrollPhysics scrollPhysics = const AlwaysScrollableScrollPhysics(),
    double? cacheExtent,
    bool shrinkWrap = false,
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    void Function(double offset)? onChangeContentOffset,
    Widget progressIndicator = const CircularProgressIndicator(),
    Widget? startWidget,
    double anchor = 0.5,
  }) : super(
          key: key,
          headerViewModel: headerViewModel,
          footerViewModel: footerViewModel,
          scrollPhysics: scrollPhysics,
          onChangeContentOffset: onChangeContentOffset,
          cacheExtent: cacheExtent,
          shrinkWrap: shrinkWrap,
          scrollDirection: scrollDirection,
          reverse: reverse,
          progressIndicator: progressIndicator,
          emptyStateWidget: emptyStateWidget,
          errorWidget: errorWidget,
          startWidget: startWidget,
          anchor: anchor,
        );

  @override
  State<StatefulWidget> createState() =>
      LoadablePaginatedListBothDirectionState<T>();
}

class LoadablePaginatedListBothDirectionState<T extends StoreListItem>
    extends LoadableListBothDirectionViewState<T> {
  @override
  LoadablePaginatedListViewModel<T> get headerViewModel =>
      widget.headerViewModel as LoadablePaginatedListViewModel<T>;
  @override
  LoadablePaginatedListViewModel<T> get footerViewModel =>
      widget.footerViewModel as LoadablePaginatedListViewModel<T>;

  @override
  void initState() {
    super.initState();

    scrollController.addListener(_onScrollChanged);
  }

  @override
  Widget buildListItem(int index, LoadableListViewModel model) {
    return index == model.itemsCount - 1
        ? _LastItem(
            paginatedModel: model as LoadablePaginatedListViewModel,
            scrollController: scrollController,
            progressIndicator: widget.progressIndicator,
            cacheExtent: widget.cacheExtent,
          )
        : super.buildListItem(index, model);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.removeListener(_onScrollChanged);
  }

  void _onScrollChanged() {
    final canLoadHeader = (headerViewModel.loadPageRequestState.isSucceed ||
            headerViewModel.loadPageRequestState.isIdle) &&
        !headerViewModel.paginatedList.isAllItemsLoaded;
    final canLoadFooter = (footerViewModel.loadPageRequestState.isSucceed ||
            footerViewModel.loadPageRequestState.isIdle) &&
        !footerViewModel.paginatedList.isAllItemsLoaded;
    final maxScrollExtent =
        scrollController.position.maxScrollExtent - (widget.cacheExtent ?? 0);
    final minScrollExtent =
        scrollController.position.minScrollExtent + (widget.cacheExtent ?? 0);

    if (scrollController.position.pixels >= maxScrollExtent && canLoadFooter) {
      footerViewModel.loadPage?.call();
    }
    if (scrollController.position.pixels <= minScrollExtent && canLoadHeader) {
      headerViewModel.loadPage?.call();
    }
  }
}

class _LastItem extends StatelessWidget {
  const _LastItem({
    required this.paginatedModel,
    required this.scrollController,
    required this.progressIndicator,
    this.cacheExtent,
  });

  final LoadablePaginatedListViewModel paginatedModel;
  final ScrollController scrollController;
  final Widget progressIndicator;
  final double? cacheExtent;

  @override
  Widget build(BuildContext context) {
    switch (paginatedModel.getPaginationState()) {
      case PaginationState.loadingPage:
        return _ProgressPage(
          scrollController: scrollController,
          progressIndicator: progressIndicator,
          cacheExtent: cacheExtent,
        );

      case PaginationState.errorLoadingPage:
        return paginatedModel.errorWidget;

      case PaginationState.succeedLoadingPage:
        if (paginatedModel.paginatedList.isAllItemsLoaded) {
          return paginatedModel.endListWidget ?? const SizedBox.shrink();
        }

        return const SizedBox.shrink();

      default:
        return const SizedBox.shrink();
    }
  }
}

class _ProgressPage extends StatelessWidget {
  const _ProgressPage({
    required this.progressIndicator,
    required this.scrollController,
    this.cacheExtent,
  });

  final Widget progressIndicator;
  final ScrollController scrollController;
  final double? cacheExtent;

  @override
  Widget build(BuildContext context) {
    {
      WidgetsBinding.instance.addPostFrameCallback((_) => cacheExtent == null
          ? scrollController.animateTo(
              scrollController.offset > 0
                  ? scrollController.position.maxScrollExtent
                  : scrollController.position.minScrollExtent,
              duration: const Duration(milliseconds: 100),
              curve: Curves.linear,
            )
          : null);

      return Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(top: 8),
        child: Center(child: progressIndicator),
      );
    }
  }
}
