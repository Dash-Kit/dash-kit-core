import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:test/test.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';
import 'package:redux/redux.dart';

class AppState extends GlobalState {
  final int count;

  AppState(this.count);
}

class IncrementAsyncAction extends AsyncAction<int> {
  final int initialCount;

  IncrementAsyncAction(this.initialCount);
}

void main() {
  final epic = createEpic();
  final store = Store<AppState>(reducer, initialState: AppState(0));

  setUp(() {
    setupEpicTest(store: store);
  });

  test('Epic test runs successfully', () async {
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

    await runAfterEpic(() {
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
    return action$
        .whereType<IncrementAsyncAction>()
        .where((action) => action.isStarted)
        .flatMap((action) {
      final count = action.initialCount + 1;

      return Stream.value(action.complete(count))
          .onErrorReturnWith(action.fail);
    });
  };
}
