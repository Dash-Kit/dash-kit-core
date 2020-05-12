import 'package:flutter/material.dart' hide Action;
import 'package:flutter_platform_core/flutter_platform_core.dart';
import 'package:flutter_platform_core/src/components/async_action.dart';
import 'package:flutter_platform_core/src/utils/i_redux_component.dart';
import 'package:flutter_platform_core/src/utils/redux_component.dart';

mixin ReduxState<T extends StatefulWidget> on State<T>
    implements IReduxComponent {
  ReduxComponent _reduxComponent;

  @override
  void initState() {
    super.initState();

    _reduxComponent = ReduxComponent();
  }

  @override
  void dispose() {
    disposeSubscriptions();
    _reduxComponent = null;

    super.dispose();
  }

  @override
  void dispatch(Action action) {
    _reduxComponent.dispatch(action);
  }

  @override
  Stream<T> dispatchAsyncAction<T extends AsyncAction>(T action) {
    return _reduxComponent.dispatchAsyncAction<T>(action);
  }

  @override
  Stream<T> onAction<T extends Action>() {
    return _reduxComponent.onAction<T>();
  }

  @override
  void disposeSubscriptions() {
    assert(_reduxComponent != null,
        "disposeSubscriptions() should be called before super.dispose()");

    _reduxComponent.disposeSubscriptions();
  }

  @override
  Future<R> dispatchAsyncActionAsFuture<R>(AsyncAction<R> action) {
    return _reduxComponent.dispatchAsyncActionAsFuture(action);
  }
}
