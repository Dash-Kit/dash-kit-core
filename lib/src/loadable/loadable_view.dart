import 'package:flutter/material.dart';

class LoadableView extends StatelessWidget {
  const LoadableView({
    required this.child,
    required this.isLoading,
    this.padding,
    this.backgroundColor = Colors.white,
    this.indicatorColor,
  });

  final Widget child;
  final bool isLoading;
  final EdgeInsetsGeometry? padding;
  final Color backgroundColor;
  final Animation<Color>? indicatorColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(child: child),
        Positioned.fill(child: _getLoadingWidget()),
      ],
    );
  }

  Widget _getLoadingWidget() {
    return Visibility(
      visible: isLoading,
      child: Container(
        padding: padding,
        color: backgroundColor,
        child: Center(
          child: CircularProgressIndicator(
            valueColor: indicatorColor,
          ),
        ),
      ),
    );
  }
}
