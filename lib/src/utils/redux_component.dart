import 'package:flutter/material.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart' as core;
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

abstract class ReduxConfig {
  static core.StoreProvider<core.GlobalState> storeProvider;
}

class _IReduxComponent {
  void dispatch(core.Action action) {}

  Observable<T> dispatchAsyncAction<T extends core.AsyncAction>(T action) {}

  Observable<T> onAction<T extends core.Action>() {}

  void disposeSubscriptions() {}
}

class _ReduxComponentImpl implements _IReduxComponent {
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
}

mixin ReduxComponent implements _IReduxComponent {
  final _reduxComponent = _ReduxComponentImpl();

  void dispatch(core.Action action) {
    _reduxComponent.dispatch(action);
  }

  Observable<T> dispatchAsyncAction<T extends core.AsyncAction>(T action) {
    return _reduxComponent.dispatchAsyncAction<T>(action);
  }

  Observable<T> onAction<T extends core.Action>() {
    return _reduxComponent.onAction<T>();
  }

  void disposeSubscriptions() {
    _reduxComponent.disposeSubscriptions();
  }
}

mixin ReduxState<T extends StatefulWidget> on State<T>
    implements _IReduxComponent {
  _ReduxComponentImpl _reduxComponent;

  @override
  void initState() {
    super.initState();

    _reduxComponent = _ReduxComponentImpl();
  }

  @override
  void dispose() {
    disposeSubscriptions();
    _reduxComponent = null;

    super.dispose();
  }

  void dispatch(core.Action action) {
    _reduxComponent.dispatch(action);
  }

  Observable<T> dispatchAsyncAction<T extends core.AsyncAction>(T action) {
    return _reduxComponent.dispatchAsyncAction<T>(action);
  }

  Observable<T> onAction<T extends core.Action>() {
    return _reduxComponent.onAction<T>();
  }

  void disposeSubscriptions() {
    _reduxComponent.disposeSubscriptions();
  }
}
