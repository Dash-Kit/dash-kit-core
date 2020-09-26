enum RequestState {
  idle,
  inProgress,
  refreshing,
  success,
  error,
}

extension RefrershableRequestStateExtension on RequestState {
  bool get isIdle => this == RequestState.idle;

  bool get isInProgress => this == RequestState.inProgress;

  bool get isRefreshing => this == RequestState.refreshing;

  bool get isSucceed => this == RequestState.success;

  bool get isFailed => this == RequestState.error;
}
