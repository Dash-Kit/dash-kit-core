import 'package:flutter_platform_core/flutter_platform_core.dart';
import 'package:redux/redux.dart';
import 'package:rxdart/rxdart.dart';

class ActionDispatcherMiddleware<S extends State>
    implements MiddlewareClass<S> {
  final PublishSubject<Action> _onActionSubject = PublishSubject();

  Stream<Action> get onAction => _onActionSubject.stream;

  @override
  void call(Store<S> store, action, NextDispatcher next) {
    if (action is Action) {
      _onActionSubject.add(action);
    }

    next(action);
  }

  void dispose() {
    _onActionSubject.close();
  }
}
