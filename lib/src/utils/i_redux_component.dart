import 'package:dash_kit_core/dash_kit_core.dart';

abstract class IReduxComponent {
  void dispatch(Action action) {}

  Stream<T> dispatchAsyncAction<T extends AsyncAction>(T action);

  Stream<T> onAction<T extends Action>();

  void disposeSubscriptions();

  Future<R> dispatchAsyncActionAsFuture<R>(AsyncAction<R> action);
}
