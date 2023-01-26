import 'package:flutter/material.dart';

class BlockedLoadableView extends StatelessWidget {
  const BlockedLoadableView({
    required this.child,
    required this.isLoading,
    this.indicatorColor = Colors.white,
    super.key,
  });

  final Widget child;
  final bool isLoading;
  final Color indicatorColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        child,
        Positioned.fill(
          child: Visibility(
            visible: isLoading,
            child: ColoredBox(
              color: Colors.black54,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
