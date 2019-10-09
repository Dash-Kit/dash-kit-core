library epic_test_core;

import 'package:flutter_platform_core/flutter_platform_core.dart';
import 'package:redux_epics/redux_epics.dart';

import 'epic_test_session.dart';

EpicTestSession _epicTestSession;

void setupEpicTest<S extends GlobalState>({
  EpicStore<S> epicStore,
  Duration epicBufferTime,
}) {
  _epicTestSession = EpicTestSession();

  _epicTestSession.setupEpicTestSession<S>(
    epicStore: epicStore,
    epicBufferTime: epicBufferTime,
  );
}

void actions(List<Action> actions) {
  _epicTestSession.actions = actions;
}

Stream<dynamic> runEpic<S extends GlobalState>(Epic<S> epic) {
  return _epicTestSession.runEpic<S>(epic);
}

void runAfterEpic(void Function() callback) {
  _epicTestSession.runAfterEpic(callback);
}
