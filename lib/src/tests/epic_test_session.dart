library epic_test_core;

import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';
import 'package:redux/redux.dart';

class EpicTestSession {
  Stream<dynamic> _action$;
  Store _store;
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

  void setupEpicTestSession<S extends GlobalState>({
    Store<S> store,
    Duration epicBufferTime,
  }) {
    _isEpicRunning = false;

    _action$ = null;
    _epicBufferTime = epicBufferTime ?? Duration(milliseconds: 50);

    _store = store;
    _isSetupEpicTestCalled = true;
  }

  Stream<dynamic> runEpic<S extends GlobalState>(Epic<S> epic) {
    _ensureSetupEpicTestCalled();
    _ensureEpicRunningOnlyOnceForTest();
    _ensureEpicSessionValid();

    _isEpicRunning = true;

    final epicStore = EpicStore<S>(_store);
    final actionStream = epic(_action$, epicStore);

    return actionStream.doOnData(_store.dispatch).bufferTime(_epicBufferTime);
  }

  Future<void> runAfterEpic(void Function() callback) {
    _ensureSetupEpicTestCalled();
    _ensureEpicIsRunning();

    return Future.delayed(_epicBufferTime).then((_) {
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

    if (_store == null) {
      _throwError(
          'Store can not be null. Set Store in setup stage of the test');
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
