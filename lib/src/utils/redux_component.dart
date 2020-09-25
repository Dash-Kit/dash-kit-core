import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:dash_kit_core/src/utils/i_redux_component.dart';
import 'package:dash_kit_core/src/utils/redux_config.dart';

class ReduxComponent implements IReduxComponent {
  @override
  void dispatch<T extends GlobalState>(
    Action<T> action, {
    bool notify = true,
  }) {
    assert(
      ReduxConfig.storeProvider != null,
      'ERROR: ReduxConfig.storeProvider is null. '
      'Initialize it before action dispatching',
    );

    ReduxConfig.storeProvider.store.dispatch(action);
  }
}
