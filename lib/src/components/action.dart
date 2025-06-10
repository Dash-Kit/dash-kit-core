import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:dash_kit_core/src/components/actions/set_operation_state_action.dart';
import 'package:dash_kit_core/src/components/global_state.dart';
import 'package:dash_kit_core/src/states/operation_state.dart';

abstract class Action<T extends GlobalState> extends ReduxAction<T> {
  Action({this.isRefreshing = false});

  /// Describes the [Action] as called for Refresh.
  /// In that case [OperationState] during the [Action] would be the
  /// [OperationState.refreshing].
  final bool isRefreshing;

  /// Returns an [operationKey]
  ///
  /// Default: `null`.
  // ignore: no-object-declaration
  Object? get operationKey => null;

  /// Calls parent callback [ReduxAction.before]
  ///
  /// As the side effect - it calls [SetOperationStateAction] with
  /// [OperationState.inProgress] value or with
  /// [OperationState.refreshing] if [isRefreshing].
  @override
  FutureOr<void> before() {
    super.before();

    dispatch(SetOperationStateAction<T>(
      operationKey,
      isRefreshing ? OperationState.refreshing : OperationState.inProgress,
    ));
  }

  /// Calls parent callback [ReduxAction.after]
  ///
  /// As the side effect - it calls [SetOperationStateAction] with
  /// [OperationState.success] value or with
  /// [OperationState.error] if the [Action] ends with an error.
  @override
  void after() {
    super.after();

    dispatch(SetOperationStateAction<T>(
      operationKey,
      status.originalError == null && status.wrappedError == null
          ? OperationState.success
          : OperationState.error,
    ));
  }

  @override
  String toString() {
    final actionName = runtimeType //
        .toString()
        .replaceAll(RegExp(r'Action'), '');

    return 'ACTION `$actionName`';
  }
}
