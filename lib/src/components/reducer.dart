import 'package:flutter_platform_core/flutter_platform_core.dart';

class Reducer<State> {
  final _reducerActions = Map<String, State Function(State, Action)>();

  void on<T extends Action>(State Function(State, T) actionCallback) {
    var actionType = T.toString();

    State Function(State, Action) callback = (state, action) {
      return actionCallback(state, action);
    };

    _reducerActions[actionType] = callback;
  }

  State reduce(State state, Action action) {
    var reducerAction = _reducerActions[action.runtimeType.toString()];

    if (reducerAction != null) {
      return reducerAction(state, action);
    }

    return state;
  }
}
