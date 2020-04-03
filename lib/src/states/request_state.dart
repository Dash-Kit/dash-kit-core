class RequestState {
  const RequestState._();

  static const RequestState idle = RequestState._();
  static const RequestState inProgress = RequestState._();
  static const RequestState success = RequestState._();
  static const RequestState error = RequestState._();

  static const values = [idle, inProgress, success, error];

  bool get isInProgress => this == RequestState.inProgress;

  bool get isIdle => this == RequestState.idle;

  bool get isSucceed => this == RequestState.success;

  bool get isFailed => this == RequestState.error;
}
