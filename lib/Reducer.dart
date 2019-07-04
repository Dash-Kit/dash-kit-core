import 'package:flutter_platform_core/Action.dart';

class Reducer<State> {
  final _reducerActions = Map<String, State Function(State, Action)>();

  bool _isRoot;
  State Function(State, Action) _rootReducerAction;

  Reducer(
      {bool isRoot = false, State Function(State, Action) rootReducerAction})
      : assert(!isRoot || isRoot && rootReducerAction != null) {
    _isRoot = isRoot;
    _rootReducerAction = rootReducerAction;
  }

  void on<T extends Action>(State Function(State, T) actionCallback) {
    assert(!_isRoot, 'Can not add aditional action for a root reducer');

    var actionType = T.toString();

    State Function(State, Action) callback = (state, action) {
      return actionCallback(state, action);
    };

    _reducerActions[actionType] = callback;
  }

  State reduce(State state, Action action) {
    if (_isRoot) {
      return _rootReducerAction(state, action);
    }

    var reducerAction = _reducerActions[action.runtimeType.toString()];

    if (reducerAction != null) {
      return reducerAction(state, action);
    }

    return state;
  }
}
