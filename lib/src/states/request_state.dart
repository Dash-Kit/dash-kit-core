enum RequestState {
  idle,
  inProgress,
  success,
  error,
}

extension RequestStateExtension on RequestState {
  bool get isInProgress => this == RequestState.inProgress;

  bool get isIdle => this == RequestState.idle;

  bool get isSucceed => this == RequestState.success;

  bool get isFailed => this == RequestState.error;
}
