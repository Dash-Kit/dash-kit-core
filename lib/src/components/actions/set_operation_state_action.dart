import 'package:dash_kit_core/dash_kit_core.dart';

class SetOperationStateAction<T extends GlobalState> extends ReduxAction<T> {
  SetOperationStateAction(this.operationKey, this.operationState);

  final Object? operationKey;
  final OperationState operationState;

  @override
  bool abortDispatch() => operationKey == null;

  @override
  T reduce() {
    return state.updateOperation<T>(operationKey, operationState);
  }

  @override
  String toString() {
    final state = operationState //
        .toString()
        .replaceAll('${(OperationState).toString()}.', '');

    return '$operationKey: $state';
  }
}
