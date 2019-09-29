import 'package:flutter_platform_core/flutter_platform_core.dart';

enum AsyncActionState {
  started,
  succeed,
  failed,
}

class AsyncAction<SuccessModel, ErrorModel> extends Action {
  AsyncAction();

  AsyncActionState _state = AsyncActionState.started;

  SuccessModel _successModel;
  ErrorModel _errorModel;

  AsyncActionState get state => _state;
  SuccessModel get successModel => _successModel;
  ErrorModel get errorModel => _errorModel;

  bool get isStarted => _state == AsyncActionState.started;
  bool get isSucceed => _state == AsyncActionState.succeed;
  bool get isFailed => _state == AsyncActionState.failed;

  @override
  List<Object> get props => [state, successModel, errorModel];

  @override
  String toString() {
    final actionType = runtimeType.toString();
    final statePrefix = r'AsyncActionState.';
    final actionState = _state.toString().replaceAll(RegExp(statePrefix), '');

    return 'ACTION `$actionType: $actionState`';
  }

  AsyncAction<SuccessModel, ErrorModel> complete(SuccessModel model) {
    assert(
      _state == AsyncActionState.started,
      'ERROR: The action was already completed or failed. '
      'Check that the action does not pass in the Epic recursively',
    );

    _state = AsyncActionState.succeed;
    _successModel = model;

    return this;
  }

  AsyncAction<SuccessModel, ErrorModel> fail(ErrorModel model) {
    assert(
      _state == AsyncActionState.started,
      'ERROR: The action was already completed or failed. '
      'Check that the action does not pass in the Epic recursively',
    );

    _state = AsyncActionState.failed;
    _errorModel = model;

    return this;
  }

  AsyncAction<SuccessModel, ErrorModel> onStart(void Function() callback) {
    if (_state == AsyncActionState.started) {
      callback();
    }

    return this;
  }

  AsyncAction<SuccessModel, ErrorModel> onSuccess(
    void Function(SuccessModel) callback,
  ) {
    if (_state == AsyncActionState.succeed) {
      callback(_successModel);
    }

    return this;
  }

  AsyncAction<SuccessModel, ErrorModel> onError(
    void Function(ErrorModel) callback,
  ) {
    if (_state == AsyncActionState.failed) {
      callback(_errorModel);
    }

    return this;
  }
}
