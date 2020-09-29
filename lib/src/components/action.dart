import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:dash_kit_core/src/components/actions/set_operation_state_action.dart';
import 'package:dash_kit_core/src/components/global_state.dart';
import 'package:dash_kit_core/src/states/operation_state.dart';

abstract class Action<T extends GlobalState> extends ReduxAction<T> {
  Action({this.isRefreshing = false});

  final bool isRefreshing;
  bool _isSuccessfullyCompleted = false;

  Object get operationKey => null;

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
    return () async {
      final newState = await reduce();
      _isSuccessfullyCompleted = true;
      return newState;
    };
  }

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
