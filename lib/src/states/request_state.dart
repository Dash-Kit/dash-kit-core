class RequestState {
  const RequestState._(this.name);

  final String name;

  static const RequestState idle = RequestState._('idle');
  static const RequestState inProgress = RequestState._('inProgress');
  static const RequestState success = RequestState._('success');
  static const RequestState error = RequestState._('error');

  static const values = [idle, inProgress, success, error];

  bool get isInProgress => this == RequestState.inProgress;

  bool get isIdle => this == RequestState.idle;

  bool get isSucceed => this == RequestState.success;

  bool get isFailed => this == RequestState.error;
}
