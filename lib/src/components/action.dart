import 'package:async_redux/async_redux.dart';
import 'package:equatable/equatable.dart';

abstract class Action<T> extends ReduxAction<T> with EquatableMixin {
  @override
  String toString() {
    var actionName = runtimeType.toString().replaceAll(RegExp(r'Action'), '');
    return 'ACTION `$actionName`';
  }

  @override
  List get props => [];
}
