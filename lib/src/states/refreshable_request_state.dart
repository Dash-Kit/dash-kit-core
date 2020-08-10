enum RefreshableRequestState {
  idle,
  inProgress,
  refreshing,
  success,
  error,
}

extension RefrershableRequestStateExtension on RefreshableRequestState {
  bool get isIdle => this == RefreshableRequestState.idle;

  bool get isInProgress => this == RefreshableRequestState.inProgress;

  bool get isRefreshing => this == RefreshableRequestState.refreshing;

  bool get isSucceed => this == RefreshableRequestState.success;

  bool get isFailed => this == RefreshableRequestState.error;
}
