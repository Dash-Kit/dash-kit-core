import 'package:async_redux/async_redux.dart' as async_redux;
import 'package:dash_kit_core/dash_kit_core.dart';

class Store<S extends GlobalState> extends async_redux.Store<S?> {
  Store({
    S? initialState,
    List<ActionObserver>? actionObservers,
    List<StateObserver>? stateObservers,
    Persistor? persistor,
    ModelObserver? modelObserver,
    ErrorObserver? errorObserver,
    WrapError? wrapError,
  }) : super(
          initialState: initialState,
          actionObservers: actionObservers,
          stateObservers: stateObservers,
          persistor: persistor,
          modelObserver: modelObserver,
          errorObserver: errorObserver,
          wrapError: wrapError,
        );
}
