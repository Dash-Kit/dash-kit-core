import 'package:flutter_platform_core/flutter_platform_core.dart';
import 'package:flutter_platform_core/src/components/async_action.dart';
import 'package:flutter_platform_core/src/utils/i_redux_component.dart';
import 'package:flutter_platform_core/src/utils/redux_config.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class ReduxComponent implements IReduxComponent {
  final _onDisposed = PublishSubject();

  @override
  void dispatch(Action action) {
    assert(
      ReduxConfig.storeProvider != null,
      'ERROR: ReduxConfig.storeProvider is null. '
      'Initialize it before action dispatching',
    );

    ReduxConfig.storeProvider.store.dispatch(action);
  }

  @override
  Stream<T> dispatchAsyncAction<T extends AsyncAction>(T action) {
    dispatch(action);

    return onAction<T>()
        .where((a) => identical(a, action))
        .take(1)
        .takeUntil(_onDisposed);
  }

  @override
  Stream<T> onAction<T extends Action>() {
    assert(
      ReduxConfig.storeProvider != null,
      'ERROR: ReduxConfig.storeProvider is null. '
      'Initialize it before subscribing on actions',
    );

    return ReduxConfig.storeProvider.onAction
        .whereType<T>()
        .takeUntil(_onDisposed);
  }

  @override
  void disposeSubscriptions() {
    _onDisposed.add(true);
  }

  @override
  Future<R> dispatchAsyncActionAsFuture<R>(AsyncAction<R> action) async {
    final asyncAction = await dispatchAsyncAction(action).first;

    if (asyncAction.isFailed) {
      throw asyncAction.errorModel;
    }

    return action.successModel;
  }
}
