enum OperationState {
  idle,
  inProgress,
  refreshing,
  success,
  error,
}

extension OperationStateExtension on OperationState {
  bool get isIdle => this == OperationState.idle;

  bool get isInProgress => this == OperationState.inProgress;

  bool get isRefreshing => this == OperationState.refreshing;

  bool get isSucceed => this == OperationState.success;

  bool get isFailed => this == OperationState.error;
}
