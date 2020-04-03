class RefreshableRequestState {
  const RefreshableRequestState._();

  static const RefreshableRequestState idle = RefreshableRequestState._();
  static const RefreshableRequestState inProgress = RefreshableRequestState._();
  static const RefreshableRequestState refreshing = RefreshableRequestState._();
  static const RefreshableRequestState success = RefreshableRequestState._();
  static const RefreshableRequestState error = RefreshableRequestState._();

  static const values = [
    idle,
    inProgress,
    refreshing,
    success,
    error,
  ];

  bool get isIdle => this == RefreshableRequestState.idle;

  bool get isInProgress => this == RefreshableRequestState.inProgress;

  bool get isRefreshing => this == RefreshableRequestState.refreshing;

  bool get isSucceed => this == RefreshableRequestState.success;

  bool get isFailed => this == RefreshableRequestState.error;
}
