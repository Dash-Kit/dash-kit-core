import 'package:flutter/material.dart' hide Action;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:dash_kit_core/src/utils/i_redux_component.dart';
import 'package:dash_kit_core/src/utils/redux_component.dart';

_ActionRunner useActionRunner() {
  final reduxComponent = useReduxComponent();
  final actionRunner = useMemoized(() => _ActionRunner(reduxComponent));
  return actionRunner;
}

class _ActionRunner {
  _ActionRunner(this._reduxComponent);

  final IReduxComponent _reduxComponent;

  void runAction<T extends GlobalState>(Action<T> action) {
    _reduxComponent.dispatch(action);
  }
}

IReduxComponent useReduxComponent() {
  return use(ReduxComponentHook());
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
    _reduxComponent = null;

    super.dispose();
  }
}
