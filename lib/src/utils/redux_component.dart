import 'package:flutter_platform_core/flutter_platform_core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

abstract class ReduxConfig {
  static StoreProvider<State> storeProvider;
}

mixin ReduxComponent {
  final _onDisposed = PublishSubject();

  void dispatch(Action action) {
    assert(
      ReduxConfig.storeProvider != null,
      'ERROR: ReduxConfig.storeProvider is null. '
      'Initialize it before action dispatching',
    );

    ReduxConfig.storeProvider.store.dispatch(action);
  }

  Observable<T> dispatchAsyncAction<T extends AsyncAction>(T action) {
    dispatch(action);

    return Observable(onAction<T>())
        .where((a) => identical(a, action))
        .take(1)
        .takeUntil(_onDisposed);
  }

  Observable<T> onAction<T extends Action>() {
    assert(
      ReduxConfig.storeProvider != null,
      'ERROR: ReduxConfig.storeProvider is null. '
      'Initialize it before subscribing on actions',
    );

    return Observable(ReduxConfig.storeProvider.onAction)
        .whereType<T>()
        .takeUntil(_onDisposed);
  }

  void disposeSubscriptions() {
    _onDisposed.add(true);
  }
}
