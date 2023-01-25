import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:dash_kit_core/src/components/actions/set_operation_state_action.dart';
import 'package:dash_kit_core/src/components/global_state.dart';
import 'package:dash_kit_core/src/states/operation_state.dart';

abstract class Action<T extends GlobalState> extends ReduxAction<T> {
  Action({this.isRefreshing = false});

  /// Describes the [Action] as called for Refresh.
  /// In that case [OperationState] during the [Action] would be the
  /// [OperationState.refreshing]
  final bool isRefreshing;

  bool _isSuccessfullyCompleted = false;

  /// Returns an [operationKey]
  ///
  /// Default: `null`
  Object? get operationKey => null;

  /// This is an optional method that may be overridden to run during action
  /// dispatching, before `reduce`. If this method throws an error, the
  /// `reduce` method will NOT run, but the method `after` will.
  /// It may be synchronous (returning `void`)
  /// on async (returning `Future<void>`).
  /// You should NOT return `FutureOr`.
  ///
  /// As the side effect - it calls [SetOperationStateAction] with
  /// [OperationState.inProgress] value or with
  /// [OperationState.refreshing] if [isRefreshing]
  @override
  FutureOr<void> before() {
    super.before();

    dispatch(SetOperationStateAction<T>(
      operationKey,
      isRefreshing == true
          ? OperationState.refreshing
          : OperationState.inProgress,
    ));
  }

  @override
  Reducer<T> wrapReduce(Reducer<T> reduce) {
    final reduceMethodIsSync = reduce is T? Function();

    if (reduceMethodIsSync) {
      return () {
        final newState = reduce();
        _isSuccessfullyCompleted = true;
        return newState;
      };
    }

    return () async {
      final newState = await reduce();
      _isSuccessfullyCompleted = true;
      return newState;
    };
  }

  /// This is an optional method that may be overridden to run during action
  /// dispatching, after `reduce`. If this method throws an error, the
  /// error will be swallowed (will not throw). So you should only run code that
  /// can't throw errors. It may be synchronous only.
  /// Note this method will always be called,
  /// even if errors were thrown by `before` or `reduce`.
  ///
  /// As the side effect - it calls [SetOperationStateAction] with
  /// [OperationState.success] value or with
  /// [OperationState.error] if the [Action] ends with an error
  @override
  void after() {
    super.after();

    dispatch(SetOperationStateAction<T>(
      operationKey,
      _isSuccessfullyCompleted ? OperationState.success : OperationState.error,
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
