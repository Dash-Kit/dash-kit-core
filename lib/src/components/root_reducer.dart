import 'package:flutter_platform_core/flutter_platform_core.dart';
import 'package:kt_dart/kt.dart';

class RootReducer<S extends GlobalState> {
  KtMutableList<Reducer<S>> _reducers = mutableListOf<Reducer<S>>();

  S reduce(S state, Action action) {
    return _reducers.fold(state, (newState, reducer) {
      return reducer.reduce(newState, action);
    });
  }

  void addReducer(Reducer<S> reducer) {
    assert(
      !_reducers.contains(reducer),
      'The reducer was already added',
    );

    if (!_reducers.contains(reducer)) {
      _reducers.add(reducer);
    }
  }

  void removeReducer(Reducer<S> reducer) {
    assert(
      _reducers.contains(reducer),
      'The reducer does not connected to root reducer',
    );

    _reducers.remove(reducer);
  }

  bool containsReducer(Reducer<S> reducer) {
    return _reducers.contains(reducer);
  }
}
