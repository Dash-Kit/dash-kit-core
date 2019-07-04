import 'package:flutter_platform_core/Action.dart';
import 'package:flutter_platform_core/Reducer.dart';
import 'package:test/test.dart';

class IncrementAction extends Action {}

class DecrementAction extends Action {}

void main() {
  test('Initialization of reducer', () {
    expect(() => Reducer(isRoot: false), returnsNormally);

    expect(
      () => Reducer(isRoot: false, rootReducerAction: (s, a) => s),
      returnsNormally,
    );
    expect(
      () => Reducer(isRoot: false, rootReducerAction: null),
      returnsNormally,
    );

    expect(
      () => Reducer(isRoot: true),
      throwsA(TypeMatcher<AssertionError>()),
    );
    expect(
      () => Reducer(isRoot: true, rootReducerAction: (s, a) => s),
      returnsNormally,
    );
  });

  test('Empty reducer should return the same state', () {
    var reducer = Reducer<int>();

    expect(reducer.reduce(0, IncrementAction()), 0);
    expect(reducer.reduce(10, DecrementAction()), 10);
  });

  test('Increment action should update counter', () {
    var reducer = Reducer<int>()
      ..on<IncrementAction>((state, action) {
        return state + 1;
      });

    expect(reducer.reduce(0, IncrementAction()), 1);
    expect(reducer.reduce(10, DecrementAction()), 10);
    expect(reducer.reduce(-1, IncrementAction()), 0);
  });

  test('Decrement action should update counter', () {
    var reducer = Reducer<int>()
      ..on<DecrementAction>((state, action) {
        return state - 1;
      });

    expect(reducer.reduce(0, IncrementAction()), 0);
    expect(reducer.reduce(10, DecrementAction()), 9);
    expect(reducer.reduce(-1, IncrementAction()), -1);
    expect(reducer.reduce(-1, DecrementAction()), -2);
  });

  test('Increment and Decrement action should update counter', () {
    var reducer = Reducer<int>()
      ..on<IncrementAction>((state, action) {
        return state + 1;
      })
      ..on<DecrementAction>((state, action) {
        return state - 1;
      });

    expect(reducer.reduce(0, IncrementAction()), 1);
    expect(reducer.reduce(10, DecrementAction()), 9);
    expect(reducer.reduce(-1, IncrementAction()), 0);
  });
}
