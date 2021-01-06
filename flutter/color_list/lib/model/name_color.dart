///
/// 有命名的颜色
///
class NameColor {
  NameColor({this.name, this.value});

  final String name;
  final int value;

  @override
  String toString() {
    return 'NameColor{name: $name, value: $value}';
  }
}
