import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:flutter/material.dart';

extension BuildContextExtensions on BuildContext {
  Future<void> dispatch<T>(ReduxAction<T> action) {
    return StoreProvider.dispatchFuture<T>(this, action);
  }
}
