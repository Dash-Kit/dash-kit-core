import 'dart:async';

import 'package:flutter_platform_core/flutter_platform_core.dart';
import 'package:kt_dart/kt.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

class RootEpic<S extends GlobalState> {
  final _epics = mutableListOf<Epic<S>>();
  final _onEpicsChangedController = StreamController();

  Epic<S> get epic {
    return (action$, store) => Observable(_onEpicsChangedController.stream)
        .flatMap((_) => combineEpics(_epics.asList())(action$, store));
  }

  void addEpic(Epic<S> epic) {
    assert(
      !_epics.contains(epic),
      'The epic was already added',
    );

    if (!_epics.contains(epic)) {
      _epics.add(epic);
      _onEpicsChangedController.add(null);
    }
  }

  void removeEpic(Epic<S> epic) {
    assert(
      _epics.contains(epic),
      'The epic does not connected to root epic',
    );

    _epics.remove(epic);
    _onEpicsChangedController.add(null);
  }

  bool containsEpic(Epic<S> epic) {
    return _epics.contains(epic);
  }

  void dispose() {
    _onEpicsChangedController.close();
  }
}
