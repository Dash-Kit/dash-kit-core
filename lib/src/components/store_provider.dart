import 'package:async_redux/async_redux.dart';
import 'package:dash_kit_core/dash_kit_core.dart';

class StoreProvider<S extends GlobalState> {
  Store<S> _store;

  Store<S> get store => _store;

  StoreProvider({
    S initialState,
    List<ActionObserver> actionObservers,
    List<StateObserver> stateObservers,
    Persistor persistor,
    ModelObserver modelObserver,
    ErrorObserver errorObserver,
    WrapError wrapError,
  }) {
    _store = Store<S>(
      initialState: initialState,
      actionObservers: actionObservers,
      stateObservers: stateObservers,
      persistor: persistor,
      modelObserver: modelObserver,
      errorObserver: errorObserver,
      wrapError: wrapError,
    );
  }
}
