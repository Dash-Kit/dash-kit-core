abstract class Action {
  @override
  String toString() {
    var actionName = runtimeType.toString().replaceAll(RegExp(r'Action'), '');
    return 'ACTION `$actionName`';
  }
}
