import 'package:equatable/equatable.dart';

abstract class Action with EquatableMixin {
  @override
  String toString() {
    var actionName = runtimeType.toString().replaceAll(RegExp(r'Action'), '');
    return 'ACTION `$actionName`';
  }

  @override
  List get props => [];
}
