extension StringExtension on String {
  ///This methot returs the string with the first letter in upper case.
  ///If it is empty, it will return null.
  String? capitalize() {
    if (isNotEmpty) {
      return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
    } else {
      return null;
    }
  }
}
