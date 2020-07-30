import 'package:dash_kit_core/src/components/state.dart';
import 'package:dash_kit_core/src/components/store_provider.dart';

abstract class ReduxConfig {
  static StoreProvider<GlobalState> storeProvider;
}
