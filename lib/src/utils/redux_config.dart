import 'package:flutter_platform_core/src/components/state.dart';
import 'package:flutter_platform_core/src/components/store_provider.dart';

abstract class ReduxConfig {
  static StoreProvider<GlobalState> storeProvider;
}
