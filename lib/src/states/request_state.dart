class RequestState {
  const RequestState._(this.name);

  final String name;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RequestState &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;

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
