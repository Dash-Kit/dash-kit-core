import 'package:async_redux/async_redux.dart' as async_redux;
import 'package:dash_kit_core/dash_kit_core.dart';

class Store<S extends GlobalState> extends async_redux.Store<S> {
  Store({
    required S initialState,
    List<ActionObserver<S>>? actionObservers,
    List<StateObserver<S>>? stateObservers,
    Persistor<S>? persistor,
    ModelObserver? modelObserver,
    ErrorObserver<S>? errorObserver,
    WrapError<S>? wrapError,
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
