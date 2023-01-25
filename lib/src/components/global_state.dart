import 'package:dash_kit_core/dash_kit_core.dart';

abstract class GlobalState {
  BuiltMap<Object, OperationState> get operationsState;

  /// Returns the [T] with updated [OperationState]
  /// by [operationKey] and [operationState] value
  T updateOperation<T extends GlobalState>(
    Object? operationKey,
    OperationState operationState,
  );

  /// Returns an [OperationState] value by the [operationKey]
  OperationState getOperationState(Object operationKey);
}
