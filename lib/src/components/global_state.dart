import 'package:built_collection/built_collection.dart';
import 'package:dash_kit_core/dash_kit_core.dart';

abstract class GlobalState {
  BuiltMap<Object, OperationState> get operationsState;

  T updateOperation<T extends GlobalState>(
    Object operationKey,
    OperationState operationState,
  );

  OperationState getOperationState(Object operationKey);
}
