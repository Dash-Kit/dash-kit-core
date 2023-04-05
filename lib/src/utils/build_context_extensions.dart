import 'dart:async';

import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:flutter/material.dart';

extension BuildContextExtensions on BuildContext {
  /// Asynchronously calls a [StoreProvider.dispatch] action of [ReduxAction].
  Future<void> dispatch<T>(ReduxAction<T> action) async {
    await StoreProvider.dispatch<T>(this, action);
  }
}
