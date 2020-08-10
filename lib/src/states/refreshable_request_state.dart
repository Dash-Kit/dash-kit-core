class RefreshableRequestState {
  const RefreshableRequestState._(this.name);

  final String name;

  static const RefreshableRequestState idle = RefreshableRequestState._('idle');
  static const RefreshableRequestState inProgress =
      RefreshableRequestState._('inProgress');
  static const RefreshableRequestState refreshing =
      RefreshableRequestState._('refreshing');
  static const RefreshableRequestState success =
      RefreshableRequestState._('success');
  static const RefreshableRequestState error =
      RefreshableRequestState._('error');
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
