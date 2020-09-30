import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:flutter/material.dart';

extension BuildContextExtensions on BuildContext {
  Future<void> dispatch(ReduxAction action) {
    return StoreProvider.dispatchFuture(this, action);
  }
}
