import 'package:flutter/scheduler.dart';
import 'package:flutter_platform_core/action.dart';
import 'package:flutter_platform_core/root_epic.dart';
import 'package:flutter_platform_core/state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

class IncrementStartAction extends Action {}

class IncrementSuccessAction extends Action {}

class IncrementErrorAction extends Action {}

class CounterState implements State {
  final int counter;

  CounterState(this.counter);
}

void main() {
  test('Root epic can check is epic already included', () {
    final rootEpic = RootEpic<CounterState>();
    final counterEpic = createCounterEpic();

    expect(rootEpic.containsEpic(counterEpic), false);

    rootEpic.addEpic(counterEpic);
    expect(rootEpic.containsEpic(counterEpic), true);

    rootEpic.removeEpic(counterEpic);
    expect(rootEpic.containsEpic(counterEpic), false);
  });

  test('Root epic warn about actions with same epic', () {
    final rootEpic = RootEpic<CounterState>();
    final counterEpic = createCounterEpic();

    rootEpic.addEpic(counterEpic);
    expect(
      () => rootEpic.addEpic(counterEpic),
      throwsAssertionError,
    );

    rootEpic.removeEpic(counterEpic);
    expect(
      () => rootEpic.removeEpic(counterEpic),
      throwsAssertionError,
    );
  });
}

Epic<CounterState> createCounterEpic({VoidCallback handler}) {
  return (action$, store) => Observable(action$)
      .whereType<IncrementStartAction>()
      .flatMap((action) => Observable.just(null)
          .doOnData((_) {
            if (handler != null) {
              handler();
            }
          })
          .mapTo<Action>(IncrementSuccessAction())
          .onErrorReturnWith((error) => IncrementErrorAction()));
}
