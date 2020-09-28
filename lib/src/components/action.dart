import 'package:async_redux/async_redux.dart';
import 'package:dash_kit_core/src/components/actions/set_operation_state_action.dart';
import 'package:dash_kit_core/src/components/global_state.dart';
import 'package:dash_kit_core/src/states/operation_state.dart';

abstract class Action<T extends GlobalState> extends ReduxAction<T> {
  Action({this.isRefreshing = false});

  final bool isRefreshing;

  Object get operationKey => null;

  @override
  Reducer<T> wrapReduce(Reducer<T> reduce) {
    if (operationKey == null) {
      return reduce;
    }

    final ReduxAction<GlobalState> initialAction = SetOperationStateAction(
      operationKey,
      isRefreshing == true
          ? OperationState.refreshing
          : OperationState.inProgress,
    );
    dispatch(initialAction);

    return () async {
      try {
        final newState = await reduce();

        final ReduxAction<GlobalState> successAction = SetOperationStateAction(
          operationKey,
          OperationState.success,
        );
        dispatch(successAction);

        return newState;

        // ignore: avoid_catches_without_on_clauses
      } catch (error) {
        final ReduxAction<GlobalState> errorAction = SetOperationStateAction(
          operationKey,
          OperationState.error,
        );
        dispatch(errorAction);

        rethrow;
      }
    };
  }

  @override
  String toString() {
    final actionName = runtimeType //
        .toString()
        .replaceAll(RegExp(r'Action'), '');

    return 'ACTION `$actionName`';
  }
}
