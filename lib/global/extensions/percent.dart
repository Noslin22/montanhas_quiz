extension DoubleExtension on double {
  ///This methot returs a int with the round value of the double,.
  ///If it is empty, it will return null.
  String percent() {
    return "${(this * 100).toStringAsFixed(2).contains(".00") ? (this * 100).toStringAsFixed(2).replaceAll(".00", "") : (this * 100).toStringAsFixed(0)}%";
  }
}
