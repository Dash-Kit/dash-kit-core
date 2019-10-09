import 'package:flutter_platform_core/flutter_platform_core.dart';
import 'package:test/test.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';
import 'package:redux/redux.dart';

class AppState extends GlobalState {
  final int count;

  AppState(this.count);
}

class IncrementAsyncAction extends AsyncAction<int, String> {
  final int initialCount;

  IncrementAsyncAction(this.initialCount);
}

void main() {
  final epic = createEpic();
  final store = Store<AppState>(reducer, initialState: AppState(0));

  setUp(() {
    setupEpicTest(epicStore: EpicStore(store));
  });

  test('Epic test runs successfully', () {
    actions([
      IncrementAsyncAction(0),
    ]);

    expect(
      runEpic(epic),
      emits([
        IncrementAsyncAction(0).complete(1),
      ]),
    );

    expect(store.state.count, 0);

    runAfterEpic(() {
      expect(store.state.count, 1);
    });
  });
}

AppState reducer(AppState state, dynamic action) {
  int count = state?.count;

  if (action is IncrementAsyncAction) {
    action.onSuccess((c) => count = c);
  }

  return AppState(count);
}

Epic<AppState> createEpic() {
  return (action$, store) {
    return Observable(action$).whereType<IncrementAsyncAction>().flatMap(
        (action) => Observable.just(action.complete(action.initialCount + 1))
            .onErrorReturnWith((_) => action.fail('Error')));
  };
}
