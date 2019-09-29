library epic_test_core;

import 'package:flutter_platform_core/flutter_platform_core.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

class EpicTestSession<S extends State> {
  Stream<dynamic> _action$;
  EpicStore<S> _epicStore;
  Duration _epicBufferTime;

  bool _isSetupEpicTestCalled = false;
  bool _isEpicRunning = false;

  set actions(List<Action> actions) {
    _ensureSetupEpicTestCalled();

    if (actions.isEmpty) {
      _throwError('Actions should not be empty');
    }

    _action$ = Stream.fromIterable(actions).asBroadcastStream();
  }

  void setupEpicTestSession({
    EpicStore<S> epicStore,
    Duration epicBufferTime,
  }) {
    _isEpicRunning = false;

    _action$ = null;
    _epicBufferTime = epicBufferTime ?? Duration(milliseconds: 50);

    _epicStore = epicStore;
    _isSetupEpicTestCalled = true;
  }

  Stream<dynamic> runEpic(Epic<S> epic) {
    _ensureSetupEpicTestCalled();
    _ensureEpicRunningOnlyOnceForTest();
    _ensureEpicSessionValid();

    _isEpicRunning = true;

    return Observable(epic(_action$, _epicStore)).bufferTime(_epicBufferTime);
  }

  void runAfterEpic(void Function() callback) {
    _ensureSetupEpicTestCalled();
    _ensureEpicIsRunning();

    Future.delayed(_epicBufferTime).then((_) {
      if (callback != null) {
        callback();
      }
    });
  }

  void _ensureSetupEpicTestCalled() {
    if (!_isSetupEpicTestCalled) {
      _throwError(
        '\'setupEpicTest\' should be called in \'setUp\' stage of the test',
      );
    }
  }

  void _ensureEpicRunningOnlyOnceForTest() {
    if (_isEpicRunning) {
      _throwError('Epic can be run only once for test');
    }
  }

  void _ensureEpicSessionValid() {
    if (_epicBufferTime == null) {
      _throwError('Epic buffer time can not be null');
    }

    if (_epicStore == null) {
      _throwError(
          'Epic Store can not be null. Set Epic Store in setup stage of the test');
    }

    if (_action$ == null) {
      _throwError('Actions should be set before running epic');
    }
  }

  void _ensureEpicIsRunning() {
    if (!_isEpicRunning) {
      _throwError('Epic was not running');
    }
  }

  void _throwError(String message) {
    assert(message != null);

    throw Exception(
      'EPIC TEST ERROR: $message',
    );
  }
}
