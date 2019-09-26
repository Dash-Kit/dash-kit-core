library epic_test_core;

import 'package:flutter_platform_core/action.dart';
import 'package:flutter_platform_core/state.dart';
import 'package:redux_epics/redux_epics.dart';

import 'epic_test_session.dart';

final _epicTestSession = EpicTestSession();

void setupEpicTest({
  EpicStore<State> epicStore,
  Duration epicBufferTime,
}) {
  _epicTestSession.setupEpicTestSession(
    epicStore: epicStore,
    epicBufferTime: epicBufferTime,
  );
}

void actions(List<Action> actions) {
  _epicTestSession.actions = actions;
}

Stream<dynamic> runEpic(Epic<State> epic) {
  return _epicTestSession.runEpic(epic);
}

void runAfterEpic(void Function() callback) {
  _epicTestSession.runAfterEpic(callback);
}
