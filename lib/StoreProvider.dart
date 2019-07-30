import 'package:flutter_platform_core/Action.dart';
import 'package:flutter_platform_core/ActionDispatcherMiddleware.dart';
import 'package:flutter_platform_core/RootEpic.dart';
import 'package:flutter_platform_core/RootReducer.dart';
import 'package:flutter_platform_core/Reducer.dart' as PlatformReducer;
import 'package:flutter_platform_core/State.dart';
import 'package:redux/redux.dart';
import 'package:redux_epics/redux_epics.dart';

class StoreProvider<S extends State> {
  ActionDispatcherMiddleware _actionDispatcher;
  Store<S> _store;

  final rootReducer = RootReducer<S>();
  final rootEpic = RootEpic<S>();

  Store<S> get store => _store;
  Stream<Action> get onAction => _actionDispatcher.onAction;

  StoreProvider({
    S initialState,
    PlatformReducer.Reducer<S> appReducer,
    Epic<S> appEpic,
    List<Middleware<State>> middleware = const [],
  }) {
    final epicMiddleware = EpicMiddleware<S>(rootEpic.epic);
    _actionDispatcher = ActionDispatcherMiddleware();

    final platformMiddleware = [
      _actionDispatcher,
      epicMiddleware,
    ];

    if (appReducer != null) {
      rootReducer.addReducer(appReducer);
    }

    if (appEpic != null) {
      rootEpic.addEpic(appEpic);
    }

    _store = Store<S>(
      rootReducer.reduce,
      initialState: initialState,
      middleware: platformMiddleware + middleware,
    );
  }

  dispose() {
    _actionDispatcher.dispose();
  }
}
