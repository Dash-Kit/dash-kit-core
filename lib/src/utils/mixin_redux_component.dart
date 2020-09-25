import 'package:flutter/material.dart' hide Action;
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:dash_kit_core/src/utils/i_redux_component.dart';
import 'package:dash_kit_core/src/utils/redux_component.dart';

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
    _reduxComponent = null;

    super.dispose();
  }

  @override
  void dispatch<T extends GlobalState>(
    Action<T> action, {
    bool notify = true,
  }) {
    _reduxComponent.dispatch(action);
  }
}
