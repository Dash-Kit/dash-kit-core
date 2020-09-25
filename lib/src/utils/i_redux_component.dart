import 'package:dash_kit_core/dash_kit_core.dart';

abstract class IReduxComponent {
  void dispatch<T extends GlobalState>(
    Action<T> action, {
    bool notify = true,
  }) {}
}
