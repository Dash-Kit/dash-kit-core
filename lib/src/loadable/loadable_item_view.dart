import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:flutter/material.dart';

class LoadableItemView extends StatelessWidget {
  const LoadableItemView({
    required this.child,
    required this.requestState,
    required this.errorWidget,
    this.padding,
    this.backgroundColor,
    super.key,
  });

  final Widget child;
  final Widget errorWidget;
  final OperationState requestState;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(child: child),
        if (requestState.isInProgress)
          Positioned.fill(
            child: Container(
              padding: padding,
              color: backgroundColor ?? Colors.white,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        if (requestState.isFailed)
          Positioned.fill(
            child: Container(
              padding: padding,
              color: backgroundColor ?? Colors.white,
              child: Center(
                child: errorWidget,
              ),
            ),
          ),
      ],
    );
  }
}
