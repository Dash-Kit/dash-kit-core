import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:dash_kit_core/src/states/operation_state.dart';

class SetOperationStateAction<T extends GlobalState> extends ReduxAction<T> {
  SetOperationStateAction(this.operationKey, this.operationState);

  final Object operationKey;
  final OperationState operationState;

  @override
  bool abortDispatch() => operationKey == null || operationState == null;

  @override
  FutureOr<T> reduce() {
    final T newState = state.updateOperation(operationKey, operationState);
    return newState;
  }

  @override
  String toString() {
    final state = operationState //
        .toString()
        .replaceAll('${(OperationState).toString()}.', '');

    return '$operationKey: $state';
  }
}