import 'package:dash_kit_core/dash_kit_core.dart';

/// Describes the [Action] operational state
enum OperationState {
  idle,
  inProgress,
  refreshing,
  success,
  error,
}

extension OperationStateExtension on OperationState {
  /// Returns `true` if [OperationState.idle]
  bool get isIdle => this == OperationState.idle;

  /// Returns `true` if [OperationState.inProgress]
  bool get isInProgress => this == OperationState.inProgress;

  /// Returns `true` if [OperationState.refreshing]
  bool get isRefreshing => this == OperationState.refreshing;

  /// Returns `true` if [OperationState.success]
  bool get isSucceed => this == OperationState.success;

  /// Returns `true` if [OperationState.error]
  bool get isFailed => this == OperationState.error;
}
