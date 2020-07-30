library epic_test_core;

import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:redux/redux.dart';

import 'epic_test_session.dart';

EpicTestSession _epicTestSession;

void setupEpicTest<S extends GlobalState>({
  Store<S> store,
  Duration epicBufferTime,
}) {
  _epicTestSession = EpicTestSession();

  _epicTestSession.setupEpicTestSession<S>(
    store: store,
    epicBufferTime: epicBufferTime,
  );
}

void actions(List<Action> actions) {
  _epicTestSession.actions = actions;
}

Stream<dynamic> runEpic<S extends GlobalState>(Epic<S> epic) {
  return _epicTestSession.runEpic<S>(epic);
}

Future<void> runAfterEpic(void Function() callback) {
  return _epicTestSession.runAfterEpic(callback);
}
