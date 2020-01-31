import 'package:flutter/material.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart' as core;
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

abstract class ReduxConfig {
  static core.StoreProvider<core.GlobalState> storeProvider;
}

mixin ReduxComponent on State {
  final _onDisposed = PublishSubject();

  void dispatch(core.Action action) {
    assert(
      ReduxConfig.storeProvider != null,
      'ERROR: ReduxConfig.storeProvider is null. '
      'Initialize it before action dispatching',
    );

    ReduxConfig.storeProvider.store.dispatch(action);
  }

  Observable<T> dispatchAsyncAction<T extends core.AsyncAction>(T action) {
    dispatch(action);

    return Observable(onAction<T>())
        .where((a) => identical(a, action))
        .take(1)
        .takeUntil(_onDisposed);
  }

  Observable<T> onAction<T extends core.Action>() {
    assert(
      ReduxConfig.storeProvider != null,
      'ERROR: ReduxConfig.storeProvider is null. '
      'Initialize it before subscribing on actions',
    );

    return Observable(ReduxConfig.storeProvider.onAction)
        .whereType<T>()
        .takeUntil(_onDisposed);
  }

  void disposeSubscriptions() {
    _onDisposed.add(true);
  }

  @override
  void dispose() {
    super.dispose();

    disposeSubscriptions();
  }
}
