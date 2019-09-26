import 'package:equatable/equatable.dart';

abstract class Action extends Equatable {
  const Action([List equatableProps = const []]) : super(equatableProps);

  @override
  String toString() {
    var actionName = runtimeType.toString().replaceAll(RegExp(r'Action'), '');
    return 'ACTION `$actionName`';
  }
}
