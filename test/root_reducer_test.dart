import 'package:flutter_platform_core/flutter_platform_core.dart';
import 'package:flutter_test/flutter_test.dart' as flutter_test;
import 'package:test/test.dart';

class CounterState implements State {
  final int counter;

  CounterState(this.counter);
}

class IncrementAction extends Action {}

class DecrementAction extends Action {}

void main() {
  test('Initial state of root reducer', () {
    final rootReducer = RootReducer<CounterState>();
    var appState = CounterState(0);

    appState = rootReducer.reduce(appState, IncrementAction());

    expect(appState.counter, 0);
  });

  test('Root reducer can add and remove reducer', () {
    final rootReducer = RootReducer<CounterState>();
    final counterReducer = createCounterReducer();
    var appState = CounterState(0);

    appState = rootReducer.reduce(appState, IncrementAction());
    expect(appState.counter, 0);

    rootReducer.addReducer(counterReducer);
    appState = rootReducer.reduce(appState, IncrementAction());
    expect(appState.counter, 1);

    rootReducer.removeReducer(counterReducer);
    appState = rootReducer.reduce(appState, IncrementAction());
    expect(appState.counter, 1);
  });

  test('Root reducer can check is reducer already included', () {
    final rootReducer = RootReducer<CounterState>();
    final counterReducer = createCounterReducer();

    expect(rootReducer.containsReducer(counterReducer), false);

    rootReducer.addReducer(counterReducer);
    expect(rootReducer.containsReducer(counterReducer), true);

    rootReducer.removeReducer(counterReducer);
    expect(rootReducer.containsReducer(counterReducer), false);
  });

  test('Root reducer warn about actions with same reducer', () {
    final rootReducer = RootReducer<CounterState>();
    final counterReducer = createCounterReducer();

    rootReducer.addReducer(counterReducer);
    expect(
      () => rootReducer.addReducer(counterReducer),
      flutter_test.throwsAssertionError,
    );

    rootReducer.removeReducer(counterReducer);
    expect(
      () => rootReducer.removeReducer(counterReducer),
      flutter_test.throwsAssertionError,
    );
  });
}

Reducer<CounterState> createCounterReducer() {
  return Reducer<CounterState>()
    ..on<IncrementAction>(
      (state, action) => CounterState(state.counter + 1),
    )
    ..on<DecrementAction>(
      (state, action) => CounterState(state.counter - 1),
    );
}
