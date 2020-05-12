import 'package:flutter/material.dart' hide Action;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';
import 'package:flutter_platform_core/src/utils/i_redux_component.dart';
import 'package:flutter_platform_core/src/utils/redux_component.dart';

_ActionRunner useActionRunner() {
  final reduxComponent = useReduxComponent();
  final actionRunner = useMemoized(() => _ActionRunner(reduxComponent));
  return actionRunner;
}

class _ActionRunner {
  _ActionRunner(this._reduxComponent);

  final IReduxComponent _reduxComponent;

  void runAction(Action action) {
    _reduxComponent.dispatch(action);
  }

  Future<R> runAsyncAction<R>(AsyncAction<R> action) {
    return _reduxComponent.dispatchAsyncActionAsFuture(action);
  }
}

IReduxComponent useReduxComponent() {
  return Hook.use(ReduxComponentHook());
}

class ReduxComponentHook extends Hook<IReduxComponent> {
  @override
  HookState<IReduxComponent, Hook<IReduxComponent>> createState() {
    return ReduxComponentStateHook();
  }
}

class ReduxComponentStateHook
    extends HookState<IReduxComponent, ReduxComponentHook> {
  var _reduxComponent = ReduxComponent();

  @override
  IReduxComponent build(BuildContext context) {
    return _reduxComponent;
  }

  @override
  void dispose() {
    assert(
      _reduxComponent != null,
      'disposeSubscriptions() should be called before super.dispose()',
    );

    _reduxComponent.disposeSubscriptions();
    _reduxComponent = null;

    super.dispose();
  }
}
